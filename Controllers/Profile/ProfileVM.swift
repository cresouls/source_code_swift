//
//  ProfileVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 19/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

//MARK: - State
struct ProfileState {
    enum Action {
        case none
        case onCall
        case onSuccess(Api)
        case onFailed(String)
        case other(String)
    }
    
    enum Api {
        case providerProfile
        case submitHelpData
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

//MARK: - Class
class ProfileVM {
    var name: Dynamic<String> = Dynamic(LocalUser.instance.name)
    var mobile: Dynamic<String> = Dynamic(LocalUser.instance.mobile)
    var email: Dynamic<String> = Dynamic(LocalUser.instance.email)
    var referralCode: Dynamic<String> = Dynamic(LocalUser.instance.referralCode)
    var dpURL: Dynamic<URL> = Dynamic(LocalUser.instance.dpURL)
    
    var subject: Dynamic<String> = Dynamic("")
    var yourText: Dynamic<String> = Dynamic("")
    
    private(set) var state = ProfileState() {
        didSet {
            callback?(state)
        }
    }
    
    var callback: ((ProfileState) -> ())?
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(profileUpdated),
                                               name: Notification.Name.profileUpdated,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.profileUpdated,
                                                  object: nil)
        print("Profile VM deinited")
    }
}

//MARK: - Functions
extension ProfileVM {
    @objc func profileUpdated() {
        updateData()
    }
    
    private func updateData() {
        self.name.setValue(LocalUser.instance.name)
        self.mobile.setValue(LocalUser.instance.mobile)
        self.email.setValue(LocalUser.instance.email)
        self.referralCode.setValue(LocalUser.instance.referralCode)
        self.dpURL.setValue(LocalUser.instance.dpURL)
    }
}

//MARK: - API Functions
extension ProfileVM {
    func getProviderProfile() {
        state.action = .onCall
        let param: [String : Any] = ["provider_id": LocalUser.instance.id!]
        HTTPManager.instance.getProviderProfile(param: param, completionHandler: { [unowned self] (result) in
            switch result {
            case .success(_):
                self.updateData()
                self.state.action = .onSuccess(.providerProfile)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        })
    }
    
    func submitHelpData() {
        let validate = isValid()
        if validate.0 {
            state.action = .onCall
            let param = ["provider": LocalUser.instance.id!, "type": "2", "subject": subject.value!, "message": yourText.value!]
            print(param)
            HTTPManager.instance.addEnquiry(param: param, completionHandler: { [unowned self] (result) in
                switch result {
                case .success(_):
                    self.subject.setValue("")
                    self.yourText.setValue("")
                    self.state.action = .onSuccess(.submitHelpData)
                case .failure(let error):
                    self.state.action = .onFailed(error.description)
                }
            })
        } else {
            guard let message = validate.1?.description else { return }
            state.action = .other(message)
        }
    }
}

//MARK: - FormValidatable
extension ProfileVM: FormValidatable {
    func isValid() -> (Bool, ValidationError?) {
        guard !subject.value!.isEmpty,
            !yourText.value!.isEmpty else {
                return (false, .emptyFields("Please enter all mandatory fields"))
        }
        return (true, nil)
    }
}
