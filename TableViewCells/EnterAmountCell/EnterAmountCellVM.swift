//
//  EnterAmountCellVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 23/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

protocol EnterAmountCellVMDelegate: class {
    func submitAmount(_ amount: String?, vm: EnterAmountCellVM)
}

struct EnterAmountCellVM {
    private weak var delegate: EnterAmountCellVMDelegate?
    
    init(_ delegate: EnterAmountCellVMDelegate?) {
        self.delegate = delegate
    }
    
    func submitData(_ amount: String?) {
        delegate?.submitAmount(amount, vm: self)
    }
}

extension EnterAmountCellVM: CellRepresentable {
    var rowHeight: CGFloat {
        return EnterAmountCell.rowHeight
    }
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EnterAmountCell.identifier, for: indexPath) as! EnterAmountCell
        cell.setup(self)
        return cell
    }
}
