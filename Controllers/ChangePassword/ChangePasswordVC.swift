//
//  ChangePasswordVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 24/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController, NibLoadable {

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
            
            confirmPasswordTextField.returnKeyType = .default
            confirmPasswordTextField.isSecureTextEntry = true
            confirmPasswordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var submitButton: RoundedButton! {
        didSet {
            submitButton.backgroundColor = Theme.c2
            submitButton.titleLabel?.textColor = Theme.c1
            submitButton.titleLabel?.font = Font.h3
        }
    }
    
    //MARK: - Properties
    var vm: ChangePasswordVM?
    private lazy var hud = Hud(color: Theme.c7)
    
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
    
    deinit {
        print("ChangePassword VC deinited")
    }
    
    //MARK: - IBActions
    @IBAction func roundedButtonActions(_ sender: RoundedButton) {
        view.endEditing(true)
        if sender == submitButton {
            vm?.submitData()
        }
    }
}

//MARK: - Bind
extension ChangePasswordVC {
    func bindViewModel() {
        //to view model
        passwordTextField.bind { [unowned self] in
            self.vm?.password.value = $0
        }
        confirmPasswordTextField.bind { [unowned self] in
            self.vm?.confirmPassword.value = $0
        }
    }
}

//MARK: - UITextFieldDelegate
extension ChangePasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        }
        return false
    }
}

//MARK: - DefaultAlert
extension ChangePasswordVC: DefaultAlert { }

//MARK: - AutoDismissAlert
extension ChangePasswordVC: AutoDismissAlert { }

//MARK: - LoginRouter
extension ChangePasswordVC: LoginRouter { }

//MARK: - PopToRoot
extension ChangePasswordVC: PopToRoot { }
