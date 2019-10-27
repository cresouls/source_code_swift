//
//  QuoteCell.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 22/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class QuoteCell: UITableViewCell {

    //MARK: - Static Properties
    static var identifier = "QuoteCell"
    static var rowHeight: CGFloat = 71.0
    
    @IBOutlet weak var amountCaptionLabel: UILabel! {
        didSet {
            amountCaptionLabel.textColor = Theme.c7
            amountCaptionLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var createdDateCaptionLabel: UILabel! {
        didSet {
            createdDateCaptionLabel.textColor = Theme.c7
            createdDateCaptionLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var amountLabel: UILabel! {
        didSet {
            amountLabel.textColor = Theme.c5
            amountLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var createdDateLabel: UILabel! {
        didSet {
            createdDateLabel.textColor = Theme.c5
            createdDateLabel.font = Font.h7
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.backgroundColor = Theme.c3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


//MARK: - Functions
extension QuoteCell {
    func setup(_ vm: CellRepresentable) {
        guard let vm = vm as? QuoteCellVM else {
            fatalError("wrong cell representable")
        }
        amountLabel.text = vm.amount
        createdDateLabel.text = vm.createdDate
    }
}
