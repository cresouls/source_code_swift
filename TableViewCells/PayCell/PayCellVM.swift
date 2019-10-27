//
//  PayCellVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 24/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

struct PayCellVM {
    
    let regNo: String
    let amount: String
    let status: String
    let date: String
    let monthYear: String
    
    init(_ regNo: String, amount: String, status: String, date: String, monthYear: String) {
        self.regNo = regNo
        self.amount = amount
        self.status = status
        self.date = date
        self.monthYear = monthYear
    }
}

extension PayCellVM: CellRepresentable {
    var rowHeight: CGFloat {
        return PayCell.rowHeight
    }
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PayCell.identifier, for: indexPath) as! PayCell
        cell.setup(self)
        return cell
    }
}
