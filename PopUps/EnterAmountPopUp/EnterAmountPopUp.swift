//
//  EnterAmountPopUp.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 22/12/17.
//  Copyright © 2017 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

protocol EnterAmountPopUpDelegate: class {
    func didEnterAmount(_ enterAmountPopUp: EnterAmountPopUp, amount: String)
}

class EnterAmountPopUp: UIView, Modal, NibLoadable {
    var backgroundView = UIView()
    var dialogView = UIView()
    var scrollView = UIScrollView()
    var aView: UIView!
    
    weak var delegate: EnterAmountPopUpDelegate?
    
    @IBOutlet weak var headerLabel: UILabel! {
        didSet {
            headerLabel.textColor = Theme.c1
            headerLabel.font = Font.h3
        }
    }
    
    @IBOutlet weak var enterAmountTextField: BorderedTextField! {
        didSet {
            enterAmountTextField.placeholder = "Enter material charges if any"
            enterAmountTextField.textColor = Theme.c6
            enterAmountTextField.borderColor = Theme.c4
            enterAmountTextField.borderWidth = Metrics.borderWidth
            enterAmountTextField.cornerRadius = Metrics.cornerRadius
            enterAmountTextField.font = Font.h5
            
            enterAmountTextField.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var submitButton: CorneredButton! {
        didSet {
            submitButton.backgroundColor = Theme.c1
            submitButton.titleLabel?.textColor = Theme.c2
            submitButton.titleLabel?.font = Font.h3
        }
    }
    
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.titleLabel?.textColor = Theme.c1
            cancelButton.titleLabel?.font = Font.h3
        }
    }
    
    convenience init(_ delegate: EnterAmountPopUpDelegate?) {
        self.init(frame: UIScreen.main.bounds)
        initialize()
        self.delegate = delegate
        keyboardNotifications(shouldRegister: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        keyboardNotifications(shouldRegister: false)
    }
    
    func initialize() {
        dialogView.clipsToBounds = true
        
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        
        addSubview(backgroundView)
        
        scrollView.frame = frame
        scrollView.isScrollEnabled = true
        addSubview(scrollView)
        
        let xOffset = CGFloat(30.0)
        
        let dialogViewWidth = frame.size.width - 2 * xOffset
        let dialogViewHeight = CGFloat(140.0)
        
        
        dialogView = loadNib()
        
        dialogView.frame.origin = CGPoint(x: xOffset, y: frame.height)
        dialogView.frame.size = CGSize(width: dialogViewWidth, height: dialogViewHeight)
        dialogView.layer.cornerRadius = 6
        dialogView.backgroundColor = UIColor.white
        scrollView.addSubview(dialogView)
    }
    
    @IBAction func corneredButtonActions(_ sender: CorneredButton) {
        dismiss { [unowned self] in
            self.delegate?.didEnterAmount(self, amount: self.enterAmountTextField.text ?? "0")
        }
    }
    
    @IBAction func buttonActions(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
}

extension EnterAmountPopUp: KeyboardObserver {
    var container: UIView {
        return self.scrollView
    }
    
    var firstResponder: UIView? {
        return enterAmountTextField
    }
}
