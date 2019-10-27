//
//  TermsCellVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 17/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

struct TermsCellVM {
    
    let content: String
    
    init(_ content: String) {
        self.content = content
    }
}

extension TermsCellVM: CellRepresentable {
    var rowHeight: CGFloat {
        return TermsCell.rowHeight
    }
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TermsCell.identifier, for: indexPath) as! TermsCell
        cell.setup(self)
        return cell
    }
}
