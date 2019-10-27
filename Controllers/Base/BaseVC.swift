//
//  BaseVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 12/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class RightContainerView: UIView { }
class MenuContainerView: UIView { }
class DarkCoverView: UIView { }

class BaseVC: UIViewController {

    let menuContainerView: MenuContainerView = {
        let view = MenuContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rightContainerView: RightContainerView = {
        let view = RightContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let darkView: DarkCoverView = {
        let view = DarkCoverView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var rightVC: UIViewController!
    var menuVC: UIViewController!
    
    var rightViewLeadingConstraint: NSLayoutConstraint!
    var rightViewTrailingConstraint: NSLayoutConstraint!
    
    fileprivate let menuWidth: CGFloat = 300
    fileprivate var isMenuOpened = false
    fileprivate var velocityThreshold: CGFloat = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.c2
        setupView()
        setupViewControllers()
        setupGestureRecognizer()
        setupTapGestureRecognizer()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//MARK: View Setup
extension BaseVC {
    fileprivate func setupView() {
        view.addSubview(rightContainerView)
        view.addSubview(menuContainerView)
        
        NSLayoutConstraint.activate([
            rightContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            rightContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            menuContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            menuContainerView.bottomAnchor.constraint(equalTo: rightContainerView.bottomAnchor),
            menuContainerView.trailingAnchor.constraint(equalTo: rightContainerView.leadingAnchor),
            menuContainerView.widthAnchor.constraint(equalToConstant: menuWidth)
            ])
        rightViewLeadingConstraint = rightContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        rightViewLeadingConstraint.isActive = true
        
        rightViewTrailingConstraint = rightContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        rightViewTrailingConstraint.isActive = true
    }
    
    fileprivate func setupViewControllers() {
        guard let _rightVC = rightVC,
            let _menuVC = menuVC else {
                return
        }
        
        let rightView = _rightVC.view!
        rightView.translatesAutoresizingMaskIntoConstraints = false
        
        let menuView = _menuVC.view!
        menuView.translatesAutoresizingMaskIntoConstraints = false
        
        rightContainerView.addSubview(rightView)
        rightContainerView.addSubview(darkView)
        menuContainerView.addSubview(menuView)
        
        NSLayoutConstraint.activate([
            rightView.topAnchor.constraint(equalTo: rightContainerView.topAnchor),
            rightView.bottomAnchor.constraint(equalTo: rightContainerView.bottomAnchor),
            rightView.leadingAnchor.constraint(equalTo: rightContainerView.leadingAnchor),
            rightView.trailingAnchor.constraint(equalTo: rightContainerView.trailingAnchor),
            
            menuView.topAnchor.constraint(equalTo: menuContainerView.topAnchor),
            menuView.bottomAnchor.constraint(equalTo: menuContainerView.bottomAnchor),
            menuView.leadingAnchor.constraint(equalTo: menuContainerView.leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: menuContainerView.trailingAnchor),
            
            darkView.topAnchor.constraint(equalTo: rightContainerView.topAnchor),
            darkView.leadingAnchor.constraint(equalTo: rightContainerView.leadingAnchor),
            darkView.bottomAnchor.constraint(equalTo: rightContainerView.bottomAnchor),
            darkView.trailingAnchor.constraint(equalTo: rightContainerView.trailingAnchor),
            ])
        
        addChild(_rightVC)
        addChild(_menuVC)
    }
}

//MARK: Gesture Setup
extension BaseVC {
    fileprivate func setupGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
    }
    
    fileprivate func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        darkView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(gesture: UIPanGestureRecognizer){
        closeMenu()
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer){
        //tp prevent pan gesture when menu is closed
        if !isMenuOpened {
            return
        }
        let translation = gesture.translation(in: view)
        var x = translation.x
        
        x = isMenuOpened ? x + menuWidth : x
        
        x = min(menuWidth, x)
        x = max(0, x)
        
        rightViewLeadingConstraint.constant = x
        rightViewTrailingConstraint.constant = x
        darkView.alpha = x / menuWidth
        
        if gesture.state == .ended{
            handleEnded(gesture: gesture)
        }
    }
    
    fileprivate func handleEnded(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        if (!isMenuOpened  && translation.x < 0) || (isMenuOpened && translation.x > 0) {
            return
        }
        
        if isMenuOpened {
            if abs(velocity.x) > velocityThreshold {
                closeMenu()
                return
            }
            if abs(translation.x) < menuWidth / 2 {
                openMenu()
            } else {
                closeMenu()
            }
        } else {
            if abs(velocity.x) > velocityThreshold {
                openMenu()
                return
            }
            
            if translation.x < menuWidth / 2 {
                closeMenu()
            } else {
                openMenu()
            }
        }
    }
    
}

//MARK: Menu operation [open/close]
extension BaseVC {
    func openMenu() {
        isMenuOpened = true
        rightViewLeadingConstraint.constant = menuWidth
        rightViewTrailingConstraint.constant = menuWidth
        performAnimations()
    }
    
    func closeMenu() {
        rightViewLeadingConstraint.constant = 0
        rightViewTrailingConstraint.constant = 0
        isMenuOpened = false
        performAnimations()
    }
    
    fileprivate func performAnimations() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.darkView.alpha = self.isMenuOpened ? 1 : 0
        })
    }
}
