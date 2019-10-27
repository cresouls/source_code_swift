//
//  SelectCategoriesVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 17/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class SelectCategoriesVC: UIViewController, NibLoadable {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.tableFooterView = UIView()
            
            tableView.register(UINib(nibName: SimpleCell.identifier, bundle: nil), forCellReuseIdentifier: SimpleCell.identifier)
        }
    }
    
    //MARK: - Properties
    var vm: SelectCategoriesVM?
    private lazy var hud = Hud(color: Theme.c7)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("Select Categories")
        addMenuPopDismissButton()
        addRightBarButton()
        
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
            case .selectedCategories:
                DispatchQueue.main.async {
                    self.popDismiss()
                }
            }
        }
        
        vm?.getData()
    }
    
    func addRightBarButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func doneAction() {
        vm?.doneSelection()
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension SelectCategoriesVC: UITableViewDataSource, UITableViewDelegate {
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
        vm?.didSelect(indexPath)
    }
}

//MARK: - DefaultAlert
extension SelectCategoriesVC: DefaultAlert { }

//MARK: - AutoDismissAlert
extension SelectCategoriesVC: AutoDismissAlert { }
