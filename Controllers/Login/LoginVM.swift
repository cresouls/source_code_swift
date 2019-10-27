//
//  LoginVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 04/06/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

//MARK: - State
struct LoginState {
    enum Action {
        case none
        case onCall
        case onSuccess(Api)
        case onFailed(String)
        case other(String)
    }
    
    enum Api {
        case createKey
        case verifyMobile(Bool)
        case login
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

//MARK: - Class
class LoginVM {
    var countryCode: String?
    var mobile: Dynamic<String> = Dynamic("")
    var password: Dynamic<String> = Dynamic("")
    
    private(set) var state = LoginState() {
        didSet {
            callback?(state)
        }
    }
    
    var callback: ((LoginState) -> ())?
    
    init() {
    }
    
    deinit {
        print("Login VM deinited")
    }
}

//MARK: - Functions
extension LoginVM {
    func checkMobileNumber() {
        guard let _countryCode = countryCode,
            let _mobileNumber = mobile.value else {
                state.action = .other("Couldn't verify mobile number.")
                return
        }
        if let _ = Settings.sessionKey {
            self.verifyMobile(_countryCode, mobileNumber: _mobileNumber)
        } else {
            createKey {
                self.verifyMobile(_countryCode, mobileNumber: _mobileNumber)
            }
        }
        
    }
    
    func submitData() {
        let validate = isValid()
        if validate.0 {
            self.login()
        } else {
            guard let message = validate.1?.description else { return }
            state.action = .other(message)
        }
    }
    
    func startSession() {
        createKey() { }
    }
}

//MARK: - API Functions
extension LoginVM {
    private func createKey(_ completion: @escaping (() -> Void)) {
        state.action = .onCall
        let param = ["provider_id": "1", "device_id": "test", "firebase_token": LocalUser.instance.notificationId!, "app_version": Settings.version, "platform": Settings.platform]
        print(param)
        HTTPManager.instance.createKey(param: param) { [unowned self] (result) in
            switch result {
            case .success(_):
                self.state.action = .onSuccess(.createKey)
                completion()
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    private func verifyMobile(_ countryCode: String, mobileNumber: String) {
        state.action = .onCall
        let param = ["country_code": countryCode, "mobile": mobileNumber]
        HTTPManager.instance.verifyMobile(param: param, completionHandler: { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.state.action = .onSuccess(.verifyMobile(data))
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        })
    }
    
    private func login() {
        state.action = .onCall
        let param = ["mobile": mobile.value!, "password": password.value!]
        print(param)
        HTTPManager.instance.login(param: param, completionHandler: { [unowned self] (result) in
            switch result {
            case .success(_):
                self.linkUserWithKey()
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        })
    }
    
    private func linkUserWithKey() {
        //just in case
        //not checking it pre-login
        guard let id = LocalUser.instance.id, let key = Settings.sessionKey else {
            state.action = .other("Session key or user id is missing")
            return
        }
        let param = ["provider_id": id, "key": key]
        HTTPManager.instance.updateKey(param: param) { [unowned self] (result) in
            switch result {
            case .success(_):
                self.state.action = .onSuccess(.login)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
}

//MARK: - FormValidatable
extension LoginVM: FormValidatable {
    func isValid() -> (Bool, ValidationError?) {
        if mobile.value!.isEmpty {
            return (false, .emptyFields("Please enter mobile"))
        } else if password.value!.isEmpty {
            return (false, .emptyFields("Please enter password"))
        }
        return (true, nil)
    }
}

//MARK: - VerifyVMFactory
extension LoginVM: VerifyVMFactory {
    var _countryCode: String? {
        return countryCode
    }
    var _mobile: String? {
        return mobile.value
    }
}

