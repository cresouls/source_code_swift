//
//  ForgotPasswordVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 24/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

//MARK: - State
struct ForgotPasswordState {
    enum Action {
        case none
        case onCall(Api)
        case onSuccess(Api)
        case onFailed(Api, String)
        case other(Api, String)
        case verifySuccess
        case verifyFailed(String?, String)
    }
    
    enum Api {
        case verifyMobile(Bool)
        case generateOTP
        case resendOTP
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

//MARK: - Class
class ForgotPasswordVM {
    var countryCode: String?
    var mobile: Dynamic<String> = Dynamic("")
    private var serverOTP: String?
    var otp: Dynamic<String> = Dynamic("")
    
    private(set) var state = ForgotPasswordState() {
        didSet {
            callback?(state)
        }
    }
    
    var callback: ((ForgotPasswordState) -> ())?
    
    init() {
    }
    
    deinit {
        print("Login VM deinited")
    }
}

//MARK: - Functions
extension ForgotPasswordVM {
    func checkMobileNumber() {
        guard let _countryCode = countryCode,
            let _mobile = mobile.value else {
                state.action = .other(.verifyMobile(false), "Couldn't verify mobile number.")
                return
        }
        self.verifyMobile(_countryCode, mobile: _mobile)
    }
    
    func verifyMobileWithOTP() {
        guard let _serverOTP = serverOTP,
            let _otp = otp.value else {
                state.action = .verifyFailed(nil, "Couldn't verify mobile number.")
                return
        }
        if _serverOTP == _otp {
            state.action = .verifySuccess
        } else {
            state.action = .verifyFailed("Incorrect OTP", "Please check the OTP entered")
        }
    }
}

//MARK: - API Functions
extension ForgotPasswordVM {

    private func verifyMobile(_ countryCode: String, mobile: String) {
        switch state.action {
        case .onCall:
            print("in call")
        default:
            state.action = .onCall(.verifyMobile(false))
        }
        let param = ["country_code": countryCode, "mobile": mobile]
        HTTPManager.instance.verifyMobile(param: param, completionHandler: { [unowned self] (result) in
            switch result {
            case .success(let data):
                if data {
                    self.generateOTP(countryCode, mobile: mobile)
                }
                self.state.action = .onSuccess(.verifyMobile(data))
            case .failure(let error):
                self.state.action = .onFailed(.verifyMobile(false), error.description)
            }
        })
    }
    
    func generateOTP(_ countryCode: String, mobile: String) {
        state.action = .onCall(.generateOTP)
        let param = ["country_code": countryCode, "mobile": mobile]
        HTTPManager.instance.generateOTP(param: param) { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.serverOTP = data
                self.state.action = .onSuccess(.generateOTP)
            case .failure(let error):
                self.state.action = .onFailed(.generateOTP, error.description)
            }
        }
    }
    
    func resendOTP() {
        guard let _serverOTP = serverOTP,
            let _countryCode = countryCode,
            let _mobile = mobile.value else {
            state.action = .other(.resendOTP, "Couldn't verify mobile number.")
            return
        }
        let param = ["country_code": _countryCode, "mobile": _mobile, "otp": _serverOTP]
        HTTPManager.instance.resendOTP(param: param) { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.serverOTP = data
                self.state.action = .onSuccess(.resendOTP)
            case .failure(let error):
                self.state.action = .onFailed(.generateOTP, error.description)
            }
        }
    }
}


//MARK: - VerifyVMFactory
extension ForgotPasswordVM: ChangePasswordVMFactory {
    var _countryCode: String? {
        return countryCode
    }
    var _mobile: String? {
        return mobile.value
    }
}
