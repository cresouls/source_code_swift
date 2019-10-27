//
//  EditProfileVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 20/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation
import UIKit

//MARK: - State
struct EditProfileState {
    enum Action {
        case none
        case onCall
        case onSuccess(Api)
        case onFailed(String)
        case other(String)
    }
    
    enum Api {
        case uploadDp
        case submitData
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

//MARK: - Class
class EditProfileVM {
    var firstName: Dynamic<String> = Dynamic(LocalUser.instance.firstName)
    var lastName: Dynamic<String> = Dynamic(LocalUser.instance.lastName)
    var email: Dynamic<String> = Dynamic(LocalUser.instance.email)
    var dpURL: Dynamic<URL> = Dynamic(LocalUser.instance.dpURL)

    private(set) var state = EditProfileState() {
        didSet {
            callback?(state)
        }
    }
    
    var callback: ((EditProfileState) -> ())?
    
    init() {
    }
    
    deinit {
        print("EditProfile VM deinited")
    }
}

//MARK: - API Functions
extension EditProfileVM {
    func submitData() {
        let validate = isValid()
        if validate.0 {
            state.action = .onCall
            let param = ["sp_id": LocalUser.instance.id!, "sp_first_name": firstName.value!, "sp_last_name": lastName.value!, "sp_email_id": email.value!]
            print(param)
            HTTPManager.instance.updateProfile(param: param, completionHandler: { [unowned self] (result) in
                switch result {
                case .success(_):
                    self.getProviderProfile(.submitData)
                    //self.state.action = .onSuccess(.submitData)
                case .failure(let error):
                    self.state.action = .onFailed(error.description)
                }
            })
        } else {
            guard let message = validate.1?.description else { return }
            state.action = .other(message)
        }
    }
    
    func uploadDp(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                state.action = .other("Couldn't upload your display picture.")
                return
        }
        state.action = .onCall
        let param = ["sp_id": LocalUser.instance.id!]
        HTTPManager.instance.updateDp(imageData: imageData, param: param) { [unowned self] (result) in
            switch result {
            case .success(_):
                self.getProviderProfile(.uploadDp)
                //self.state.action = .onSuccess(.uploadDp)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    func getProviderProfile(_ api: EditProfileState.Api) {
        switch state.action {
        case .onCall:
            print("no action")
        default:
            state.action = .onCall
        }
        let param: [String : Any] = ["provider_id": LocalUser.instance.id!]
        HTTPManager.instance.getProviderProfile(param: param, completionHandler: { [unowned self] (result) in
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: Notification.Name.profileUpdated,
                                                object: self,
                                                userInfo: nil)
                self.state.action = .onSuccess(api)
            case .failure(let error):
                print(error.description)
            }
        })
    }
}

//MARK: - FormValidatable
extension EditProfileVM: FormValidatable {
    func isValid() -> (Bool, ValidationError?) {
        if firstName.value!.isEmpty {
            return (false, .emptyFields("Please enter first name"))
        } else if lastName.value!.isEmpty {
            return (false, .emptyFields("Please enter last name"))
        } else if email.value!.isEmpty {
            return (false, .emptyFields("Please enter email"))
        } else if !email.value!.isValidEmail {
            return(false, .invalidEmail)
        }
        return (true, nil)
    }
}
