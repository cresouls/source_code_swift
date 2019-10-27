//
//  SignUpVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 16/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, NibLoadable {

    //MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UnderlinedTextField! {
        didSet {
            nameTextField.textColor = Theme.c2
            nameTextField.underlineColor = Theme.c2
            nameTextField.placeholderColor = Theme.c2
            nameTextField.font = Font.h5
            
            nameTextField.returnKeyType = .next
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var emailTextField: UnderlinedTextField! {
        didSet {
            emailTextField.textColor = Theme.c2
            emailTextField.underlineColor = Theme.c2
            emailTextField.placeholderColor = Theme.c2
            emailTextField.font = Font.h5
            
            emailTextField.keyboardType = .emailAddress
            emailTextField.returnKeyType = .next
            emailTextField.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTextField: UnderlinedTextField! {
        didSet {
            passwordTextField.textColor = Theme.c2
            passwordTextField.underlineColor = Theme.c2
            passwordTextField.placeholderColor = Theme.c2
            passwordTextField.font = Font.h5
            
            passwordTextField.returnKeyType = .next
            passwordTextField.isSecureTextEntry = true
            passwordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var confirmPasswordTextField: UnderlinedTextField! {
        didSet {
            confirmPasswordTextField.textColor = Theme.c2
            confirmPasswordTextField.underlineColor = Theme.c2
            confirmPasswordTextField.placeholderColor = Theme.c2
            confirmPasswordTextField.font = Font.h5
            
            confirmPasswordTextField.returnKeyType = .next
            confirmPasswordTextField.isSecureTextEntry = true
            confirmPasswordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var cityTextField: UnderlinedTextField! {
        didSet {
            cityTextField.textColor = Theme.c2
            cityTextField.underlineColor = Theme.c2
            cityTextField.placeholderColor = Theme.c2
            cityTextField.font = Font.h5
            
            cityTextField.returnKeyType = .default
            cityTextField.delegate = self
        }
    }
    
    @IBOutlet weak var categoryTextField: UnderlinedTextField! {
        didSet {
            categoryTextField.textColor = Theme.c2
            categoryTextField.underlineColor = Theme.c2
            categoryTextField.placeholderColor = Theme.c2
            categoryTextField.font = Font.h5
            
            categoryTextField.returnKeyType = .default
            categoryTextField.delegate = self
        }
    }
    
    @IBOutlet weak var referralTextField: UnderlinedTextField! {
        didSet {
            referralTextField.textColor = Theme.c2
            referralTextField.underlineColor = Theme.c2
            referralTextField.placeholderColor = Theme.c2
            referralTextField.font = Font.h5
            
            referralTextField.returnKeyType = .default
            referralTextField.delegate = self
        }
    }
    
    @IBOutlet weak var isCheckedButton: UIButton!
    @IBOutlet weak var submitButton: RoundedButton! {
        didSet {
            submitButton.backgroundColor = Theme.c2
            submitButton.titleLabel?.textColor = Theme.c1
            submitButton.titleLabel?.font = Font.h3
        }
    }
    
    @IBOutlet weak var termsButton: UIButton! {
        didSet {
            termsButton.titleLabel?.textColor = Theme.c2
            termsButton.titleLabel?.font = Font.h8
            
            termsButton.underlineButton(text: termsButton.title(for: .normal)!)
        }
    }
    
    //MARK: - Properties
    var vm: SignUpVM?
    private lazy var hud = Hud(color: Theme.c7)
    var currentResponsder: UIView?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addMenuPopDismissButton()
        bindViewModel()
        
        vm?.callback = { [unowned self] (state) in
            switch state.action {
            case .none:
                print("none")
            case .onCall:
                self.hud.start()
            case .onSuccess(_, let message):
                self.hud.stop()
                self.showAutoDismissAlert(nil, message: message) {
                    self.goToLogin()
                }
            case .onFailed(let message):
                self.hud.stop()
                self.showAlert("Error", message: message)
            case .other(let message):
                self.hud.stop()
                self.showAutoDismissAlert(nil, message: message)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardNotifications(shouldRegister: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardNotifications(shouldRegister: false)
    }
    
    deinit {
        print("Signup VC deinited")
    }
    
    //MARK: - IBActions
    @IBAction func roundedButtonActions(_ sender: RoundedButton) {
        if sender == submitButton {
            vm?.register()
        }
    }
    
    @IBAction func buttonActions(_ sender: UIButton) {
        if sender == termsButton {
            //goToTerms()
        }
    }
    
}

//MARK: - Bind
extension SignUpVC {
    func bindViewModel() {
        //to view model
        nameTextField.bind { [unowned self] in
            self.vm?.name.value = $0
        }
        emailTextField.bind { [unowned self] in
            self.vm?.email.value = $0
        }
        passwordTextField.bind { [unowned self] in
            self.vm?.password.value = $0
        }
        confirmPasswordTextField.bind { [unowned self] in
            self.vm?.confirmPassword.value = $0
        }
        referralTextField.bind { [unowned self] in
            self.vm?.referral.value = $0
        }
        
        isCheckedButton.bind { [unowned self] in
            self.vm?.isAgreed.value = $0
        }
        
        //to view controller
        vm?.city.bind = { [unowned self] in
            self.cityTextField.text = $0.name
        }
        
        vm?.categories.bind = { [unowned self] in
            let categoryNames = $0.map { $0.name }
            self.categoryTextField.text = categoryNames.joined(separator: ", ")
        }
    }
}

//MARK: - UITextFieldDelegate
extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        }
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == cityTextField {
            let selectCityVM = vm?.getSelectCityVM()
            if let _vm = selectCityVM {
                self.goToSelectCity(vm: _vm)
            }
            return false
        } else if textField == categoryTextField {
            let selectCategoriesVM = vm?.getSelectCategoriesVM() { [unowned self] error in
                self.showAlert("Error", message: error)
            }
            if let _vm = selectCategoriesVM {
                self.goToSelectCategories(vm: _vm)
            }
            return false
        }
        currentResponsder = textField
        return true
    }
}

//MARK: - KeyboardObserver
extension SignUpVC: KeyboardObserver {
    var container: UIView {
        return self.scrollView
    }
    
    var firstResponder: UIView? {
        return currentResponsder
    }
}

//MARK: - DefaultAlert
extension SignUpVC: DefaultAlert { }

//MARK: - AutoDismissAlert
extension SignUpVC: AutoDismissAlert { }

//MARK: - SelectCityRouter
extension SignUpVC: SelectCityRouter { }

//MARK: - SelectCategoriesRouter
extension SignUpVC: SelectCategoriesRouter { }

//MARK: - LoginRouter
extension SignUpVC: LoginRouter { }

//MARK: - TermsNonMenuRouter
extension SignUpVC: TermsNonMenuRouter { }

//MARK: - PopToRoot
extension SignUpVC: PopToRoot { }
