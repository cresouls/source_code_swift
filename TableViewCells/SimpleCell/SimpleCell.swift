//
//  SimpleCell.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 17/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class SimpleCell: UITableViewCell {

    //MARK: - Static Properties
    static var identifier = "SimpleCell"
    static var rowHeight: CGFloat = 50.0
    
    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = Theme.c6
            titleLabel.font = Font.h3
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}

//MARK: - Functions
extension SimpleCell {
    func setup(_ vm: CellRepresentable) {
        guard let vm = vm as? SimpleCellVM else {
            fatalError("wrong cell representable")
        }
        
        titleLabel.text = vm.title
        if vm.isSelected {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
    }
}
