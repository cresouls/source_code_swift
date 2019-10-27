//
//  AboutVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 08/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class AboutVC: UIViewController, NibLoadable {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.separatorStyle = .none
            tableView.tableFooterView = UIView()
            
            tableView.register(UINib(nibName: TermsCell.identifier, bundle: nil), forCellReuseIdentifier: TermsCell.identifier)
        }
    }
    
    //MARK: - Properties
    var vm: AboutVM?
    private lazy var hud = Hud(color: Theme.c7)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("About Us")
        addMenuPopDismissButton()
        
        vm?.callback = { [unowned self] (state) in
            switch state.action {
            case .none:
                print("none")
            case .onCall:
                self.hud.start()
            case .onSuccess:
                self.hud.stop()
                self.tableView.reloadData()
            case .onFailed(let message):
                self.hud.stop()
                self.showAlert("Error", message: message)
            case .other(let message):
                self.hud.stop()
                self.showAutoDismissAlert(nil, message: message)
            }
        }
        
        vm?.getData()
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension AboutVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellRepresentable = vm!.data[indexPath.row]
        return cellRepresentable.cellInstance(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellRepresentable = vm!.data[indexPath.row]
        return cellRepresentable.rowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellRepresentable = vm!.data[indexPath.row]
        return cellRepresentable.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - DefaultAlert
extension AboutVC: DefaultAlert { }

//MARK: - AutoDismissAlert
extension AboutVC: AutoDismissAlert { }
