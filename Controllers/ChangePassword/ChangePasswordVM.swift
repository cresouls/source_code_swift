//
//  ChangePasswordVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 24/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

//MARK: - Factory Protocol
protocol ChangePasswordVMFactory: VMFactory {
    var _countryCode: String? { get }
    var _mobile: String? { get }
    func createChangePasswordVM(_ countryCode: String, mobile: String) -> ChangePasswordVM
    func getChangePasswordVM() -> ChangePasswordVM?
}

extension ChangePasswordVMFactory {
    func createChangePasswordVM(_ countryCode: String, mobile: String) -> ChangePasswordVM {
        return ChangePasswordVM(countryCode, mobile: mobile)
    }
    
    func getChangePasswordVM() -> ChangePasswordVM? {
        guard let _countryCode = _countryCode,
            let _mobile = _mobile else {
                return nil
        }
        return createChangePasswordVM(_countryCode, mobile: _mobile)
    }
    
}

//MARK: - State
struct ChangePasswordState {
    enum Action {
        case none
        case onCall
        case onSuccess(Api, String)
        case onFailed(String)
        case other(String)
    }
    
    enum Api {
        case changePassword
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

//MARK: - Class
class ChangePasswordVM {
    private var countryCode: String
    private var mobile: String
    var password: Dynamic<String> = Dynamic("")
    var confirmPassword: Dynamic<String> = Dynamic("")
    
    private(set) var state = ChangePasswordState() {
        didSet {
            callback?(state)
        }
    }
    
    var callback: ((ChangePasswordState) -> ())?
    
    init(_ countryCode: String, mobile: String) {
        self.countryCode = countryCode
        self.mobile = mobile
    }
}

//MARK: - API Functions
extension ChangePasswordVM {
    func submitData() {
        let validate = isValid()
        if validate.0 {
            state.action = .onCall
            let param: [String : Any] = ["country_code": countryCode, "mobile": mobile, "password": password.value!]
            print(param)
            HTTPManager.instance.forgotPassword(param: param, completionHandler: { [unowned self] (result) in
                switch result {
                case .success(_):
                    self.state.action = .onSuccess(.changePassword, "You have successfully changed your password. Redirecting to login.")
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
extension ChangePasswordVM: FormValidatable {
    func isValid() -> (Bool, ValidationError?) {
        guard !password.value!.isEmpty,
            !confirmPassword.value!.isEmpty else {
                return (false, .emptyFields("Please enter all mandatory fields"))
        }
        if password.value! != confirmPassword.value! {
            return(false, .passwordNotMatch)
        }
        return (true, nil)
    }
}
