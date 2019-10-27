//
//  Router.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 07/06/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit
import AVFoundation

enum RoutingType {
    case root
    case push
    case modal
    case pushOnCurrentVC
    
    func route(_ to: UIViewController, on: UIViewController?) {
        switch self {
        case .root:
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.window?.rootViewController = to
        case .modal:
            guard let on = on else {
                fatalError("couldn't find presented view controller")
            }
            on.present(to, animated: true, completion: nil)
        case .push:
            guard let nc = on?.navigationController else {
                fatalError("couldn't find navigation controller to push")
            }
            nc.pushViewController(to, animated: true)
        case .pushOnCurrentVC:
            guard let baseVC = UIApplication.shared.keyWindow?.rootViewController as? BaseVC,
                let tc = baseVC.rightVC as? UITabBarController,
                let nc = tc.selectedViewController as? UINavigationController else {
                    fatalError("couldn't find navigation controller to push")
            }
            nc.pushViewController(to, animated: true)
        }
    }
}

//Login
protocol LoginRouter {
    func goToLogin(_ routingType: RoutingType, vm: LoginVM)
}

extension LoginRouter where Self: UIViewController {
    func goToLogin(_ routingType: RoutingType = .root, vm: LoginVM = LoginVM()) {
        let vc = LoginVC.loadFromNib()
        vc.vm = vm
        
        var nc: UINavigationController?
        if (routingType == .root || routingType == .modal) {
            nc = LTransparentNC(rootViewController: vc)
        }
        routingType.route(nc ?? vc, on: self)
    }
}

extension LoginRouter where Self: AppDelegate {
    func goToLogin(_ routingType: RoutingType = .root, vm: LoginVM = LoginVM()) {
        let vc = LoginVC.loadFromNib()
        vc.vm = vm
        
        var nc: UINavigationController?
        if (routingType == .root || routingType == .modal) {
            nc = LTransparentNC(rootViewController: vc)
        }
        routingType.route(nc ?? vc, on: nil)
    }
}

//Verify
protocol VerifyRouter {
    func goToVerify(_ routingType: RoutingType, vm: VerifyVM)
}

extension VerifyRouter where Self: UIViewController {
    func goToVerify(_ routingType: RoutingType = .push, vm: VerifyVM) {
        let vc = VerifyVC.loadFromNib()
        vc.vm = vm
        routingType.route(vc, on: self)
    }
}

//Forgot Password
protocol ForgotPasswordRouter {
    func goToForgotPassword(_ routingType: RoutingType, vm: ForgotPasswordVM)
}

extension ForgotPasswordRouter where Self: UIViewController {
    func goToForgotPassword(_ routingType: RoutingType = .push, vm: ForgotPasswordVM = ForgotPasswordVM()) {
        let vc = ForgotPasswordVC.loadFromNib()
        vc.vm = vm
        routingType.route(vc, on: self)
    }
}

//Change Password
protocol ChangePasswordRouter {
    func goToChangePassword(_ routingType: RoutingType, vm: ChangePasswordVM)
}

extension ChangePasswordRouter where Self: UIViewController {
    func goToChangePassword(_ routingType: RoutingType = .push, vm: ChangePasswordVM) {
        let vc = ChangePasswordVC.loadFromNib()
        vc.vm = vm
        routingType.route(vc, on: self)
    }
}

//Sign Up
protocol SignUpRouter {
    func goToSignUp(_ routingType: RoutingType, vm: SignUpVM)
}

extension SignUpRouter where Self: UIViewController {
    func goToSignUp(_ routingType: RoutingType = .push, vm: SignUpVM) {
        let vc = SignUpVC.loadFromNib()
        vc.vm = vm
        routingType.route(vc, on: self)
    }
}

//Select City
protocol SelectCityRouter {
    func goToSelectCity(_ routingType: RoutingType, vm: SelectCityVM)
}

extension SelectCityRouter where Self: UIViewController {
    func goToSelectCity(_ routingType: RoutingType = .modal, vm: SelectCityVM) {
        let vc = SelectCityVC.loadFromNib()
        vc.vm = vm
        
        var nc: UINavigationController?
        if (routingType == .root || routingType == .modal) {
            nc = JDefaultNC(rootViewController: vc)
        }
        routingType.route(nc ?? vc, on: self)
    }
}

//Select Categories
protocol SelectCategoriesRouter {
    func goToSelectCategories(_ routingType: RoutingType, vm: SelectCategoriesVM)
}

extension SelectCategoriesRouter where Self: UIViewController {
    func goToSelectCategories(_ routingType: RoutingType = .modal, vm: SelectCategoriesVM) {
        let vc = SelectCategoriesVC.loadFromNib()
        vc.vm = vm
        
        var nc: UINavigationController?
        if (routingType == .root || routingType == .modal) {
            nc = JDefaultNC(rootViewController: vc)
        }
        routingType.route(nc ?? vc, on: self)
    }
}

//Home
protocol HomeRouter {
    func goToHome(_ routingType: RoutingType)
}

extension HomeRouter where Self: UIViewController {
    func goToHome(_ routingType: RoutingType = .root) {
        let baseVC = BaseVC()
        
        let nc1 = JDefaultNC()
        let homeVC = HomeVC.loadFromNib()
        homeVC.vm = HomeVM()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage.init(named: "tabHome"), selectedImage: nil)
        nc1.viewControllers = [homeVC]
        
        let nc2 = JDefaultNC()
        let jobVC = JobsVC.loadFromNib()
        jobVC.vm = JobsVM()
        jobVC.tabBarItem = UITabBarItem(title: "Jobs", image: UIImage.init(named: "tabJobs"), selectedImage: nil)
        nc2.viewControllers = [jobVC]
        
        let nc3 = JDefaultNC()
        let profileVC = ProfileVC.loadFromNib()
        profileVC.vm = ProfileVM()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage.init(named: "tabProfile"), selectedImage: nil)
        nc3.viewControllers = [profileVC]
        
        let tc = JDefaultTC()
        tc.viewControllers = [nc1, nc2, nc3]
        baseVC.rightVC = tc
        
        let menuVC = MenuVC()
        menuVC.vm = MenuVM()
        baseVC.menuVC = menuVC
        
        routingType.route(baseVC, on: nil)
    }
}

extension HomeRouter where Self: AppDelegate {
    func goToHome(_ routingType: RoutingType = .root) {
        let baseVC = BaseVC()
        
        let nc1 = JDefaultNC()
        let homeVC = HomeVC.loadFromNib()
        homeVC.vm = HomeVM()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage.init(named: "tabHome"), selectedImage: nil)
        nc1.viewControllers = [homeVC]
        
        let nc2 = JDefaultNC()
        let jobVC = JobsVC.loadFromNib()
        jobVC.vm = JobsVM()
        jobVC.tabBarItem = UITabBarItem(title: "Jobs", image: UIImage.init(named: "tabJobs"), selectedImage: nil)
        nc2.viewControllers = [jobVC]
        
        let nc3 = JDefaultNC()
        let profileVC = ProfileVC.loadFromNib()
        profileVC.vm = ProfileVM()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage.init(named: "tabProfile"), selectedImage: nil)
        nc3.viewControllers = [profileVC]
        
        let tc = JDefaultTC()
        tc.viewControllers = [nc1, nc2, nc3]
        baseVC.rightVC = tc
        
        let menuVC = MenuVC()
        menuVC.vm = MenuVM()
        baseVC.menuVC = menuVC
        
        routingType.route(baseVC, on: nil)
    }
}

//EditProfile
protocol EditProfileRouter {
    func goToEditProfile(_ routingType: RoutingType, vm: EditProfileVM)
}

extension EditProfileRouter where Self: UIViewController {
    func goToEditProfile(_ routingType: RoutingType = .modal, vm: EditProfileVM = EditProfileVM()) {
        
        let nc = JDefaultNC()
        let vc = EditProfileVC.loadFromNib()
        vc.vm = vm
        nc.viewControllers = [vc]
        routingType.route(nc, on: self)
    }
}

//QDetail
protocol QDetailRouter {
    func goToQDetail(_ routingType: RoutingType, vm: QDetailVM)
}

extension QDetailRouter where Self: UIViewController {
    func goToQDetail(_ routingType: RoutingType = .push, vm: QDetailVM) {
        
        let vc = QDetailVC.loadFromNib()
        vc.hidesBottomBarWhenPushed = true
        vc.vm = vm
        routingType.route(vc, on: self)
    }
}

//JDetail
protocol JDetailRouter {
    func goToJDetail(_ routingType: RoutingType, vm: JDetailVM)
}

extension JDetailRouter where Self: UIViewController {
    func goToJDetail(_ routingType: RoutingType = .push, vm: JDetailVM) {
        
        let vc = JDetailVC.loadFromNib()
        vc.hidesBottomBarWhenPushed = true
        vc.vm = vm
        routingType.route(vc, on: self)
    }
}

//Payment
protocol PaymentRouter {
    func goToPayment(_ routingType: RoutingType, vm: PaymentVM)
}

extension PaymentRouter where Self: UIViewController {
    func goToPayment(_ routingType: RoutingType = .push, vm: PaymentVM = PaymentVM()) {
        
        let vc = PaymentVC.loadFromNib()
        vc.vm = vm
        routingType.route(vc, on: self)
    }
}

//Terms
protocol TermsRouter {
    func goToTerms(_ routingType: RoutingType, vm: TermsVM)
}

extension TermsRouter where Self: UIViewController {
    func goToTerms(_ routingType: RoutingType = .pushOnCurrentVC, vm: TermsVM = TermsVM()) {
        let vc = TermsVC.loadFromNib()
        vc.vm = vm
        
        routingType.route(vc, on: nil)
    }
}

protocol TermsNonMenuRouter {
    func goToTerms(_ routingType: RoutingType, vm: TermsVM)
}

extension TermsNonMenuRouter where Self: UIViewController {
    func goToTerms(_ routingType: RoutingType = .modal, vm: TermsVM = TermsVM()) {
        let vc = TermsVC.loadFromNib()
        vc.vm = vm
        
        var nc: UINavigationController?
        if (routingType == .root || routingType == .modal) {
            nc = LTransparentNC(rootViewController: vc)
        }
        routingType.route(nc ?? vc, on: self)
    }
}

//About
protocol AboutRouter {
    func goToAbout(_ routingType: RoutingType, vm: AboutVM)
}

extension AboutRouter where Self: UIViewController {
    func goToAbout(_ routingType: RoutingType = .pushOnCurrentVC, vm: AboutVM = AboutVM()) {
        let vc = AboutVC.loadFromNib()
        vc.vm = vm
        
        routingType.route(vc, on: nil)
    }
}
