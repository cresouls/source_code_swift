//
//  SignUpVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 17/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

//MARK: - Factory Protocol
protocol SignUpVMFactory: VMFactory {
    var _countryCode: String? { get }
    var _mobile: String? { get }
    func createSignUpVM(_ countryCode: String, mobile: String) -> SignUpVM
    func getSignUpVM() -> SignUpVM?
}

extension SignUpVMFactory {
    func createSignUpVM(_ countryCode: String, mobile: String) -> SignUpVM {
        return SignUpVM(countryCode, mobile: mobile)
    }
    
    func getSignUpVM() -> SignUpVM? {
        guard let _countryCode = _countryCode,
            let _mobile = _mobile else {
                return nil
        }
        return createSignUpVM(_countryCode, mobile: _mobile)
    }
    
}

//MARK: - State
struct SignUpState {
    enum Action {
        case none
        case onCall
        case onSuccess(Api, String)
        case onFailed(String)
        case other(String)
    }
    
    enum Api {
        case signUp
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

//MARK: - Class
class SignUpVM {
    private var countryCode: String
    private var mobile: String
    var name: Dynamic<String> = Dynamic("")
    var email: Dynamic<String> = Dynamic("")
    var password: Dynamic<String> = Dynamic("")
    var confirmPassword: Dynamic<String> = Dynamic("")
    var city: Dynamic<City> = Dynamic(nil)
    var categories: Dynamic<[Category]> = Dynamic([])
    var referral: Dynamic<String> = Dynamic("")
    var isAgreed: Dynamic<Bool> = Dynamic(false)
    
    private(set) var state = SignUpState() {
        didSet {
            callback?(state)
        }
    }
    
    var callback: ((SignUpState) -> ())?
    
    init(_ countryCode: String, mobile: String) {
        self.countryCode = countryCode
        self.mobile = mobile
    }
}

//MARK: - API Functions
extension SignUpVM {
    func register() {
        let validate = isValid()
        if validate.0 {
            state.action = .onCall
            let categoryIds = categories.value!.map { $0.id }
            let categoryIdsString = categoryIds.joined(separator: ",")
            let param: [String : Any] = ["country_code": countryCode, "mobile": mobile, "name": name.value!, "email": email.value!, "password": password.value!, "city": city.value!.id, "category":  categoryIdsString, "code": referral.value ?? "", "platform": Settings.platform]
            print(param)
            HTTPManager.instance.signUp(param: param, completionHandler: { [unowned self] (result) in
                switch result {
                case .success(_):
                    self.linkUserWithKey()
                case .failure(let error):
                    self.state.action = .onFailed(error.description)
                }
            })
        } else {
            guard let message = validate.1?.description else { return }
            state.action = .other(message)
        }
    }
    
    private func linkUserWithKey() {
        //just in case
        //not checking it pre-login
        guard let id = LocalUser.instance.id, let key = Settings.sessionKey else {
            state.action = .other("Session key or provider id is missing")
            return
        }
        let param = ["provider_id": id, "key": key]
        print(key)
        HTTPManager.instance.updateKey(param: param) { [unowned self] (result) in
            switch result {
            case .success(_):
                self.state.action = .onSuccess(.signUp, "You have successfully registered. We will review your account shortly.")
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
}

//MARK: - FormValidatable
extension SignUpVM: FormValidatable {
    func isValid() -> (Bool, ValidationError?) {
        guard !name.value!.isEmpty,
            !email.value!.isEmpty,
            !password.value!.isEmpty,
            !confirmPassword.value!.isEmpty,
            let _ = city.value,
            !categories.value!.isEmpty else {
            return (false, .emptyFields("Please enter all mandatory fields"))
        }
        if !email.value!.isValidEmail {
            return(false, .invalidEmail)
        }
        if password.value! != confirmPassword.value! {
            return(false, .passwordNotMatch)
        }
        
        if !isAgreed.value! {
            return(false, .notAgreedTerms)
        }
        return (true, nil)
    }
}

//MARK: - SelectCityVMDelegate
extension SignUpVM: SelectCityVMDelegate {
    func selectedCity(_ city: City) {
        self.city.setValue(city)
        //clear categories when change city
        self.categories.setValue([])
    }
}

//MARK: - SelectCityVMFactory
extension SignUpVM: SelectCityVMFactory {
    var _selectedCity: City? {
        return city.value
    }
    
    var _selectCityVMDelegate: SelectCityVMDelegate? {
        return self
    }
}

//MARK: - SelectCategoriesVMDelegate
extension SignUpVM: SelectCategoriesVMDelegate {
    func selectedCategories(_ categories: [Category]) {
        self.categories.setValue(categories)
    }
}

//MARK: - SelectCategoriesVMFactory
extension SignUpVM: SelectCategoriesVMFactory {
    var _cityId: String? {
        return city.value?.id
    }
    
    var _selectedCategories: [Category] {
        return categories.value ?? []
    }
    
    var _selectCategoriesVMDelegate: SelectCategoriesVMDelegate? {
        return self
    }
}
