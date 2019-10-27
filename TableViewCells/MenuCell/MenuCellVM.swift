//
//  MenuCellVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 19/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

struct MenuCellVM {
    
    let title: String
    let image: UIImage
    let isDark: Bool
    
    init(_ title: String, image: UIImage, isDark: Bool) {
        self.title = title
        self.image = image
        self.isDark = isDark
    }
}

extension MenuCellVM: CellRepresentable {
    var rowHeight: CGFloat {
        return MenuCell.rowHeight
    }
    
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as! MenuCell
        cell.setup(self)
        return cell
    }
}
