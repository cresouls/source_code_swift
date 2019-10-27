//
//  TermsCell.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 17/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class TermsCell: UITableViewCell {

    //MARK: - Static Properties
    static var identifier = "TermsCell"
    static var rowHeight: CGFloat = UITableView.automaticDimension
    
    //MARK: - IBOutlets
    @IBOutlet weak var contentLabel: UILabel! {
        didSet {
            contentLabel.textColor = Theme.c6
            contentLabel.font = Font.h4
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
extension TermsCell {
    func setup(_ vm: CellRepresentable) {
        guard let vm = vm as? TermsCellVM else {
            fatalError("wrong cell representable")
        }
        
        contentLabel.text = vm.content
    }
}
