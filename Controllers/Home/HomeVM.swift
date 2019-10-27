//
//  HomeVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 19/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

//MARK: - State
struct HomeState {
    enum Action {
        case none
        case onCall
        case onSuccess(Api)
        case onFailed(String)
        case other(String)
    }
    
    enum Api {
        case providerProfile
        case updateAvailability
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

//MARK: - Class
class HomeVM {
    var isAvailable: Dynamic<Bool> = Dynamic(LocalUser.instance.isAvailable)
    
    private(set) var state = HomeState() {
        didSet {
            callback?(state)
        }
    }
    
    var callback: ((HomeState) -> ())?
    
    init() {
    }
    
    deinit {
        print("Home VM deinited")
    }
}

//MARK: - API Functions
extension HomeVM {
    func updateAvailability() {
        state.action = .onCall
        let param: [String : Any] = ["provider": LocalUser.instance.id!, "availability": isAvailable.value! ? "1" : "0"]
        HTTPManager.instance.updateAvailability(param: param) { [unowned self] (result) in
            switch result {
            case .success(_):
                //update isAvailable property in LocalUser
                LocalUser.instance.setIsAvailable(self.isAvailable.value!)
                self.state.action = .onSuccess(.updateAvailability)
            case .failure(let error):
                //to reset switch button in case of failure
                self.isAvailable.setValue(LocalUser.instance.isAvailable)
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    func getProviderProfile() {
        state.action = .onCall
        let param = ["provider_id": LocalUser.instance.id!]
        HTTPManager.instance.getProviderProfile(param: param, completionHandler: { [unowned self] (result) in
            switch result {
            case .success(_):
                //to set switch button
                self.isAvailable.setValue(LocalUser.instance.isAvailable)
                
                NotificationCenter.default.post(name: Notification.Name.profileUpdated,
                                                object: self,
                                                userInfo: nil)
                self.state.action = .onSuccess(.providerProfile)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        })
    }
}
