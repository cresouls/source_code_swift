//
//  QHeaderVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 23/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

struct QHeaderVM {
}

extension QHeaderVM: ViewRepresentable {
    var viewHeight: CGFloat {
        return QHeaderView.viewHeight
    }
    
    func viewInstance() -> UIView {
        let view = QHeaderView()
        return view
    }
}
