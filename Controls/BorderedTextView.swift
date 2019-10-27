//
//  BorderedTextView.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 10/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedTextView: UITextView {
    
    //MARK: - IBInspectables
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var placeholder: String = "" {
        didSet{
            updatePlaceHolder()
        }
    }
    
    @IBInspectable var placeholderColor: UIColor? {
        didSet {
            updatePlaceHolder()
        }
    }
    
    //MARK: - Properties
    @IBInspectable var originalTextColor: UIColor?
    private var originalText: String = ""
    
    //MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    override func layoutSubviews() {
        //contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
        super.layoutSubviews()
        updatePlaceHolder()
    }
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.text = self.originalText
        self.textColor = self.originalTextColor
        return result
    }

    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        updatePlaceHolder()

        return result
    }

    private func updatePlaceHolder() {
        if self.text == "" || self.text == placeholder  {
            self.text = placeholder
            self.textColor = placeholderColor
            self.originalText = ""
        } else {
            self.textColor = self.originalTextColor
            self.originalText = self.text
        }
    }
}

extension BorderedTextView {
    //hack to set back placeholder
    func setText(_ text: String) {
        self.text = text
        updatePlaceHolder()
    }
}
