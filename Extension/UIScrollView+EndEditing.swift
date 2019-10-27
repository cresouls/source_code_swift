//
//  UIScrollView+EndEditing.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 24/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        self.superview?.endEditing(true)
    }
    
    //    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        self.next?.touchesMoved(touches, with: event)
    //        print("touchesMoved")
    //    }
    //
    //    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        self.next?.touchesEnded(touches, with: event)
    //        print("touchesEnded")
    //    }
}

extension UIViewController {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
