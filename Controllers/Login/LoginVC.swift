//
//  LoginVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 08/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, NibLoadable {

    //MARK: - IBOutlets
    @IBOutlet weak var mobileTextField: UnderlinedTextField! {
        didSet {
            mobileTextField.textColor = Theme.c2
            mobileTextField.underlineColor = Theme.c2
            mobileTextField.placeholderColor = Theme.c2
            mobileTextField.font = Font.h5
            mobileTextField.leadingText = Settings.countryCode
            
            mobileTextField.keyboardType = .numberPad
            mobileTextField.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTextField: UnderlinedTextField! {
        didSet {
            passwordTextField.textColor = Theme.c2
            passwordTextField.underlineColor = Theme.c2
            passwordTextField.placeholderColor = Theme.c2
            passwordTextField.font = Font.h5
            
            passwordTextField.returnKeyType = .default
            passwordTextField.isSecureTextEntry = true
            passwordTextField.delegate = self
            
            passwordTextField.isHidden = true
        }
    }
    
    @IBOutlet weak var forgotPasswordButton: UIButton! {
        didSet {
            forgotPasswordButton.titleLabel?.textColor = Theme.c2
            forgotPasswordButton.titleLabel?.font = Font.h8
        }
    }
    
    @IBOutlet weak var submitButton: RoundedButton! {
        didSet {
            submitButton.backgroundColor = Theme.c2
            submitButton.titleLabel?.textColor = Theme.c1
            submitButton.titleLabel?.font = Font.h3
            
            submitButton.isHidden = true
        }
    }
    
    //MARK: - Properties
    var vm: LoginVM?
    private lazy var hud = Hud(color: Theme.c7)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        
        vm?.callback = { [unowned self] (state) in
            switch state.action {
            case .none:
                print("none")
            case .onCall:
                self.hud.start()
            case .onSuccess(let api):
                self.hud.stop()
                switch api {
                case .verifyMobile(let isRegistered):
                    self.passwordTextField.text = ""
                    self.passwordTextField.isHidden = !isRegistered
                    self.submitButton.isHidden = !isRegistered
                    if !isRegistered {
                        self.showAlert("Not Registered", message: "Do you want to register the mobile number?", actionTitle: "Continue", cancelTitle: "Cancel", action: {
                            if let _vm = self.vm?.getVerifyVM() {
                                self.goToVerify(vm: _vm)
                            }
                        })
                    }
                case .login:
                    self.goToHome()
                case .createKey:
                    print("no action")
                }
            case .onFailed(let message):
                self.hud.stop()
                self.showAlert("Error", message: message)
            case .other(let message):
                self.hud.stop()
                self.showAutoDismissAlert(nil, message: message)
            }
        }
        
        vm?.startSession()
    }

    deinit {
        print("Login VC deinited")
    }
    
    //MARK: - Functions
    @objc func mobileNextButtonTapped() {
        passwordTextField.becomeFirstResponder()
    }
    
    //MARK: - IBActions
    @IBAction func buttonActions(_ sender: UIButton) {
        if sender == forgotPasswordButton {
            goToForgotPassword()
        }
    }
    
    @IBAction func roundedButtonActions(_ sender: RoundedButton) {
        view.endEditing(true)
        if sender == submitButton {
            vm?.submitData()
        }
    }
}

//MARK: - Bind
extension LoginVC {
    func bindViewModel() {
        //to view model
        mobileTextField.bind { [unowned self] in
            self.vm?.mobile.value = $0
            
            if ($0.count == 9) {
                self.vm?.checkMobileNumber()
            }
        }
        
        passwordTextField.bind { [unowned self] in
            self.vm?.password.value = $0
        }
        
        vm?.countryCode = mobileTextField.leadingText
    }
}

//MARK: - UITextFieldDelegate
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return false
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileTextField {
            //should limit mobiletextfield entry to 9 characters
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 9
        }
        return true
    }
}

//MARK: - DefaultAlert
extension LoginVC: DefaultAlert { }

//MARK: - AutoDismissAlert
extension LoginVC: AutoDismissAlert { }

//MARK: - HomeRouter
extension LoginVC: HomeRouter { }

//MARK: - VerifyRouter
extension LoginVC: VerifyRouter { }

//MARK: - ForgotPasswordRouter
extension LoginVC: ForgotPasswordRouter { }
