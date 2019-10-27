//
//  AutoDismissAlert.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 01/06/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

protocol AutoDismissAlert {
    func showAutoDismissAlert(_ title: String?, message: String, time: Double)
    func showAutoDismissAlert(_ title: String?, message: String, time: Double, action: @escaping () -> ())
}


extension AutoDismissAlert where Self: UIViewController {
    func showAutoDismissAlert(_ title: String?, message: String, time: Double = 2.0) {
        var alertTitle: String!
        var alertMessage: String?
        
        if let title = title {
            alertTitle = title
            alertMessage = message
        } else {
            alertTitle = message
        }
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    func showAutoDismissAlert(_ title: String?, message: String, time: Double = 2.0, action: @escaping () -> ()) {
        var alertTitle: String!
        var alertMessage: String?
        
        if let title = title {
            alertTitle = title
            alertMessage = message
        } else {
            alertTitle = message
        }
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            alertController.dismiss(animated: true) {
                action()
            }
        }
    }
}
