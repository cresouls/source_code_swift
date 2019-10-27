//
//  PaymentVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 17/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

//MARK: - State
struct PaymentState {
    enum Action {
        case none
        case onCall
        case onSuccess(Api)
        case onFailed(String)
        case other(String)
        case tableUpdate
        case selectedCity
    }
    
    enum Api {
        case getPaymentList
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

//MARK: - Class
class PaymentVM {
    var data: [CellRepresentable] = []
    
    private(set) var state = PaymentState() {
        didSet {
            callback?(state)
        }
    }
    
    var callback: ((PaymentState) -> ())?
    
    init() {
    }
    
    deinit {
        print("Payment VM deinited")
    }
}

//MARK: - Functions
extension PaymentVM {
}

//MARK: - API Functions
extension PaymentVM {
    func getData() {
        state.action = .onCall
        let param = ["provider": LocalUser.instance.id!]
        HTTPManager.instance.getPaymentList(param: param) { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.data = data.map {
                    PayCellVM($0.regNo, amount: $0.amount, status: $0.paymentStatus, date: $0.dateInFormat.0, monthYear: $0.dateInFormat.1)
                }
                self.state.action = .onSuccess(.getPaymentList)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
}
