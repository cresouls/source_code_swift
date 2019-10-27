//
//  PaymentVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 17/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class PaymentVC: UIViewController, NibLoadable {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.separatorStyle = .none
            tableView.backgroundColor = Theme.c3
            
            tableView.register(UINib(nibName: PayCell.identifier, bundle: nil), forCellReuseIdentifier: PayCell.identifier)
        }
    }
    
    //MARK: - Properties
    var vm: PaymentVM?
    private lazy var hud = Hud(color: Theme.c7)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("Payment")
        addMenuPopDismissButton()
        
        vm?.callback = { [unowned self] (state) in
            switch state.action {
            case .none:
                print("none")
            case .onCall:
                self.hud.start()
            case .onSuccess(_):
                self.hud.stop()
                self.tableView.reloadData()
            case .onFailed(let message):
                self.hud.stop()
                self.showAlert("Error", message: message)
            case .other(let message):
                self.hud.stop()
                self.showAutoDismissAlert(nil, message: message)
            case .tableUpdate:
                self.tableView.reloadData()
            case .selectedCity:
                DispatchQueue.main.async {
                    self.popDismiss()
                }
            }
        }
        
        vm?.getData()
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension PaymentVC: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Theme.c3
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Theme.c3
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
}

//MARK: - DefaultAlert
extension PaymentVC: DefaultAlert { }

//MARK: - AutoDismissAlert
extension PaymentVC: AutoDismissAlert { }
