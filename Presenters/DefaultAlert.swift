//
//  DefaultAlert.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 01/06/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

protocol DefaultAlert {
    func showAlert(_ title: String?, message: String, actionTitle: String)
    func showAlert(_ title: String?, message: String, actionTitle: String, cancelTitle: String, action: @escaping () -> ())
}

extension DefaultAlert where Self: UIViewController {
    func showAlert(_ title: String?, message: String, actionTitle: String = "Ok") {
        var alertTitle: String!
        var alertMessage: String?
        
        if let title = title {
            alertTitle = title
            alertMessage = message
        } else {
            alertTitle = message
        }
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(_ title: String?, message: String, actionTitle: String, cancelTitle: String, action: @escaping () -> () = {  }) {
        var alertTitle: String!
        var alertMessage: String?
        
        if let title = title {
            alertTitle = title
            alertMessage = message
        } else {
            alertTitle = message
        }
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: { (_) in
            action()
        }))
        alertController.addAction(UIAlertAction(title: cancelTitle, style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
