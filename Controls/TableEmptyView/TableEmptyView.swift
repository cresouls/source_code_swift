//
//  TableEmptyView.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 07/06/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class TableEmptyView: UIView, NibLoadable {

    //MARK: - Properties
    var contentView: UIView?

    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = Font.h3
            titleLabel.textColor = Theme.c5
        }
    }
    
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.font = Font.h7
            messageLabel.textColor = Theme.c5
        }
    }
    
    //MARK: - IBInspectable
    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var message: String? {
        didSet {
            messageLabel.text = message
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
    
    func setup() {
        contentView?.backgroundColor = UIColor.clear
    }
    
}
