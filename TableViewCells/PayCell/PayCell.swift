//
//  PayCell.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 09/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class PayCell: UITableViewCell {

    //MARK: - Static Properties
    static var identifier = "PayCell"
    static var rowHeight: CGFloat = 90.0
    
    @IBOutlet weak var regNoCaptionLabel: UILabel! {
        didSet {
            regNoCaptionLabel.textColor = Theme.c5
            regNoCaptionLabel.font = Font.h6
        }
    }
    
    @IBOutlet weak var amountCaptionLabel: UILabel! {
        didSet {
            amountCaptionLabel.textColor = Theme.c5
            amountCaptionLabel.font = Font.h6
        }
    }
    
    @IBOutlet weak var statusCaptionLabel: UILabel! {
        didSet {
            statusCaptionLabel.textColor = Theme.c5
            statusCaptionLabel.font = Font.h6
        }
    }
    
    @IBOutlet weak var regNoLabel: UILabel! {
        didSet {
            regNoLabel.textColor = Theme.c1
            regNoLabel.font = Font.h6
        }
    }
    
    @IBOutlet weak var amountLabel: UILabel! {
        didSet {
            amountLabel.textColor = Theme.c1
            amountLabel.font = Font.h6
        }
    }
    
    @IBOutlet weak var statusLabel: UILabel! {
        didSet {
            statusLabel.textColor = Theme.c1
            statusLabel.font = Font.h6
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.textColor = Theme.c5
            dateLabel.font = Font.h1
        }
    }
    
    @IBOutlet weak var monthYearLabel: UILabel! {
        didSet {
            monthYearLabel.textColor = Theme.c5
            monthYearLabel.font = Font.h11
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.backgroundColor = Theme.c3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//MARK: - Functions
extension PayCell {
    func setup(_ vm: CellRepresentable) {
        guard let vm = vm as? PayCellVM else {
            fatalError("wrong cell representable")
        }
        dateLabel.text = vm.date
        monthYearLabel.text = vm.monthYear
        regNoLabel.text = vm.regNo
        amountLabel.text = vm.amount
        statusLabel.text = vm.status
    }
}
