//
//  QFooterVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 23/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

struct QFooterVM {
}

extension QFooterVM: ViewRepresentable {
    var viewHeight: CGFloat {
        return QFooterView.viewHeight
    }
    
    func viewInstance() -> UIView {
        let view = QFooterView()
        return view
    }
}
