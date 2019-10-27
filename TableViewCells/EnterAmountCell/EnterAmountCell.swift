//
//  EnterAmountCell.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 23/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class EnterAmountCell: UITableViewCell {

    //MARK: - Static Properties
    static var identifier = "EnterAmountCell"
    static var rowHeight: CGFloat = 80.0
    
    @IBOutlet weak var amountTextField: UnderlinedTextField! {
        didSet {
            amountTextField.textColor = Theme.c5
            amountTextField.underlineColor = Theme.c4
            amountTextField.placeholderColor = Theme.c4
            amountTextField.font = Font.h7
            
            amountTextField.keyboardType = .numberPad
            //amountTextField.delegate = self
        }
    }
    
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.backgroundColor = Theme.c1
            sendButton.titleLabel?.textColor = Theme.c2
            sendButton.titleLabel?.font = Font.h6
        }
    }
    
    var vm: EnterAmountCellVM?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.backgroundColor = Theme.c3
        
        //set next button on amount keyboard
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.contentView.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let nextBtn: UIBarButtonItem = UIBarButtonItem(title: "Return", style: .done, target: self, action: #selector(LoginVC.mobileNextButtonTapped))
        toolbar.setItems([flexSpace, nextBtn], animated: false)
        toolbar.sizeToFit()
        amountTextField.inputAccessoryView = toolbar
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Functions
    @objc func mobileNextButtonTapped() {
        amountTextField.resignFirstResponder()
    }
    
    //MARK: - IBActions
    @IBAction func buttonActions(_ sender: UIButton) {
        amountTextField.resignFirstResponder()
        if (sender == self.sendButton) {
            vm?.submitData(amountTextField.text)
        }
    }
}

//MARK: - Functions
extension EnterAmountCell {
    func setup(_ vm: CellRepresentable) {
        guard let vm = vm as? EnterAmountCellVM else {
            fatalError("wrong cell representable")
        }
        self.vm = vm
        
        //to clear on reload after successfully submitted
        amountTextField.text = ""
    }
}
