//
//  JDetailVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 25/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation
import MapKit

//MARK: - State
struct JDetailState {
    enum Action {
        case none
        case onCall
        case onSuccess(Api)
        case onFailed(String)
        case other(String)
    }
    
    enum Api {
        case orderDetails
        case startWork
        case pauseWork
        case resumeWork
        case stopWork
        case updateStatus
        case uploadBeforeImage
        case uploadAfterImage
        case inspection
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}


//MARK: - Class
class JDetailVM {
    
    enum JobsType{
        case notStarted
        case beforeUploaded
        case started
        case paused
        case stopped
        case afterImageUploaded
        case inspection
        case completed
    }
    
    var status: Dynamic<OrderStatus> = Dynamic(.opened)
    var isBeforeImageUploaded: Dynamic<Bool> = Dynamic(false)
    var isAfterImageUploaded: Dynamic<Bool> = Dynamic(false)
    let reqId: String
    let customerName: String
    let serviceName: String
    let reqTime: String
    let paymentMode: String
    let address: String
    let latitude: CLLocationDegrees?
    let longitude: CLLocationDegrees?
    let issue: String
    let customerCallNo: String
    
    private(set) var state = JDetailState() {
        didSet {
            callback?(state)
        }
    }
    
    private var job: Job
    
    var callback: ((JDetailState) -> ())?
    
    init(_ job: Job) {
        self.job = job
        
        isBeforeImageUploaded.value = job.isBeforeImageAdded
        isAfterImageUploaded.value = job.isAfterImageAdded
        reqId = "ORDER REQID: \(job.regNo)"
        customerName = "Customer Name: \(job.by.name)"
        serviceName = "Service: \(job.serviceName)"
        reqTime = "Requested Time: \(job.reqTime)"
        paymentMode = "Payment Mode: \(job.paymentMode)"
        address = job.address
        latitude = job.latitude
        longitude = job.longitude
        issue = "ISSUE RAISED: \(job.issue)"
        customerCallNo = job.by.callNo
    }
    
    deinit {
        print("JDetail VM deinited")
    }
}

//MARK: - Functions
extension JDetailVM {
    func uploadImage(_ image: UIImage) {
        if !isBeforeImageUploaded.value! && status.value! != .stopped && status.value! != .completed {
            self.uploadBeforeImage(image)
        } else if !isAfterImageUploaded.value! && status.value! == .stopped {
            self.uploadAfterImage(image)
        }
    }
    
    func sendToInspect() {
        changeStatusOnInspection()
    }
}

//MARK: - API Functions
extension JDetailVM {
    func getOrderDetails() {
        state.action = .onCall
        let param = ["order": job.reqId]
        print(param)
        HTTPManager.instance.getOrderDetails(param: param) { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.job.updateWorkingPlayStatus(data)
                self.status.setValue(self.job.orderStatus)
                self.state.action = .onSuccess(.orderDetails)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    private func uploadBeforeImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            state.action = .other("Couldn't upload before image.")
            return
        }
        state.action = .onCall
        let param = ["order": job.reqId]
        HTTPManager.instance.uploadBeforeImage(imageData: imageData, param: param) { [unowned self] (result) in
            switch result {
            case .success(_):
                self.job.isBeforeImageAdded = true
                self.isBeforeImageUploaded.setValue(true)
                self.state.action = .onSuccess(.uploadBeforeImage)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    private func uploadAfterImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            state.action = .other("Couldn't upload before image.")
            return
        }
        state.action = .onCall
        let param = ["order": job.reqId]
        HTTPManager.instance.uploadAfterImage(imageData: imageData, param: param) { [unowned self] (result) in
            switch result {
            case .success(_):
                self.job.isAfterImageAdded = true
                self.isAfterImageUploaded.setValue(true)
                self.state.action = .onSuccess(.uploadAfterImage)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    func startWork() {
        state.action = .onCall
        let param = ["order": job.reqId, "status": "0"]
        print("start work \(param)")
        HTTPManager.instance.startWork(param: param) { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.job.workTimeId = data
                self.changeStatusOnStarted()
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    func stopWork(_ amount: String) {
        guard let _workTimeId = job.workTimeId else {
            state.action = .other("Word time id is missing.")
            return
        }
        state.action = .onCall
        let param = ["order": job.reqId, "status": "1", "work_time_id": _workTimeId]
        print("stop work \(param)")
        HTTPManager.instance.stopWork(param: param) { [unowned self] (result) in
            switch result {
            case .success(_):
                self.changeStatusOnStopped(amount)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    func pauseWork() {
        guard let _workTimeId = job.workTimeId else {
            state.action = .other("Word time id is missing.")
            return
        }
        state.action = .onCall
        let param = ["order": job.reqId, "status": "2", "work_time_id": _workTimeId]
        print("pause work \(param)")
        HTTPManager.instance.stopWork(param: param) { [unowned self] (result) in
            switch result {
            case .success(_):
                self.job.orderStatus = .paused
                self.status.setValue(.paused)
                
                NotificationCenter.default.post(name: Notification.Name.jobsUpdated,
                                                object: self,
                                                userInfo: nil)
                
                self.state.action = .onSuccess(.pauseWork)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    func resumeWork() {
        state.action = .onCall
        let param = ["order": job.reqId, "status": "3"]
        print("resume work \(param)")
        HTTPManager.instance.startWork(param: param) { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.job.workTimeId = data
                self.job.orderStatus = .started
                self.status.setValue(.started)
                
                NotificationCenter.default.post(name: Notification.Name.jobsUpdated,
                                                object: self,
                                                userInfo: nil)
                
                self.state.action = .onSuccess(.resumeWork)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    private func changeStatusOnStarted() {
        let param = ["order": job.reqId, "order_status": "1", "reason_id": "0", "material_charge": "0"]
        print("changeStatusOnStarted \(param)")
        HTTPManager.instance.changeStatus(param: param) { [unowned self] (result) in
            switch result {
            case .success(_):
                self.job.orderStatus = .started
                self.status.setValue(.started)
                
                NotificationCenter.default.post(name: Notification.Name.jobsUpdated,
                                                object: self,
                                                userInfo: nil)
                
                self.state.action = .onSuccess(.startWork)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    private func changeStatusOnStopped(_ amount: String) {
        let param = ["order": job.reqId, "order_status": "1", "reason_id": "0", "material_charge": amount]
        print("changeStatusOnStopped \(param)")
        HTTPManager.instance.changeStatus(param: param) { [unowned self] (result) in
            switch result {
            case .success(_):
                self.job.orderStatus = .stopped
                self.status.setValue(.stopped)
                
                NotificationCenter.default.post(name: Notification.Name.jobsUpdated,
                                                object: self,
                                                userInfo: nil)
                
                self.state.action = .onSuccess(.stopWork)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
    
    private func changeStatusOnInspection() {
        state.action = .onCall
        let param = ["order": job.reqId, "order_status": "11", "reason_id": "0", "material_charge": "0"]
        HTTPManager.instance.changeStatus(param: param) { [unowned self] (result) in
            switch result {
            case .success(_):
                self.job.orderStatus = .completed
                self.status.setValue(.completed)
                
                NotificationCenter.default.post(name: Notification.Name.jobsUpdated,
                                                object: self,
                                                userInfo: nil)
                
                self.state.action = .onSuccess(.stopWork)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
}
