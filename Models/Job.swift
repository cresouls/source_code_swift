//
//  Job.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 22/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation
import CoreLocation

//status
//0 - not started ()
//1 - started
//3 - completed - waiting for admin (no image, upload image)
//8 - completed


//working status
//0 - running
//1 = stopped
//2 - paused
//3-  resume

enum OrderStatus: Int {
    case opened
    case started
    case paused
    case stopped
    case completed //admin approved
    case na
}

class Job {
    var regNo: String
    var reqId: String
    var address: String
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var serviceName: String
    var createdOn: String
    var updatedOn: String
    var reqDate: String
    var reqTime: String
    var by: User
    var orderStatus: OrderStatus
    var workTimeId: String?
    var isBeforeImageAdded = false
    var isAfterImageAdded = false
    var issue: String
    var paymentMode: String
    var scheduledDate: String?
    
    var reqDateInFormat: String {
        if let _scheduledDate = scheduledDate {
            return _scheduledDate.dateToLocalFormat("dd-MM-yyyy")
        }
        return reqDate.dateToLocalFormat("yyyy-MM-dd")
    }

    init(_ dict: [String: Any]) {
        guard let regNo = dict["order_reg_no"] as? String,
            let reqId = dict["order_req_id"] as? String,
            let address = dict["address"] as? String,
            let serviceName = dict["service_name"] as? String,
            let createdOn = dict["created_on"] as? String,
            let reqDate = dict["order_requested_date"] as? String,
            let reqTime = dict["order_requested_time"] as? String,
            let updatedOn = dict["updated_date"] as? String,
            let status = dict["order_status"] as? String,
            let beforeImage = dict["before_work_image"] as? String,
            let afterImage = dict["after_work_image"] as? String,
            let issue = dict["order_job_description"] as? String,
            let paymentMode = dict["ordr_payment_mode"] as? String,
            let rescheduleCount = dict["reschedule_count"] as? String else {
                fatalError("json wrong")
        }
        self.regNo = regNo
        self.reqId = reqId
        self.address = address
        self.serviceName = serviceName
        self.createdOn = createdOn
        self.updatedOn = updatedOn
        self.reqDate = reqDate
        self.reqTime = reqTime
        self.by = User(dict)
        self.issue = issue
        
        if !beforeImage.isEmpty {
            self.isBeforeImageAdded = true
        }
        if !afterImage.isEmpty {
            self.isAfterImageAdded = true
        }
        
        //manually adjusting
        let _orderStatus = Int(status)!
        if _orderStatus == 0 || _orderStatus == 4 || _orderStatus == 7 {
            //0-open 4-confirmed 7-reschudle
            self.orderStatus = .opened
        } else if _orderStatus == 1 {
            //1-progress
            self.orderStatus = .started
        } else if _orderStatus == 3 {
            //3-completed
            self.orderStatus = .stopped
        } else if _orderStatus == 8 {
            //8-confirmedcompleted
            self.orderStatus = .completed
        } else {
            //2-pending 5-assigned 6-cancel
            self.orderStatus = .na
        }

        if let _rescheduleCount = Int(rescheduleCount), _rescheduleCount > 0 {
            if let scheduledDate = dict["last_reschedule_date"] as? String {
                //date format different from server.
                //saved in another variable
                self.scheduledDate = scheduledDate
            }
            
            if let scheduledTime = dict["last_reschedule_time"] as? String {
                self.reqTime = scheduledTime
            }
        }
        
        if paymentMode == "1" {
            self.paymentMode = "Cash On Delivery"
        } else if paymentMode == "3" {
            self.paymentMode = "Online Payment"
        } else {
            self.paymentMode = ""
        }
        
        if let latitudeString = dict["order_latitude"] as? String,
            let latitude = CLLocationDegrees(latitudeString) {
            self.latitude = latitude
        }
        
        if let longitudeString = dict["order_longitude"] as? String,
            let longitude = CLLocationDegrees(longitudeString) {
            self.longitude = longitude
        }
    }
    
    func updateWorkingPlayStatus(_ dict: [String: Any]) {
        
        if let workTimeId = dict["wrk_time_id"] as? String {
            self.workTimeId = workTimeId
        }
        
        //might passing null from server
        if let workingPlayStatus = dict["working_play_status"] as? String {
            let _workingPlayStatus = Int(workingPlayStatus)!
            if _workingPlayStatus == 1 && orderStatus == .started {
                orderStatus = .started
            } else if _workingPlayStatus == 1 && orderStatus == .stopped {
                orderStatus = .stopped
            } else if  _workingPlayStatus == 2 && orderStatus == .started {
                orderStatus = .paused
            } else if _workingPlayStatus == 3 && orderStatus == .started {
                orderStatus = .started
            }
        }
//        else {
//            //if its null it should be opened
//            //just making sure
//            orderStatus = .opened
//        }
        
        //1 - Start && 1-progress
        //2 - Pause && 1-progress
        //3 - Resume && 1-progress
        //1 - Stop && 3-completed
    }
    
    func startWorking() {
        orderStatus = .started
    }
    
    func stopWorking() {
        orderStatus = .stopped
    }
    
    func pauseWorking() {
        orderStatus = .paused
    }
}

struct User {
    var id:  String
    var name:  String
    var mobile: String
    var email: String
    var countryCode: String
    
    var callNo: String {
        return countryCode + mobile
    }
    
    init(_ dict: [String: Any]) {
        guard let id = dict["order_user_id"] as? String,
            let name = dict["order_user_name"] as? String,
            let mobile = dict["order_user_mobile_no"] as? String,
            let email = dict["order_user_email"] as? String,
            let countryCode = dict["order_user_country_code"] as? String else {
                fatalError("json wrong")
        }
        self.id = id
        self.name = name
        self.mobile = mobile
        self.email = email
        self.countryCode = countryCode
    }
}


struct Quotation {
    var regNo: String
    var reqId: String
    var serviceName: String
    var jobDescription: String
    var reqDate: String
    var reqTime: String
    var quotes: [Quote]
    
    var reqDateInFormat: String {
        return reqDate.dateToLocalFormat("yyyy-MM-dd")
    }
    
    init(_ dict: [String: Any]) {
        guard let regNo = dict["order_reg_no"] as? String,
            let reqId = dict["order_req_id"] as? String,
            let serviceName = dict["category_name"] as? String,
            let jobDescription = dict["order_job_description"] as? String,
            let reqDate = dict["order_requested_date "] as? String,
            let reqTime = dict["order_requested_time"] as? String,
            let quotes = dict["quotations"] as? [[String: Any]] else {
                fatalError("json wrong")
        }
    
        self.regNo = regNo
        self.reqId = reqId
        self.serviceName = serviceName
        self.jobDescription = jobDescription
        self.reqDate = reqDate
        self.reqTime = reqTime
        self.quotes = quotes.map { Quote($0) }
    }
}


struct Quote {
    var amount: String
    var createdOn: String
    
    var createdOnInFormat: String {
        return createdOn.dateToLocalFormat("yyyy-MM-dd HH:mm:ss")
    }
    
    init(_ dict: [String: Any]) {
        guard let amount = dict["amount"] as? String,
            let createdOn = dict["created_on"] as? String else {
                fatalError("json wrong")
        }
        
        self.amount = amount
        self.createdOn = createdOn
    }
//
//    init(_ amount: String, createdOn: String) {
//        self.amount = amount
//        self.createdOn = createdOn
//    }
}


struct Settlement {
    var regNo: String
    var amount: String
    var date: String
    var paymentStatus: String
    
    var dateInFormat: (String, String) {
        return date.dateToLocalSplitFormat()
    }
    
    init(_ dict: [String: Any]) {
        guard let regNo = dict["order_reg_no"] as? String,
            let amount = dict["transaction_total_amount"] as? String,
            let date = dict["transaction_date"] as? String,
            let paymentStatus = dict["transaction_status"] as? String else {
                fatalError("json wrong")
        }
        
        self.regNo = regNo
        self.amount = amount
        self.date = date
        self.paymentStatus = paymentStatus == "0" ? "Not Paid" : "Paid"
    }
}
