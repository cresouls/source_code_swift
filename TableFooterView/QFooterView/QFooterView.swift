//
//  QFooterView.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 23/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class QFooterView: UIView, NibLoadable {
    //MARK: - Properties
    var contentView: UIView?
    
    //MARK: - Static Properties
    static var viewHeight: CGFloat = 22.0
    
    @IBOutlet weak var footerLabel: UILabel! {
        didSet {
            footerLabel.textColor = Theme.c6
            footerLabel.font = Font.h7
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
        contentView?.backgroundColor = Theme.c3
    }
}
