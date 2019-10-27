//
//  HomeVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 08/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, NibLoadable {

    //MARK: - IBOutlets
    @IBOutlet weak var upcomingJobsButton: VerticalButtonView! {
        didSet {
            upcomingJobsButton.title = "UPCOMING JOBS"
            upcomingJobsButton.titleFont = Font.h7
            upcomingJobsButton.titleColor = Theme.c1
            upcomingJobsButton.image = UIImage(named: "upcomingJobs")
            
            upcomingJobsButton.delegate = self
        }
    }
    
    @IBOutlet weak var paymentButton: VerticalButtonView! {
        didSet {
            paymentButton.title = "PAYMENT"
            paymentButton.titleFont = Font.h7
            paymentButton.titleColor = Theme.c1
            paymentButton.image = UIImage(named: "payment")
            
            paymentButton.delegate = self
        }
    }
    
    @IBOutlet weak var availableStatusLabel: UILabel! {
        didSet {
            availableStatusLabel.textColor = Theme.c1
            availableStatusLabel.font = Font.h4
        }
    }
    
    @IBOutlet weak var isAvailableSwitch: UISwitch! {
        didSet {
            isAvailableSwitch.onTintColor = Theme.c1
        }
    }
    
    //MARK: - Properties
    var vm: HomeVM?
    private lazy var hud = Hud(color: Theme.c7)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("Home")
        addMenuPopDismissButton()
        bindViewModel()
        
        vm?.callback = { [unowned self] (state) in
            switch state.action {
            case .none:
                print("none")
            case .onCall:
                self.hud.start()
            case .onSuccess(_):
                self.hud.stop()
            case .onFailed(let message):
                self.hud.stop()
                self.showAlert("Error", message: message)
            case .other(let message):
                self.hud.stop()
                self.showAutoDismissAlert(nil, message: message)
            }
        }
        
        vm?.getProviderProfile()
    }
    
    deinit {
        print("Home VC deinited")
    }
}

//MARK: - Bind
extension HomeVC {
    func bindViewModel() {
        //to view model
        isAvailableSwitch.bind { [unowned self] in
            self.availableStatusLabel.text = $0 ? "I am available" : "I am not available"
            self.vm?.isAvailable.value = $0
            self.vm?.updateAvailability()
        }
        
        //to view controller
        vm?.isAvailable.bind = { [unowned self] in
            self.isAvailableSwitch.isOn = $0
            self.availableStatusLabel.text = $0 ? "I am available" : "I am not available"
        }
        
        //set value to viewcontroller on load
        if let isAvailable = vm?.isAvailable.value {
            self.isAvailableSwitch.isOn = isAvailable
            self.availableStatusLabel.text = isAvailable ? "I am available" : "I am not available"
            
        }
    }
}

//MARK: - VerticalButtonViewDelegate
extension HomeVC: VerticalButtonViewDelegate {
    func tappedOnVerticalButton(_ sender: VerticalButtonView) {
        if sender == paymentButton {
            goToPayment()
        } else if sender == upcomingJobsButton {
//            if let nc = self.tabBarController?.viewControllers?[1] as? UINavigationController,
//                let vc = nc.viewControllers.first {
//                if vc.isViewLoaded {
//                    print("its loaded")
//                }
//            }
            self.tabBarController?.selectedIndex = 1
        }
    }
}

//MARK: - DefaultAlert
extension HomeVC: DefaultAlert { }

//MARK: - AutoDismissAlert
extension HomeVC: AutoDismissAlert { }

//MARK: - PaymentRouter
extension HomeVC: PaymentRouter { }
