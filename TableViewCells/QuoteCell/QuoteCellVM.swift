//
//  QuoteCellVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 23/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

struct QuoteCellVM {
    var amount: String
    var createdDate: String
    
    init(_ amount: String, createdDate: String) {
        self.amount = amount
        self.createdDate = createdDate
    }
}

extension QuoteCellVM: CellRepresentable {
    var rowHeight: CGFloat {
        return QuoteCell.rowHeight
    }
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuoteCell.identifier, for: indexPath) as! QuoteCell
        cell.setup(self)
        return cell
    }
}
