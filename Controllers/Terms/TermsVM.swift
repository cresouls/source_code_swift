//
//  TermsVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 20/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

//MARK: - State
struct TermsState {
    enum Action {
        case none
        case onCall
        case onSuccess
        case onFailed(String)
        case other(String)
        case pageSelected(String)
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

//MARK: - Class
class TermsVM {
    enum PageType{
        case terms
        case privacy
        case cancellation
        
        var title: String {
            switch self {
            case .terms:
                return "TERMS & CONDITIONS"
            case .privacy:
                return "PRIVACY POLICY"
            case .cancellation:
                return "CANCELLATION POLICY"
            }
        }
        
        var navTitle: String {
            switch self {
            case .terms:
                return "Terms & Conditions"
            case .privacy:
                return "Privacy Policy"
            case .cancellation:
                return "Cancellation Policy"
            }
        }
        
        var id: String {
            switch self {
            case .terms:
                return "1"
            case .privacy:
                return "2"
            case .cancellation:
                return "3"
            }
        }
    }
    
    var pageTypes: [PageType] = [.terms, .privacy, .cancellation]
    var currentPageType: PageType? {
        didSet {
            getPageForCurrentPageType()
        }
    }
    
    var data: [CellRepresentable] = []

    private(set) var state = TermsState() {
        didSet {
            callback?(state)
        }
    }
    
    var callback: ((TermsState) -> ())?
    
    init() {
    }
    
    deinit {
        print("Terms VM deinited")
    }
}

//MARK: - Functions
extension TermsVM {
    private func getPageForCurrentPageType() {
        guard let _currentPageType = currentPageType else {
            fatalError("Couldn't find a page")
        }
        data.removeAll()
        state.action = .pageSelected(_currentPageType.navTitle)
        
        getPage(_currentPageType.id)
    }
}

//MARK: - API Functions
extension TermsVM {
    private func getPage(_ id: String) {
        state.action = .onCall
        let param = ["id": id]
        HTTPManager.instance.getPage(param: param) { [unowned self] (result) in
            switch result {
            case .success(let data):
                let _data = data.htmlToString
                self.data = [TermsCellVM(_data)]
                self.state.action = .onSuccess
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
}

//MARK: - HorizontalButton Functions
extension TermsVM {
    func didTap(_ index: Int) {
        let pageType = pageTypes[index]
        if currentPageType != pageType {
            currentPageType = pageType
        }
    }
}
