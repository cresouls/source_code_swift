//
//  MenuVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 12/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit
import StoreKit

class MenuVC: UIViewController, NibLoadable {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.separatorStyle = .none
            tableView.backgroundColor = Theme.c2
            
            tableView.register(UINib(nibName: MenuCell.identifier, bundle: nil), forCellReuseIdentifier: MenuCell.identifier)
        }
    }
    
    //MARK: - Properties
    var vm: MenuVM?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vm?.callback = { [unowned self] (state) in
            switch state.action {
            case .none:
                print("none")
            case .tableUpdate:
                self.tableView.reloadData()
            case .goToTerms:
                self.goToTerms()
            case .goToAbout:
                self.goToAbout()
            case .signOut:
                self.goToLogin()
            case .rateApp:
                SKStoreReviewController.requestReview()
            case .callUs(let url):
                UIApplication.shared.open(url)
            }
        }
        
        vm?.getMenu()
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension MenuVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm!.data[section].cellRepresentables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellRepresentable = vm!.data[indexPath.section].cellRepresentables[indexPath.row]
        return cellRepresentable.cellInstance(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellRepresentable = vm!.data[indexPath.section].cellRepresentables[indexPath.row]
        return cellRepresentable.rowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellRepresentable = vm!.data[indexPath.section].cellRepresentables[indexPath.row]
        return cellRepresentable.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (UIApplication.shared.keyWindow?.rootViewController as? BaseVC)?.closeMenu()
        vm?.didSelect(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewRepresentable = vm!.data[section].viewRepresentable
        return viewRepresentable.viewInstance()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let viewRepresentable = vm!.data[section].viewRepresentable
        return viewRepresentable.viewHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let viewRepresentable = vm!.data[section].viewRepresentable
        return viewRepresentable.viewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.05
    }
}

//MARK: - LoginRouter
extension MenuVC: LoginRouter { }

//MARK: - TermsRouter
extension MenuVC: TermsRouter { }

//MARK: - AboutRouter
extension MenuVC: AboutRouter { }
