//
//  BorderedVerticalButtonView.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 07/06/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

protocol BorderedVerticalButtonViewDelegate: class {
    func tappedOnBorderedVerticalButton(_ sender: BorderedVerticalButtonView)
}

@IBDesignable
class BorderedVerticalButtonView: UIView, NibLoadable {

    //MARK: - Properties
    var contentView: UIView?
    weak var delegate: BorderedVerticalButtonViewDelegate?
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    //MARK: - IBInspectables
    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    @IBInspectable var title: String? {
        didSet {
            if let title = title {
                titleLabel.text = title
            } else {
                titleLabel.text = ""
            }
        }
    }
    
    @IBInspectable var titleColor: UIColor? {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
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
    
    var titleFont: UIFont? {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    //MARK: Init
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        contentView = loadNib()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = self.loadNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setup() {
        contentView?.backgroundColor = UIColor.clear
    }
    
    //MARK: - IBActions
    @IBAction func buttonAction(_ sender: UIButton) {
        if sender == button {
            delegate?.tappedOnBorderedVerticalButton(self)
        }
    }
    
}
