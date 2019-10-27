//
//  SimpleCellVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 17/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

struct SimpleCellVM {
    
    let title: String
    let isSelected: Bool
    
    init(_ title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
}

extension SimpleCellVM: CellRepresentable {
    var rowHeight: CGFloat {
        return SimpleCell.rowHeight
    }
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SimpleCell.identifier, for: indexPath) as! SimpleCell
        cell.setup(self)
        return cell
    }
}
