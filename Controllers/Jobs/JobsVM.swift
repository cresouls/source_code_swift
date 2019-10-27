//
//  JobsVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 20/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

//MARK: - State
struct JobsState {
    enum Action {
        case none
        case onCall
        case onSuccess(Api)
        case onFailed(String)
        case other(String)
        case jobSelected(String)
        case tableUpdate
    }
    
    enum Api {
        case quotationOrders
        case openOrders
        case inProgressOrders
        case completedOrders
        case allOrders
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

//MARK: - Class
class JobsVM {
    enum JobsType{
        case quotation
        case open
        case inProgress
        case completed
        case all
        
        var title: String {
            switch self {
            case .quotation:
                return "QUOTATIONS"
            case .open:
                return "UPCOMING"
            case .inProgress:
                return "IN PROGRESS"
            case .completed:
                return "COMPLETED"
            case .all:
                return "ALL"
            }
        }
        
        var navTitle: String {
            switch self {
            case .quotation:
                return "Quotations"
            case .open:
                return "Upcoming"
            case .inProgress:
                return "In Progress"
            case .completed:
                return "Completed"
            case .all:
                return "All"
            }
        }
    }
    
    var jobTypes: [JobsType] = [.quotation, .open, .inProgress, .completed, .all]
    var currentJobType: JobsType? {
        didSet {
            getJobListForCurrentJobType()
        }
    }
    
    var data: [CellRepresentable] = []
    private var dataObjects: Any?
    
    
    private(set) var state = JobsState() {
        didSet {
            callback?(state)
        }
    }
    
    var callback: ((JobsState) -> ())?
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(jobsUpdated),
                                               name: Notification.Name.jobsUpdated,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.jobsUpdated,
                                                  object: nil)
        print("Jobs VM deinited")
    }
}

//MARK: - Functions
extension JobsVM {
    private func getJobListForCurrentJobType() {
        guard let _currentJobType = currentJobType else {
            fatalError("Couldn't find a job type")
        }
        data.removeAll()
        state.action = .jobSelected(_currentJobType.navTitle)
        
        switch _currentJobType {
        case .quotation:
            getQuotationOrders()
        case .open:
            getOpenOrders()
        case .inProgress:
            getInProgressOrders()
        case .completed:
            getCompletedOrders()
        case .all:
            getAllOrders()
        }
    }
    
    @objc private func jobsUpdated() {
        guard let _currentJobType = currentJobType,
            var _dataObjects = dataObjects as? [Job] else {
                return
        }
        
        switch _currentJobType {
        case .quotation, .completed, .all:
            print("Not applicable")
        case .open:
            _dataObjects = _dataObjects.filter { $0.orderStatus == .opened }
        case .inProgress:
            guard var _dataObjects = dataObjects as? [Job] else {
                return
            }
            _dataObjects = _dataObjects.filter { $0.orderStatus == .started || $0.orderStatus == .paused || $0.orderStatus == .stopped }
        }
        dataObjects = _dataObjects
        data = _dataObjects.map { JobCellVM($0.regNo, customerName: $0.by.name, serviceName: $0.serviceName, reqDate: $0.reqDateInFormat)}
        state.action = .tableUpdate
        
    }
}

//MARK: - API Functions
extension JobsVM {
    private func getQuotationOrders() {
        state.action = .onCall
        let param = ["provider": LocalUser.instance.id!]
        HTTPManager.instance.getQuotationOrders(param: param) { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.dataObjects = data
                self.data = data.map { JobCellVM(nil, customerName: nil, serviceName: $0.serviceName, reqDate: $0.reqDateInFormat)}
                self.state.action = .onSuccess(.quotationOrders)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    private func getOpenOrders() {
        state.action = .onCall
        let param = ["provider": LocalUser.instance.id!]
        HTTPManager.instance.getOpenOrders(param: param) { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.dataObjects = data
                self.data = data.map { JobCellVM($0.regNo, customerName: $0.by.name, serviceName: $0.serviceName, reqDate: $0.reqDateInFormat)}
                self.state.action = .onSuccess(.openOrders)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    
    private func getInProgressOrders() {
        state.action = .onCall
        let param = ["provider": LocalUser.instance.id!]
        HTTPManager.instance.getInProgressOrders(param: param) { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.dataObjects = data
                self.data = data.map { JobCellVM($0.regNo, customerName: $0.by.name, serviceName: $0.serviceName, reqDate: $0.reqDateInFormat)}
                self.state.action = .onSuccess(.inProgressOrders)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    private func getCompletedOrders() {
        state.action = .onCall
        let param = ["provider": LocalUser.instance.id!]
        HTTPManager.instance.getCompletedOrders(param: param) { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.dataObjects = data
                self.data = data.map { JobCellVM($0.regNo, customerName: $0.by.name, serviceName: $0.serviceName, reqDate: $0.reqDateInFormat)}
                self.state.action = .onSuccess(.completedOrders)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    private func getAllOrders() {
        state.action = .onCall
        let param = ["provider": LocalUser.instance.id!]
        HTTPManager.instance.getAllOrders(param: param) { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.dataObjects = data
                self.data = data.map { JobCellVM($0.regNo, customerName: $0.by.name, serviceName: $0.serviceName, reqDate: $0.reqDateInFormat)}
                self.state.action = .onSuccess(.allOrders)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
}

//MARK: - TableView Functions
extension JobsVM {
    func didSelect(_ indexPath: IndexPath) -> Any? {
        guard let _dataObjects = dataObjects else {
            return nil
        }
        if let quotations = _dataObjects as? [Quotation] {
            let quotation = quotations[indexPath.row]
            return QDetailVM(quotation)
        } else if let jobs = _dataObjects as? [Job] {
            let job = jobs[indexPath.row]
            return JDetailVM(job)
        }
        return nil
    }
    
    func emptyMessageForList() -> (String?, String?) {
        guard let _currentJobType = currentJobType else {
            return (nil, nil)
        }
        
        switch _currentJobType {
        case .quotation:
            return ("Quotation list is empty!", nil)
        case .open:
            return ("No Assigned Jobs Found!", "You will be notified for the upcoming or assigned jobs")
        case .inProgress:
            return ("No In Progress Jobs Found!", "You have commited 0 jobs")
        case .completed:
            return ("No Completed Jobs Found!", nil)
        case .all:
            return ("No Jobs Found!", nil)
        }
    }
}

//MARK: - HorizontalButton Functions
extension JobsVM {
    func didTap(_ index: Int) {
        let jobType = jobTypes[index]
        if currentJobType != jobType {
            currentJobType = jobType
        }
    }
}
