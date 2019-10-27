//
//  SelectCityVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 17/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

//MARK: - Protocol
protocol SelectCityVMDelegate: class {
    func selectedCity(_ city: City)
}

//MARK: - Factory Protocol
protocol SelectCityVMFactory: VMFactory {
    var _selectedCity: City? { get }
    var _selectCityVMDelegate: SelectCityVMDelegate? { get }
    func createSelectCityVM(_ selectedCity: City?, delegate: SelectCityVMDelegate?) -> SelectCityVM
    func getSelectCityVM() -> SelectCityVM
}

extension SelectCityVMFactory {
    func createSelectCityVM(_ selectedCity: City?, delegate: SelectCityVMDelegate?) -> SelectCityVM {
        return SelectCityVM(selectedCity, delegate: delegate)
    }
    
    func getSelectCityVM() -> SelectCityVM {
        return createSelectCityVM(_selectedCity, delegate: _selectCityVMDelegate)
    }
    
}

//MARK: - State
struct SelectCityState {
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
        case getCities
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

//MARK: - Class
class SelectCityVM {
    private var cities: [City]? {
        didSet {
            updateCellRepresentable()
        }
    }
    private var selectedCity: City?
    private weak var delegate: SelectCityVMDelegate?
    var data: [CellRepresentable] = []
    
    private(set) var state = SelectCityState() {
        didSet {
            callback?(state)
        }
    }
    
    var callback: ((SelectCityState) -> ())?
    
    init(_ selectedCity: City?, delegate: SelectCityVMDelegate?) {
        self.selectedCity = selectedCity
        self.delegate = delegate
    }
    
    deinit {
        print("SelectCity VM deinited")
    }
}

//MARK: - Functions
extension SelectCityVM {
    private func updateCellRepresentable() {
        guard let _cities = cities else {
            return
        }
        var selectedCityId = "-1"
        if let _selectedCity = self.selectedCity {
            selectedCityId = _selectedCity.id
        }
        self.data = _cities.map { SimpleCellVM($0.name, isSelected: $0.id == selectedCityId) }
        self.state.action = .tableUpdate

    }
}

//MARK: - API Functions
extension SelectCityVM {
    func getData() {
        state.action = .onCall
        let param = ["country": "7"]
        HTTPManager.instance.getCities(param: param) { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.cities = data
                self.state.action = .onSuccess(.getCities)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
}

//MARK: - TableView Functions
extension SelectCityVM {
    func didSelect(_ indexPath: IndexPath) {
        guard let _cities = cities else {
            return
        }
        let city = _cities[indexPath.row]
        self.delegate?.selectedCity(city)
        self.state.action = .selectedCity
    }
}
