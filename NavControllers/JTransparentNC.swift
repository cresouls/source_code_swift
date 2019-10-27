//
//  JTransparentNC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 07/06/18.
//  Copyright © 2018 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class LTransparentNC: UINavigationController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = Theme.c2
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
    }

    //MARK: - Other VC Functions
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
