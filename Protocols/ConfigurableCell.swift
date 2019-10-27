//
//  CellRepresentable.swift
//  Loqal
//
//  Created by Sreejith Ajithkumar on 17/05/18.
//  Copyright © 2018 Sreejith Ajithkumar. All rights reserved.
//

import UIKit


protocol CellRepresentable {
    var rowHeight: CGFloat { get }
    func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}


protocol ViewRepresentable {
    var viewHeight: CGFloat { get }
    func viewInstance() -> UIView
}
