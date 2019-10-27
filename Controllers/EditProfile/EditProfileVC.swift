//
//  EditProfileVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 10/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController, NibLoadable {

    //MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImageView: RoundedImageView! {
        didSet {
            profileImageView.backgroundColor = Theme.c4
            profileImageView.borderColor = Theme.c2
            profileImageView.borderWidth = Metrics.thickBorderWidth
            profileImageView.image = Images.dpPlaceholder
        }
    }
    
    @IBOutlet weak var fnameTextField: BorderedTextField! {
        didSet {
            fnameTextField.placeholder = "Firstname"
            fnameTextField.textColor = Theme.c6
            fnameTextField.borderColor = Theme.c4
            fnameTextField.borderWidth = Metrics.borderWidth
            fnameTextField.cornerRadius = Metrics.cornerRadius
            fnameTextField.font = Font.h5
            
            fnameTextField.returnKeyType = .next
            fnameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var lnameTextField: BorderedTextField! {
        didSet {
            lnameTextField.placeholder = "Lastname"
            lnameTextField.textColor = Theme.c6
            lnameTextField.borderColor = Theme.c4
            lnameTextField.borderWidth = Metrics.borderWidth
            lnameTextField.cornerRadius = Metrics.cornerRadius
            lnameTextField.font = Font.h5
            
            lnameTextField.returnKeyType = .next
            lnameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var emailTextField: BorderedTextField! {
        didSet {
            emailTextField.placeholder = "Email"
            emailTextField.textColor = Theme.c6
            emailTextField.borderColor = Theme.c4
            emailTextField.borderWidth = Metrics.borderWidth
            emailTextField.cornerRadius = Metrics.cornerRadius
            emailTextField.font = Font.h5
            
            emailTextField.keyboardType = .emailAddress
            emailTextField.returnKeyType = .default
            emailTextField.delegate = self
        }
    }
    
    @IBOutlet weak var sendButton: CorneredButton! {
        didSet {
            sendButton.backgroundColor = Theme.c7
            sendButton.titleLabel?.textColor = Theme.c2
            sendButton.titleLabel?.font = Font.h3
        }
    }
    
    //MARK: - Properties
    var vm: EditProfileVM?
    private lazy var hud = Hud(color: Theme.c7)
    var currentResponsder: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("Edit Profile")
        addMenuPopDismissButton()
        bindViewModel()
        
        vm?.callback = { [unowned self] (state) in
            switch state.action {
            case .none:
                print("none")
            case .onCall:
                self.hud.start()
            case .onSuccess(let api):
                self.hud.stop()
                if api == .submitData {
                    self.popDismiss()
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
        print("EditProfile VC deinited")
    }
    
    //MARK: - IBActions
    @IBAction func buttonActions(_ sender: UIButton) {
        self.showImagePicker(isEditable: true)
    }
    
    //MARK: - IBActions
    @IBAction func corneredButtonActions(_ sender: CorneredButton) {
        vm?.submitData()
    }
    
}

//MARK: - Bind
extension EditProfileVC {
    func bindViewModel() {
        //to view model
        fnameTextField.bind { [unowned self] in
            self.vm?.firstName.value = $0
        }

        lnameTextField.bind { [unowned self] in
            self.vm?.lastName.value = $0
        }

        emailTextField.bind { [unowned self] in
            self.vm?.email.value = $0
        }
        
        //set value to viewcontroller on load
        self.fnameTextField.text = vm?.firstName.value
        self.lnameTextField.text = vm?.lastName.value
        self.emailTextField.text = vm?.email.value
        if let dpURL = vm?.dpURL.value {
            self.profileImageView.hnk_setImageFromURL(dpURL, placeholder: Images.dpPlaceholder)
        }
    }
}

//MARK: - UITextFieldDelegate
extension EditProfileVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == fnameTextField {
            lnameTextField.becomeFirstResponder()
        } else if textField == lnameTextField {
            emailTextField.becomeFirstResponder()
        }
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentResponsder = textField
        return true
    }
}

//MARK: - KeyboardObserver
extension EditProfileVC: KeyboardObserver {
    var container: UIView {
        return self.scrollView
    }

    var firstResponder: UIView? {
        return currentResponsder
    }
}

//MARK: - KeyboardObserver
extension EditProfileVC: ImagePickerPresentable {
    func selectedImage(image: UIImage?) {
        guard let _image = image else { return }
        profileImageView.image = image
        vm?.uploadDp(_image)
    }
}

//MARK: - DefaultAlert
extension EditProfileVC: DefaultAlert { }

//MARK: - AutoDismissAlert
extension EditProfileVC: AutoDismissAlert { }
