//
//  ForgotPasswordVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 16/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController, NibLoadable {

    //MARK: - IBOutlets
    @IBOutlet weak var mobileTextField: BorderedButtonTextField! {
        didSet {
            mobileTextField.placeholder = "Enter your mobile number"
            mobileTextField.textColor = Theme.c2
            mobileTextField.borderColor = Theme.c2
            mobileTextField.borderWidth = Metrics.borderWidth
            mobileTextField.cornerRadius = Metrics.cornerRadius
            mobileTextField.font = Font.h5
            mobileTextField.leadingText = Settings.countryCode
            mobileTextField.trailingImage = UIImage(named: "rightArrow")
            
            mobileTextField.delegate = self
            mobileTextField._delegate = self
        }
    }
    
    @IBOutlet weak var otpTextField: BorderedButtonTextField! {
        didSet {
            otpTextField.placeholder = "Enter your otp"
            otpTextField.textColor = Theme.c2
            otpTextField.borderColor = Theme.c2
            otpTextField.borderWidth = Metrics.borderWidth
            otpTextField.cornerRadius = Metrics.cornerRadius
            otpTextField.font = Font.h5
            
            otpTextField.keyboardType = .numberPad
            otpTextField.delegate = self
            
            otpTextField.isHidden = true
        }
    }
    
    @IBOutlet weak var resendButton: CorneredButton! {
        didSet {
            resendButton.backgroundColor = Theme.c2
            resendButton.titleLabel?.textColor = Theme.c1
            resendButton.titleLabel?.font = Font.h3
            resendButton.cornerRadius = Metrics.cornerRadius
            
            resendButton.isHidden = true
        }
    }
    
    //MARK: - Properties
    var vm: ForgotPasswordVM?
    private lazy var hud = Hud(color: Theme.c7)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addMenuPopDismissButton()
        bindViewModel()
        
        vm?.callback = { [unowned self] (state) in
            switch state.action {
            case .none:
                print("none")
            case .onCall(let api):
                switch api {
                case .verifyMobile(_):
                    self.hud.start()
                case .generateOTP, .resendOTP:
                    self.resendButton.isHidden = true
                }
            case .onSuccess(let api):
                switch api {
                case .verifyMobile(let isRegistered):
                    self.hud.stop()
                    self.otpTextField.text = ""
                    self.otpTextField.isHidden = !isRegistered
                    self.mobileTextField.trailingImage = nil
                    if !isRegistered {
                        self.showAutoDismissAlert(nil, message: "The mobile number you entered is not registered with us.", action: {
                            self.popDismiss()
                        })
                    }
                case .generateOTP, .resendOTP:
                    self.resendButton.isHidden = false
                }
            case .onFailed(let api, let message):
                switch api {
                case .verifyMobile(_):
                    self.showAlert("Error", message: message)
                case .generateOTP:
                    self.showAutoDismissAlert("Error", message: message) {
                        self.popDismiss()
                    }
                case .resendOTP:
                    self.resendButton.isHidden = false
                    self.showAlert("Error", message: message)
                }
            case .other(let api, let message):
                switch api {
                case .verifyMobile(_):
                    self.showAutoDismissAlert(nil, message: message) {
                        self.popDismiss()
                    }
                case .generateOTP:
                    print("not called")
                case .resendOTP:
                    self.resendButton.isHidden = false
                    self.showAutoDismissAlert(nil, message: message)
                }
            case .verifySuccess:
                if let vm = self.vm?.getChangePasswordVM() {
                    self.goToChangePassword(vm: vm)
                }
            case .verifyFailed(let title, let message):
                self.showAutoDismissAlert(title, message: message)
            }
        }
        
    }
    
    deinit {
        print("Login VC deinited")
    }
    
    //MARK: - IBActions
    @IBAction func corneredButtonActions(_ sender: CorneredButton) {
        view.endEditing(true)
        if sender == self.resendButton {
            vm?.resendOTP()
        }
    }
}

//MARK: - Bind
extension ForgotPasswordVC {
    func bindViewModel() {
        //to view model
        mobileTextField.bind { [unowned self] in
            self.vm?.mobile.value = $0
        }
        
        otpTextField.bind { [unowned self] in
            self.vm?.otp.value = $0
            
            if ($0.count == 5) {
                self.vm?.verifyMobileWithOTP()
            }
        }
        
        vm?.countryCode = mobileTextField.leadingText
    }
}

//MARK: - BorderedButtonTextFieldDelegate
extension ForgotPasswordVC: BorderedButtonTextFieldDelegate {
    func tappedOnBorderedButtonTextField(_ textField: BorderedButtonTextField) {
        view.endEditing(true)
        if textField == mobileTextField {
            vm?.checkMobileNumber()
        }
    }
}

//MARK: - UITextFieldDelegate
extension ForgotPasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileTextField {
            //should limit mobiletextfield entry to 9 characters
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 9
        } else if textField == otpTextField {
            //should limit mobiletextfield entry to 5 characters
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 5
        }
        return true
    }
}

//MARK: - DefaultAlert
extension ForgotPasswordVC: DefaultAlert { }

//MARK: - AutoDismissAlert
extension ForgotPasswordVC: AutoDismissAlert { }

//MARK: - ChangePasswordRouter
extension ForgotPasswordVC: ChangePasswordRouter { }
