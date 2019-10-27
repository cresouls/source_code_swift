//
//  QHeaderView.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 23/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class QHeaderView: UIView, NibLoadable {
    //MARK: - Properties
    var contentView: UIView?
    
    //MARK: - Static Properties
    static var viewHeight: CGFloat = 26.0
    
    @IBOutlet weak var headerLabel: UILabel! {
        didSet {
            headerLabel.textColor = Theme.c7
            headerLabel.font = Font.h6
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
