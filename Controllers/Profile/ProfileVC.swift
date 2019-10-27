//
//  ProfileVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 09/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, NibLoadable {

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
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = Font.h2
            nameLabel.textColor = Theme.c5
        }
    }
    
    @IBOutlet weak var mobileBorderView: BorderedView! {
        didSet {
            mobileBorderView.borderColor = Theme.c4
            mobileBorderView.borderWidth = Metrics.borderWidth
            mobileBorderView.cornerRadius = Metrics.cornerRadius
        }
    }
    
    
    @IBOutlet weak var mobileLabel: UILabel! {
        didSet {
            mobileLabel.font = Font.h7
            mobileLabel.textColor = Theme.c4
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel! {
        didSet {
            emailLabel.font = Font.h7
            emailLabel.textColor = Theme.c4
        }
    }
    
    @IBOutlet weak var refBorderView: BorderedView! {
        didSet {
            refBorderView.borderColor = Theme.c4
            refBorderView.borderWidth = Metrics.borderWidth
            refBorderView.cornerRadius = Metrics.cornerRadius
        }
    }
    
    @IBOutlet weak var refCaptionLabel: UILabel! {
        didSet {
            refCaptionLabel.font = Font.h7
            refCaptionLabel.textColor = Theme.c4
        }
    }
    
    @IBOutlet weak var refLabel: UILabel! {
        didSet {
            refLabel.font = Font.h6
            refLabel.textColor = Theme.c1
        }
    }
    
    @IBOutlet weak var myPaymentButton: BorderedVerticalButtonView! {
        didSet{
            myPaymentButton.title = "MY PAYMENTS"
            myPaymentButton.titleFont = Font.h8
            myPaymentButton.titleColor = Theme.c4
            myPaymentButton.image = UIImage(named: "myPayments")
            myPaymentButton.borderColor = Theme.c4
            myPaymentButton.borderWidth = Metrics.borderWidth
            myPaymentButton.cornerRadius = Metrics.cornerRadius
            
            myPaymentButton.delegate = self
        }
    }
    
    @IBOutlet weak var helpButton: BorderedVerticalButtonView! {
        didSet {
            helpButton.title = "HELP"
            helpButton.titleFont = Font.h8
            helpButton.titleColor = Theme.c4
            helpButton.image = UIImage(named: "comments")
            helpButton.borderColor = Theme.c4
            helpButton.borderWidth = Metrics.borderWidth
            helpButton.cornerRadius = Metrics.cornerRadius
            
            helpButton.delegate = self
        }
    }
    
    @IBOutlet weak var helpStackView: UIStackView! {
        didSet {
            helpStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var subjectTextField: BorderedTextField! {
        didSet {
            subjectTextField.placeholder = "Enter subject"
            subjectTextField.textColor = Theme.c6
            subjectTextField.borderColor = Theme.c4
            subjectTextField.borderWidth = Metrics.borderWidth
            subjectTextField.cornerRadius = Metrics.cornerRadius
            subjectTextField.font = Font.h5
            
            subjectTextField.returnKeyType = .default
            subjectTextField.delegate = self
        }
    }
    
    @IBOutlet weak var feedbackTextView: BorderedTextView! {
        didSet {
            feedbackTextView.placeholder = "Enter your text"
            feedbackTextView.placeholderColor = Theme.c4
            feedbackTextView.originalTextColor = Theme.c6
            feedbackTextView.borderColor = Theme.c4
            feedbackTextView.borderWidth = Metrics.borderWidth
            feedbackTextView.cornerRadius = Metrics.cornerRadius
            feedbackTextView.font = Font.h5
            
            feedbackTextView.returnKeyType = .default
            feedbackTextView.delegate = self
        }
    }
    
    @IBOutlet weak var sendButton: CorneredButton! {
        didSet {
            sendButton.backgroundColor = Theme.c1
            sendButton.titleLabel?.textColor = Theme.c2
            sendButton.titleLabel?.font = Font.h3
            sendButton.imageView?.tintColor = Theme.c2
        }
    }
    
    @IBOutlet weak var editButton: UIButton! {
        didSet {
            editButton.titleLabel?.textColor = Theme.c2
            editButton.titleLabel?.font = Font.h6
        }
    }
    
    
    //MARK: - Properties
    var vm: ProfileVM?
    private lazy var hud = Hud(color: Theme.c7)
    var currentResponsder: UIView?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("Profile")
        bindViewModel()
        
        vm?.callback = { [unowned self] (state) in
            switch state.action {
            case .none:
                print("none")
            case .onCall:
                self.hud.start()
            case .onSuccess(_):
                self.hud.stop()
            case .onFailed(let message):
                self.hud.stop()
                self.showAlert("Error", message: message)
            case .other(let message):
                self.hud.stop()
                self.showAutoDismissAlert(nil, message: message)
            }
        }
        
        vm?.getProviderProfile()
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
        print("Profile VC deinited")
    }
    
    //MARK: - IBActions
    @IBAction func buttonAction(_ sender: UIButton) {
        if sender == editButton {
            goToEditProfile()
        } else if sender == sendButton {
            vm?.submitHelpData()
        }
    }
}

//MARK: - Bind
extension ProfileVC {
    func bindViewModel() {
        //to view model
        subjectTextField.bind { [unowned self] in
            self.vm?.subject.value = $0
        }
        
        feedbackTextView.bind { [unowned self] in
            self.vm?.yourText.value = $0
        }
        
        //to view controller
        vm?.name.bind = { [unowned self] in
            self.nameLabel.text = $0
        }
        
        vm?.mobile.bind = { [unowned self] in
            self.mobileLabel.text = $0
        }
        
        vm?.email.bind = { [unowned self] in
            self.emailLabel.text = $0
        }
        
        vm?.referralCode.bind = { [unowned self] in
            self.refLabel.text = $0
        }
        
        vm?.dpURL.bind = { [unowned self] in
            self.profileImageView.hnk_setImageFromURL($0, placeholder: Images.dpPlaceholder)
        }
        
        vm?.subject.bind = { [unowned self] in
            self.subjectTextField.text = $0
        }
        
        vm?.yourText.bind = { [unowned self] in
            self.feedbackTextView.setText($0)
        }
        
        //set value to viewcontroller on load
        self.nameLabel.text = vm?.name.value
        self.mobileLabel.text = vm?.mobile.value
        self.emailLabel.text = vm?.email.value
        self.refLabel.text = vm?.referralCode.value
        if let dpURL = vm?.dpURL.value {
            self.profileImageView.hnk_setImageFromURL(dpURL, placeholder: Images.dpPlaceholder)
        }
    }
}

//MARK: - UITextFieldDelegate
extension ProfileVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == subjectTextField {
            let _ = self.feedbackTextView.becomeFirstResponder()
        }
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentResponsder = textField
        return true
    }
}

//MARK: - UITextViewDelegate
extension ProfileVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        currentResponsder = textView
        return true
    }
}

//MARK: - KeyboardObserver
extension ProfileVC: KeyboardObserver {
    var container: UIView {
        return self.scrollView
    }
    
    var firstResponder: UIView? {
        return currentResponsder
    }
}

//MARK: - BorderedVerticalButtonViewDelegate
extension ProfileVC: BorderedVerticalButtonViewDelegate {
    func tappedOnBorderedVerticalButton(_ sender: BorderedVerticalButtonView) {
        if sender == helpButton {
            helpStackView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.scrollView.scrollToBottom()
            }
        }
    }
}

//MARK: - DefaultAlert
extension ProfileVC: DefaultAlert { }

//MARK: - AutoDismissAlert
extension ProfileVC: AutoDismissAlert { }

//MARK: - EditProfileRouter
extension ProfileVC: EditProfileRouter { }
