//
//  UITableView+EmptyMessage.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 24/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

extension UITableView {
    func setEmptyMessage(_ title: String, message: String) {
        let emptyMessageView = TableEmptyView()
        emptyMessageView.title = title
        emptyMessageView.message = message
        self.backgroundView = emptyMessageView;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

