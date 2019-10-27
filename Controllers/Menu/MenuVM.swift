//
//  MenuVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 19/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation
import UIKit

enum MenuItems {
    case terms
    case about
    case notifications
    case signOut
    case rate
    case call
    
    var title: String {
        switch self {
        case .terms:
            return "Terms and Conditions"
        case .about:
            return "About Us"
        case .notifications:
            return "Notifications"
        case .signOut:
            return "Sign out"
        case .rate:
            return "Rate Us"
        case .call:
            return "Call Us"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .terms:
            return UIImage(named: "terms")!
        case .about:
            return UIImage(named: "about")!
        case .notifications:
            return UIImage(named: "notification")!
        case .signOut:
            return UIImage(named: "logout")!
        case .rate:
            return UIImage(named: "star")!
        case .call:
            return UIImage(named: "callUs")!
        }
    }
}

enum Section {
    case profileHeader
    case misc
    
    var menuItems: [MenuItems] {
        switch self {
        case .profileHeader:
            return [.terms, .about, .notifications, .signOut]
        case .misc:
            return [.rate, .call]
        }
    }
}

struct MenuRepresentable {
    var viewRepresentable: ViewRepresentable
    var cellRepresentables: [CellRepresentable]
}

//MARK: - State
struct MenuState {
    enum Action {
        case none
        case tableUpdate
        case goToTerms
        case goToAbout
        case rateApp
        case signOut
        case callUs(URL)
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

//MARK: - Class
class MenuVM {
    var data: [MenuRepresentable] = []
    var menu: [Section] = [.profileHeader, .misc]
    
    private(set) var state = MenuState() {
        didSet {
            callback?(state)
        }
    }
    
    var callback: ((MenuState) -> ())?
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(profileUpdated),
                                               name: Notification.Name.profileUpdated,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.profileUpdated,
                                                  object: nil)
        print("Menu VM deinited")
    }
}

//MARK: - Functions
extension MenuVM {
    @objc func profileUpdated() {
        getMenu()
    }
    
    func getMenu() {
        var _data = [MenuRepresentable]()
        
        for section in menu {
            var viewRepresentable: ViewRepresentable?
            var isDark = false
            switch section {
            case.profileHeader:
                viewRepresentable = MenuHeaderVM(LocalUser.instance.name, subtitle: LocalUser.instance.mobile ?? "", dpURL: LocalUser.instance.dpURL)
                isDark = true
            case .misc:
                viewRepresentable = MiscHeaderVM()
            }
            
            var cellRepresentables = [CellRepresentable]()
            for menuItem in section.menuItems {
                let cellRepresentable = MenuCellVM(menuItem.title, image: menuItem.icon, isDark: isDark)
                cellRepresentables.append(cellRepresentable)
            }
            let menuRepresentable = MenuRepresentable(viewRepresentable: viewRepresentable!, cellRepresentables: cellRepresentables)
            _data.append(menuRepresentable)
        }
        
        data = _data
        state.action = .tableUpdate
    }
}

//MARK: - TableView Functions
extension MenuVM {
    func didSelect(_ indexPath: IndexPath) {
        let menuItem = menu[indexPath.section].menuItems[indexPath.row]
        switch menuItem {
        case .terms:
            state.action = .goToTerms
        case .about:
            state.action = .goToAbout
        case .signOut:
            LocalUser.instance.signOut()
            state.action = .signOut
        case .rate:
            state.action = .rateApp
        case .call:
            if let phoneNumber = URL(string: "tel://\(91860622277)") {
                state.action = .callUs(phoneNumber)
            }
        default:
            print("Other cases")
        }
    }
}
