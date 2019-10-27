//
//  AboutVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 20/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

//MARK: - State
struct AboutState {
    enum Action {
        case none
        case onCall
        case onSuccess
        case onFailed(String)
        case other(String)
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

//MARK: - Class
class AboutVM {
    var data: [CellRepresentable] = []

    private(set) var state = AboutState() {
        didSet {
            callback?(state)
        }
    }
    
    var callback: ((AboutState) -> ())?
    
    init() {
    }
    
    deinit {
        print("About VM deinited")
    }
}

//MARK: - Functions
extension AboutVM {
    func getData() {
        getAboutUs()
    }
}

//MARK: - API Functions
extension AboutVM {
    private func getAboutUs() {
        state.action = .onCall
        let param = ["id": "4"]
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
