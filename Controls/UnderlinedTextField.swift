//
//  UnderlinedTextField.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 01/06/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

@IBDesignable
class UnderlinedTextField: UITextField {
    
    //MARK: - IBInspectables
    @IBInspectable public var underlineColor: UIColor?
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
        
        let _ = subviews.map { $0.removeFromSuperview() }
        
        let view = UIView.init(frame: CGRect(x: 0.0, y: bounds.height - (1 / UIScreen.main.scale), width: bounds.width, height: 1 / UIScreen.main.scale))
        view.backgroundColor = underlineColor
        addSubview(view)
        super.layoutSubviews()
    }
    
    func updateView() {
        if let text = leadingText {
            let label = UILabel()
            label.font = self.font
            label.textColor = UIColor.white
            label.text = "\(text) "
            label.backgroundColor = UIColor.clear
            label.sizeToFit()
            leftViewMode = .always
            leftView = label
        } else {
            leftView = nil
            leftViewMode = .never
        }
        
        if let color = placeholderColor {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                       attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
}
