//
//  VerifyVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 14/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class VerifyVC: UIViewController, NibLoadable {

    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!  {
        didSet {
            titleLabel.font = Font.h3
            titleLabel.textColor = Theme.c2
        }
    }
    
    @IBOutlet weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.font = Font.h8
            subtitleLabel.textColor = Theme.c2
        }
    }
    
    @IBOutlet weak var otpTextField: BorderedTextField! {
        didSet {
            otpTextField.textColor = Theme.c2
            otpTextField.cornerRadius = Metrics.cornerRadius
            otpTextField.borderWidth = Metrics.borderWidth
            otpTextField.borderColor = Theme.c2
            otpTextField.font = Font.h7
            
            otpTextField.keyboardType = .numberPad
            otpTextField.textAlignment = .center
            otpTextField.delegate = self
        }
    }
    
    @IBOutlet weak var submitButton: CorneredButton! {
        didSet {
            submitButton.backgroundColor = Theme.c2
            submitButton.titleLabel?.textColor = Theme.c1
            submitButton.titleLabel?.font = Font.h3
            submitButton.cornerRadius = Metrics.cornerRadius
        }
    }
    
    @IBOutlet weak var resendOtpButton: CorneredButton! {
        didSet {
            resendOtpButton.backgroundColor = Theme.c2
            resendOtpButton.titleLabel?.textColor = Theme.c1
            resendOtpButton.titleLabel?.font = Font.h3
            resendOtpButton.cornerRadius = Metrics.cornerRadius
            
            resendOtpButton.isHidden = true
        }
    }
    
    //MARK: - Properties
    var vm: VerifyVM?
    private lazy var hud = Hud(color: Theme.c7)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        addMenuPopDismissButton()
        
        vm?.callback = { [unowned self] (state) in
            switch state.action {
            case .none:
                print("none")
            case .onCall(let api):
                switch api {
                case .generateOTP, .resendOTP:
                    self.resendOtpButton.isHidden = true
                }
            case .onSuccess(let api):
                switch api {
                case .generateOTP, .resendOTP:
                    self.resendOtpButton.isHidden = false
                }
            case .onFailed(let api, let message):
                switch api {
                case .generateOTP:
                    self.showAutoDismissAlert("Error", message: message) {
                        self.popDismiss()
                    }
                case .resendOTP:
                    self.resendOtpButton.isHidden = false
                    self.showAlert("Error", message: message)
                }
            case .other(let api, let message):
                switch api {
                case .generateOTP:
                    print("not called")
                case .resendOTP:
                    self.resendOtpButton.isHidden = false
                    self.showAutoDismissAlert(nil, message: message)
                }
            case .verifySuccess:
                if let vm = self.vm?.getSignUpVM() {
                    self.goToSignUp(vm: vm)
                }
            case .verifyFailed(let title, let message):
                self.showAutoDismissAlert(title, message: message)
            }
        }
        
        vm?.generateOTP()
    }

    deinit {
        print("Verify VC deinited")
    }
    
    //MARK: - IBActions
    @IBAction func corneredButtonActions(_ sender: CorneredButton) {
        view.endEditing(true)
        if sender == self.submitButton {
            //vm?.submitData()
        } else if sender == self.resendOtpButton {
            vm?.resendOTP()
        }
    }
}

//MARK: - Bind
extension VerifyVC {
    func bindViewModel() {
        //to view model
        otpTextField.bind { [unowned self] in
            self.vm?.otp.value = $0
            
            if ($0.count == 5) {
                self.vm?.verifyMobileWithOTP()
            }
        }
    }
}

//MARK: - UITextFieldDelegate
extension VerifyVC: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == otpTextField {
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
extension VerifyVC: DefaultAlert { }

//MARK: - AutoDismissAlert
extension VerifyVC: AutoDismissAlert { }

//MARK: - SignUpRouter
extension VerifyVC: SignUpRouter { }
