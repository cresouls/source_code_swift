//
//  QDetailVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 23/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class QDetailVC: UIViewController, NibLoadable {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.separatorStyle = .none
            tableView.backgroundColor = Theme.c3
            
            tableView.register(UINib(nibName: QSummaryCell.identifier, bundle: nil), forCellReuseIdentifier: QSummaryCell.identifier)
            tableView.register(UINib(nibName: QuoteCell.identifier, bundle: nil), forCellReuseIdentifier: QuoteCell.identifier)
            tableView.register(UINib(nibName: EnterAmountCell.identifier, bundle: nil), forCellReuseIdentifier: EnterAmountCell.identifier)
        }
    }
    
    //MARK: - Properties
    var vm: QDetailVM?
    private lazy var hud = Hud(color: Theme.c7)
    var currentResponsder: UIView?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
            case .updateUI(let title):
                self.navigationItem.title = title
                self.tableView.reloadData()
            }
        }
        
        vm?.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardNotifications(shouldRegister: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardNotifications(shouldRegister: false)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension QDetailVC: UITableViewDataSource, UITableViewDelegate {
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
        //vm?.didSelect(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewRepresentable = vm!.data[section].headerViewRepresentable
        return viewRepresentable?.viewInstance()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let viewRepresentable = vm!.data[section].headerViewRepresentable
        return viewRepresentable?.viewHeight ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let viewRepresentable = vm!.data[section].headerViewRepresentable
        return viewRepresentable?.viewHeight ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewRepresentable = vm!.data[section].footerViewRepresentable
        return viewRepresentable?.viewInstance()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let viewRepresentable = vm!.data[section].footerViewRepresentable
        return viewRepresentable?.viewHeight ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        let viewRepresentable = vm!.data[section].footerViewRepresentable
        return viewRepresentable?.viewHeight ?? 0.0
    }
}

//MARK: - KeyboardObserver
extension QDetailVC: KeyboardObserver {
    var container: UIView {
        return self.tableView
    }
    
    var firstResponder: UIView? {
        //hack to get EnterAmountCell quick
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2))
        return cell
    }
}

//MARK: - DefaultAlert
extension QDetailVC: DefaultAlert { }

//MARK: - AutoDismissAlert
extension QDetailVC: AutoDismissAlert { }
