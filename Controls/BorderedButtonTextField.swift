//
//  BorderedButtonTextField.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 09/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

protocol BorderedButtonTextFieldDelegate: class {
    func tappedOnBorderedButtonTextField(_ textField: BorderedButtonTextField)
}

@IBDesignable
class BorderedButtonTextField: UITextField {

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
    
    @IBInspectable public var placeholderColor: UIColor? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable public var leadingText: String? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable public var trailingImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    //MARK: - Properties
    private var viewHeight: CGFloat {
        get {
            return bounds.height
        }
    }
    
    private var viewWidth: CGFloat {
        get {
            return bounds.height
        }
    }
    
    private var padding: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: 0, left: viewWidth, bottom: 0, right: viewWidth)
        }
    }
    
    weak var _delegate: BorderedButtonTextFieldDelegate?
    
    //MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    override func layoutSubviews() {
        borderStyle = .none
        super.layoutSubviews()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func updateView() {
        if let text = leadingText {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
            label.font = self.font
            label.textColor = UIColor.white
            label.text = "\(text)"
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            //label.sizeToFit()
            leftViewMode = .always
            leftView = label
        } else {
            leftView = nil
            leftViewMode = .never
        }
        
        
        if let image = trailingImage {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
            button.setImage(image, for: .normal)
            button.setTitle("", for: .normal)
            //button.sizeToFit()
            rightViewMode = .always
            rightView = button
            
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        } else {
            rightView = nil
            rightViewMode = .never
        }
        
        if let color = placeholderColor {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                       attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
}

extension BorderedButtonTextField {
    @objc func buttonAction(_ sender: UIButton) {
        _delegate?.tappedOnBorderedButtonTextField(self)
    }
}
