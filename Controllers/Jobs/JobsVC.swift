//
//  JobsVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 08/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class JobsVC: UIViewController, NibLoadable {

    //MARK: - IBOutlets
    @IBOutlet weak var horizontalButtonstack: HorizontalButtonStack! {
        didSet {
            horizontalButtonstack.baseColor = Theme.c1
            horizontalButtonstack.buttonTextColor = Theme.c5
            horizontalButtonstack.font = Font.h3
            
            horizontalButtonstack._dataSource = self
            horizontalButtonstack._delegate = self
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.tableFooterView = UIView()
            
            tableView.register(UINib(nibName: JobCell.identifier, bundle: nil), forCellReuseIdentifier: JobCell.identifier)
        }
    }
    
    //MARK: - Properties
    var vm: JobsVM?
    private lazy var hud = Hud(color: Theme.c7)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("Jobs")
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
            case .jobSelected(let title):
                self.navigationItem.title = title
                self.tableView.reloadData()
            case .tableUpdate:
                self.tableView.reloadData()
            }
        }
        
        //to set initial index and call action
        horizontalButtonstack.defaultIndex = 0
        
    }
}

//MARK: - HorizontalButtonStackDataSource
extension JobsVC: HorizontalButtonStackDataSource {
    func numberOfButtons() -> Int {
        return vm?.jobTypes.count ?? 0
    }
    
    func buttonForIndex(_ index: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(vm!.jobTypes[index].title, for: .normal)
        return button
    }
}

//MARK: - HorizontalButtonStackDelegate
extension JobsVC: HorizontalButtonStackDelegate {
    func didTapButton(_ index: Int) {
        vm?.didTap(index)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension JobsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = vm?.data.count ?? 0
        if rowCount == 0 {
            let emptyTuple = vm?.emptyMessageForList()
            tableView.setEmptyMessage(emptyTuple?.0 ?? "", message: emptyTuple?.1 ?? "")
        } else {
            tableView.restore()
        }
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
        let didSelectVM = vm?.didSelect(indexPath)
        if let _vm =  didSelectVM as? QDetailVM {
            goToQDetail(vm: _vm)
        } else  if let _vm = didSelectVM as? JDetailVM {
            goToJDetail(vm: _vm)
        }
    }
}

//MARK: - DefaultAlert
extension JobsVC: DefaultAlert { }

//MARK: - AutoDismissAlert
extension JobsVC: AutoDismissAlert { }

//MARK: - QDetailRouter
extension JobsVC: QDetailRouter { }

//MARK: - JDetailRouter
extension JobsVC: JDetailRouter { }
