//
//  RoundedButton.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 01/06/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
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
        moveImageLeftTextCenter(imagePadding: bounds.height / 2)
        super.layoutSubviews()
    }
}
