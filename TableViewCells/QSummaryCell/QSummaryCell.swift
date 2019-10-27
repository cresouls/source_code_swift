//
//  QSummaryCell.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 22/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class QSummaryCell: UITableViewCell {

    //MARK: - Static Properties
    static var identifier = "QSummaryCell"
    static var rowHeight: CGFloat = UITableView.automaticDimension
    
    @IBOutlet weak var serviceNameCaptionLabel: UILabel! {
        didSet {
            serviceNameCaptionLabel.textColor = Theme.c7
            serviceNameCaptionLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var reqDateCaptionLabel: UILabel! {
        didSet {
            reqDateCaptionLabel.textColor = Theme.c7
            reqDateCaptionLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var reqTimeCaptionLabel: UILabel! {
        didSet {
            reqTimeCaptionLabel.textColor = Theme.c7
            reqTimeCaptionLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var requirementsCaptionLabel: UILabel! {
        didSet {
            requirementsCaptionLabel.textColor = Theme.c7
            requirementsCaptionLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var serviceNameLabel: UILabel! {
        didSet {
            serviceNameLabel.textColor = Theme.c5
            serviceNameLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var reqDateLabel: UILabel! {
        didSet {
            reqDateLabel.textColor = Theme.c5
            reqDateLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var reqTimeLabel: UILabel! {
        didSet {
            reqTimeLabel.textColor = Theme.c5
            reqTimeLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var requirementsLabel: UILabel! {
        didSet {
            requirementsLabel.textColor = Theme.c5
            requirementsLabel.font = Font.h7
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
extension QSummaryCell {
    func setup(_ vm: CellRepresentable) {
        guard let vm = vm as? QSummaryCellVM else {
            fatalError("wrong cell representable")
        }
        serviceNameLabel.text = vm.serviceName
        reqDateLabel.text = vm.reqDate
        reqTimeLabel.text = vm.reqTime
        requirementsLabel.text = vm.requirements
    }
}
