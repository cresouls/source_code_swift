//
//  VerifyVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 15/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

//MARK: - Factory Protocol
protocol VerifyVMFactory: VMFactory {
    var _countryCode: String? { get }
    var _mobile: String? { get }
    func createVerifyVM(_ countryCode: String, mobile: String) -> VerifyVM
    func getVerifyVM() -> VerifyVM?
}

extension VerifyVMFactory {
    func createVerifyVM(_ countryCode: String, mobile: String) -> VerifyVM {
        return VerifyVM(countryCode, mobile: mobile)
    }
    
    func getVerifyVM() -> VerifyVM? {
        guard let _countryCode = _countryCode,
            let _mobile = _mobile else {
                return nil
        }
        return createVerifyVM(_countryCode, mobile: _mobile)
    }
    
}

//MARK: - State
struct VerifyState {
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
        case generateOTP
        case resendOTP
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

//MARK: - Class
class VerifyVM {
    private var countryCode: String
    private var mobile: String
    private var serverOTP: String?
    var otp: Dynamic<String> = Dynamic("")
    
    private(set) var state = VerifyState() {
        didSet {
            callback?(state)
        }
    }
    
    var callback: ((VerifyState) -> ())?
    
    init(_ countryCode: String, mobile: String) {
        self.countryCode = countryCode
        self.mobile = mobile
    }
    
    deinit {
        print("Verify VM deinited")
    }
}


//MARK: - Functions
extension VerifyVM {
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
extension VerifyVM {
    func generateOTP() {
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
        guard let _serverOTP = serverOTP else {
            state.action = .other(.resendOTP, "Couldn't verify mobile number.")
            return
        }
        let param = ["country_code": countryCode, "mobile": mobile, "otp": _serverOTP]
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
extension VerifyVM: SignUpVMFactory {
    var _countryCode: String? {
        return countryCode
    }
    var _mobile: String? {
        return mobile
    }
}
