//
//  MiscHeaderVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 19/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

struct MiscHeaderVM {
}

extension MiscHeaderVM: ViewRepresentable {
    var viewHeight: CGFloat {
        return MiscHeaderView.viewHeight
    }
    
    func viewInstance() -> UIView {
        let view = MiscHeaderView()
        return view
    }
}
