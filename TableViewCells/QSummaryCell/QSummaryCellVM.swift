//
//  QSummaryCellVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 23/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

struct QSummaryCellVM {
    var serviceName: String
    var reqDate: String
    var reqTime: String
    var requirements: String
    
    init(_ serviceName: String, reqDate: String, reqTime: String, requirements: String) {
        self.serviceName = serviceName
        self.reqDate = reqDate
        self.reqTime = reqTime
        self.requirements = requirements
    }
}

extension QSummaryCellVM: CellRepresentable {
    var rowHeight: CGFloat {
        return QSummaryCell.rowHeight
    }
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QSummaryCell.identifier, for: indexPath) as! QSummaryCell
        cell.setup(self)
        return cell
    }
}
