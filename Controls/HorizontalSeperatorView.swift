//
//  HorizontalSeperatorView.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 08/06/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

@IBDesignable
class HorizontalSeperatorView: UIView {
    
    //MARK: - IBInspectables
    @IBInspectable public var seperatorColor: UIColor?
    
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
        let _ = subviews.map { $0.removeFromSuperview() }
        
        let view = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height / UIScreen.main.scale))
        view.backgroundColor = seperatorColor
        addSubview(view)
        
        backgroundColor = UIColor.clear
        
        super.layoutSubviews()
    }
}
