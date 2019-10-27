//
//  JobCell.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 09/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class JobCell: UITableViewCell {

    //MARK: - Static Properties
    static var identifier = "JobCell"
    static var rowHeight: CGFloat = 110.0
    
    @IBOutlet weak var jobsImageView: RoundedImageView! {
        didSet {
            jobsImageView.image = Images.dpPlaceholder
        }
    }
    
    @IBOutlet weak var reqIdLabel: UILabel! {
        didSet {
            reqIdLabel.textColor = Theme.c1
            reqIdLabel.font = Font.h6
        }
    }
    
    @IBOutlet weak var customerNameLabel: UILabel! {
        didSet {
            customerNameLabel.textColor = Theme.c1
            customerNameLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var serviceNameLabel: UILabel! {
        didSet {
            serviceNameLabel.textColor = Theme.c1
            serviceNameLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var reqDateLabel: UILabel! {
        didSet {
            reqDateLabel.textColor = Theme.c1
            reqDateLabel.font = Font.h7
        }
    }
    
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
extension JobCell {
    func setup(_ vm: CellRepresentable) {
        guard let vm = vm as? JobCellVM else {
            fatalError("wrong cell representable")
        }
        
        if let _ = vm.reqId {
            reqIdLabel.isHidden = false
        } else {
            reqIdLabel.isHidden = true
        }
        
        if let _ = vm.customerName {
            customerNameLabel.isHidden = false
        } else {
            customerNameLabel.isHidden = true
        }
        
        reqIdLabel.text = vm.reqId
        customerNameLabel.text = vm.customerName
        serviceNameLabel.text = vm.serviceName
        reqDateLabel.text = vm.reqDate
    }
}
