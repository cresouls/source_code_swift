//
//  UIViewController+MenuPopDismiss.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 11/06/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

extension UIViewController {
    var isModal: Bool {
        
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
    var isPushed: Bool {
        guard let nc = navigationController else {
            return false
        }
        return nc.viewControllers.count > 1
    }
    
    func addMenuPopDismissButton() {
        if isModal {
            let popDismissButton = UIBarButtonItem.init(image: UIImage(named: "dismiss"), style: .plain, target: self, action: #selector(menuPopDismiss))
            navigationItem.leftBarButtonItem = popDismissButton
        } else if isPushed {
            let popDismissButton = UIBarButtonItem.init(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(menuPopDismiss))
            navigationItem.leftBarButtonItem = popDismissButton
        } else {
            //right code to click open
            let popDismissButton = UIBarButtonItem.init(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(menuPopDismiss))
            navigationItem.leftBarButtonItem = popDismissButton
        }
    }
    
    @objc func menuPopDismiss() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else if isPushed {
            guard let nc = navigationController else {
                fatalError("Navigation controller not found")
            }
            if let _ = self as? PopToRoot {
                nc.popToRootViewController(animated: true)
            } else {
                nc.popViewController(animated: true)
            }
        } else {
            guard let vc = UIApplication.shared.keyWindow?.rootViewController as? BaseVC else {
                fatalError("Base controller not found")
            }
            vc.openMenu()
        }
    }
    
    func popDismiss(completionBlock: @escaping () -> () = { }) {
        if isModal {
            self.dismiss(animated: true) {
                completionBlock()
            }
        } else {
            guard let nc = navigationController else {
                fatalError("Navigation controller not found")
            }
            
            completionBlock()
            if let _ = self as? PopToRoot {
                nc.popToRootViewController(animated: true)
            } else {
                nc.popViewController(animated: true)
            }
        }
    }
}


protocol PopToRoot {
    
}
