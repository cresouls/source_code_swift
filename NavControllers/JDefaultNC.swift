//
//  JDefaultNC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 17/05/18.
//  Copyright © 2018 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class JDefaultNC: UINavigationController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = Theme.c1
        self.navigationBar.tintColor = Theme.c2
        self.navigationBar.isTranslucent = false
        self.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: Theme.c2,
             NSAttributedString.Key.font: Font.h4]
    }

    //MARK: - Other NC Functions
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
