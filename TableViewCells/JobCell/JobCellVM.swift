//
//  JobCellVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 22/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

struct JobCellVM {
    
    let reqId: String?
    let customerName: String?
    let serviceName: String
    let reqDate: String
    
    init(_ reqId: String?, customerName: String?, serviceName: String, reqDate: String) {
        self.reqId = reqId != nil ? "ORDER REQID: \(reqId!)" : nil
        self.customerName = customerName != nil ? "Customer Name: \(customerName!)" : nil
        self.serviceName = "Service: \(serviceName)"
        self.reqDate = "Requested Date: \(reqDate)"
    }
}

extension JobCellVM: CellRepresentable {
    var rowHeight: CGFloat {
        return JobCell.rowHeight
    }
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobCell.identifier, for: indexPath) as! JobCell
        cell.setup(self)
        return cell
    }
}

