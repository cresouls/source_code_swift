//
//  QDetailVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 23/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

//MARK: - State
struct QDetailState {
    enum Action {
        case none
        case onCall
        case onSuccess(Api, [IndexPath]?)
        case onFailed(String)
        case other(String)
        case updateUI(String)
    }
    
    enum Api {
        case addQuotation
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

struct QDetailRepresentable {
    var headerViewRepresentable: ViewRepresentable?
    var cellRepresentables: [CellRepresentable]
    var footerViewRepresentable: ViewRepresentable?
}

//MARK: - Class
class QDetailVM {
    var data: [QDetailRepresentable] = []
    private(set) var state = QDetailState() {
        didSet {
            callback?(state)
        }
    }
    private var quotation: Quotation
    
    var callback: ((QDetailState) -> ())?
    
    init(_ quotation: Quotation) {
        self.quotation = quotation
    }
    
    deinit {
        print("QDetail VM deinited")
    }
}

//MARK: - Functions
extension QDetailVM {
    func getData() {
        self.getQuotationDetail()
        state.action = .updateUI(quotation.regNo)
    }
    
    private func updateData() {
        getQuotationDetail()
    }
    
    private func getQuotationDetail() {
        data.removeAll()
        //first section
        let qSummaryCellVM = QSummaryCellVM(quotation.serviceName, reqDate: quotation.reqDateInFormat, reqTime: quotation.reqTime, requirements: quotation.jobDescription)
        let qDetailRepresentable1 = QDetailRepresentable(headerViewRepresentable: nil, cellRepresentables: [qSummaryCellVM], footerViewRepresentable: nil)
        data.append(qDetailRepresentable1)
        
        //second section
        let quoteCellVMs = quotation.quotes.map { QuoteCellVM($0.amount, createdDate: $0.createdOnInFormat) }
        let footerCellVM: ViewRepresentable? = (quotation.quotes.count > 0) ? nil : QFooterVM()
        
        let qDetailRepresentable2 = QDetailRepresentable(headerViewRepresentable: QHeaderVM(), cellRepresentables: quoteCellVMs, footerViewRepresentable: footerCellVM)
        data.append(qDetailRepresentable2)
        
        //third section
        let qDetailRepresentable3 = QDetailRepresentable(headerViewRepresentable: nil, cellRepresentables: [EnterAmountCellVM(self)], footerViewRepresentable: nil)
        data.append(qDetailRepresentable3)
    }
}

//MARK: - EnterAmountCellVMDelegate
extension QDetailVM: EnterAmountCellVMDelegate {
    //calls api
    func submitAmount(_ amount: String?, vm: EnterAmountCellVM) {
        guard let _amount = amount,
            !_amount.isEmpty else {
            state.action = .other("Please enter amount.")
                return
        }
        
        state.action = .onCall
        let param = ["provider": LocalUser.instance.id!, "order": quotation.reqId, "amount": _amount]
        print(param)
        HTTPManager.instance.addQuotation(param: param, completionHandler: { [unowned self] (result) in
            switch result {
            case .success(_):
                let dict = ["amount": _amount, "created_on": Date.currentDataInServerFormat()]
                let quote = Quote(dict)
                self.quotation.quotes.insert(quote, at: 0)
                self.updateData()
                self.state.action = .onSuccess(.addQuotation, nil)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        })
    }
}
