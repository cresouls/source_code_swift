//
//  MiscHeaderView.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 13/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class MiscHeaderView: UIView, NibLoadable {
    
    //MARK: - Properties
    var contentView: UIView?
    
    //MARK: - Static Properties
    static var viewHeight: CGFloat = 76.0
    
    //MARK: Init
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        contentView = loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = self.loadNib()
    }
}
