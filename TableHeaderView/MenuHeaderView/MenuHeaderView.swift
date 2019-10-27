//
//  MenuHeaderView.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 13/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class MenuHeaderView: UIView, NibLoadable {
    
    //MARK: - Properties
    var contentView: UIView?
    
    //MARK: - Static Properties
    static var viewHeight: CGFloat = 150.0
    
    @IBOutlet weak var dpImageView: BorderedImageView! {
        didSet {
            dpImageView.cornerRadius = Metrics.cornerRadius
            dpImageView.borderWidth = Metrics.thickBorderWidth
            dpImageView.borderColor = Theme.c2
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = Font.h3
            titleLabel.textColor = Theme.c2
        }
    }
    @IBOutlet weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.font = Font.h7
            subtitleLabel.textColor = Theme.c2
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
        contentView?.backgroundColor = Theme.c9
    }
}

//MARK: - Functions
extension MenuHeaderView {
    func setup(_ vm: ViewRepresentable) {
        guard let vm = vm as? MenuHeaderVM else {
            fatalError("wrong view representable")
        }
        
        titleLabel.text = vm.title
        subtitleLabel.text = vm.subtitle
        if let _dpURL = vm.dpURL {
            dpImageView.hnk_setImageFromURL(_dpURL, placeholder: Images.dpPlaceholder)
        } else {
            dpImageView.image = Images.dpPlaceholder
        }
    }
}
