//
//  JDefaultTC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 08/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class JDefaultTC: UITabBarController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = Theme.c2
        self.tabBar.tintColor = Theme.c1
        self.tabBar.isTranslucent = false
    }

}

//extension JDefaultTC: UITabBarControllerDelegate {
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        if let rootView = self.viewControllers?[self.selectedIndex] as? UINavigationController {
//            rootView.popToRootViewController(animated: false)
//        }
//    }
//}
