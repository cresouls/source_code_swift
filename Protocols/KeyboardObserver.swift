//
//  KeyboardObserver.swift
//  Loqal
//
//  Created by Sreejith Ajithkumar on 12/06/18.
//  Copyright © 2018 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

protocol KeyboardObserver{
    func keyboardNotifications(shouldRegister:Bool)
    var container: UIView { get }
    var firstResponder: UIView? { get }
}

extension KeyboardObserver{
    func keyboardNotifications(shouldRegister:Bool){
        var willShowObserver: NSObjectProtocol? //1
        var willHideObserver: NSObjectProtocol?
        
        if shouldRegister{ //2
            willShowObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                                                      object: nil, queue: OperationQueue.main,
                                                                      using: handler(notification:))
            
            willHideObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                                                      object: nil, queue: OperationQueue.main,
                                                                      using: handler(notification:))
        } else { //3
            if let observer1 = willShowObserver, let observer2 = willHideObserver{
                NotificationCenter.default.removeObserver(observer1)
                NotificationCenter.default.removeObserver(observer2)
            }
        }
    }
    
    func handler(notification: Notification){
        //1
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let animationDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let up = notification.name == UIResponder.keyboardWillShowNotification ? true : false
        
        //let firstResponder = Utility.findFirstResponder(inView: container)
        
        if let firstResponder = firstResponder {
            
            let movementDuration: TimeInterval = animationDuration
            UIView.beginAnimations( "animateView", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(movementDuration )
            //2
            let frame = firstResponder.frame
            let visibleContainerHeight = container.frame.height - keyboardRect.height
            let firstResponderPosition = frame.origin.y + frame.height

            let offsetY = visibleContainerHeight - firstResponderPosition
            let bottomPadding: CGFloat = 10.0
            
            if up{ //3
                
                if firstResponderPosition > visibleContainerHeight && !(container is UIScrollView) {
                    container.transform = CGAffineTransform(translationX: 0, y: offsetY)
                } else if container is UIScrollView {
                    (container as! UIScrollView).contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardRect.height + bottomPadding, right: 0)
                    
                    var frame:CGRect
                    
                    if let  rect = firstResponder.superview?.convert(firstResponder.frame, to: container){
                        frame = rect
                    } else{
                        frame = firstResponder.frame
                    }
                    (container as! UIScrollView).scrollRectToVisible(frame.offsetBy(dx: 0, dy: bottomPadding),
                                                                  animated: true)
                }
                
            } else { //4
                
                if container is UIScrollView{
                    (container as! UIScrollView).contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
                } else if firstResponderPosition > visibleContainerHeight {
                    container.transform = CGAffineTransform.identity
                }
            }
            UIView.commitAnimations()
        }
    }
}


class Utility{
    class func findFirstResponder(inView view: UIView) -> UIView? {
        for subView in view.subviews  {
            if subView.isFirstResponder {
                return subView
            }
            
            if let recursiveSubView = self.findFirstResponder(inView: subView) {
                return recursiveSubView
            }
        }
        return nil
    }
}
