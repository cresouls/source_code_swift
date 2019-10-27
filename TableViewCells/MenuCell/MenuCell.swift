//
//  MenuCell.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 13/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    //MARK: - Static Properties
    static var identifier = "MenuCell"
    static var rowHeight: CGFloat = 50.0
    
    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = Theme.c1
            titleLabel.font = Font.h5
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - Functions
extension MenuCell {
    func setup(_ vm: CellRepresentable) {
        guard let vm = vm as? MenuCellVM else {
            fatalError("wrong cell representable")
        }
        
        titleLabel.text = vm.title
        iconImageView.image = vm.image
        
        if vm.isDark {
            contentView.backgroundColor = Theme.c9
            titleLabel.textColor = Theme.c2
        } else {
            contentView.backgroundColor = Theme.c2
            titleLabel.textColor = Theme.c6
        }
    }
}
