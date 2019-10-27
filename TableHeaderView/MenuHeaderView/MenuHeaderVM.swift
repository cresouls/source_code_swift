//
//  MenuHeaderVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 19/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

struct MenuHeaderVM {
    
    let title: String
    let subtitle: String
    let dpURL: URL?
    
    init(_ title: String, subtitle: String, dpURL: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.dpURL = dpURL
    }
}

extension MenuHeaderVM: ViewRepresentable {
    var viewHeight: CGFloat {
        return MenuHeaderView.viewHeight
    }
    
    func viewInstance() -> UIView {
        let view = MenuHeaderView()
        view.setup(self)
        return view
    }
}
