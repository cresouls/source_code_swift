//
//  RoundedImageView.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 09/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView {

    //MARK: - IBInspectables
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
        layer.cornerRadius = bounds.height / 2
        super.layoutSubviews()
    }
}
