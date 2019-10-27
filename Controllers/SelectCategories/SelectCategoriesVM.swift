//
//  SelectCategoriesVM.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 17/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

//MARK: - Protocol
protocol SelectCategoriesVMDelegate: class {
    func selectedCategories(_ categories: [Category])
}

//MARK: - Factory Protocol
protocol SelectCategoriesVMFactory: VMFactory {
    var _cityId: String? { get }
    var _selectedCategories: [Category] { get }
    var _selectCategoriesVMDelegate: SelectCategoriesVMDelegate? { get }
    func createSelectCategoriesVM(_ selectedCategories: [Category], cityId: String, delegate: SelectCategoriesVMDelegate?) -> SelectCategoriesVM
    func getSelectCategoriesVM(_ errorBlock: (String) -> ()) -> SelectCategoriesVM?
}

extension SelectCategoriesVMFactory {
    func createSelectCategoriesVM(_ selectedCategories: [Category], cityId: String, delegate: SelectCategoriesVMDelegate?) -> SelectCategoriesVM {
        return SelectCategoriesVM(selectedCategories, cityId: cityId, delegate: delegate)
    }
    
    func getSelectCategoriesVM(_ errorBlock: (String) -> ()) -> SelectCategoriesVM? {
        guard let cityId = _cityId else {
            errorBlock("Please select a city first")
            return nil
        }
        return createSelectCategoriesVM(_selectedCategories, cityId: cityId, delegate: _selectCategoriesVMDelegate)
    }
    
}

//MARK: - State
struct SelectCategoriesState {
    enum Action {
        case none
        case onCall
        case onSuccess(Api)
        case onFailed(String)
        case other(String)
        case tableUpdate
        case selectedCategories
    }
    
    enum Api {
        case getCategories
    }
    
    var action: Action
    
    init() {
        self.action = .none
    }
}

//MARK: - Class
class SelectCategoriesVM {
    private var categories: [Category]? {
        didSet {
            updateCellRepresentable()
        }
    }
    private var selectedCategories: [Category]
    private var cityId: String
    private weak var delegate: SelectCategoriesVMDelegate?
    var data: [CellRepresentable] = []
    
    private(set) var state = SelectCategoriesState() {
        didSet {
            callback?(state)
        }
    }
    
    var callback: ((SelectCategoriesState) -> ())?
    
    init(_ selectedCategories: [Category], cityId: String, delegate: SelectCategoriesVMDelegate?) {
        self.selectedCategories = selectedCategories
        self.cityId = cityId
        self.delegate = delegate
    }
    
    deinit {
        print("SelectCategories VM deinited")
    }
}

//MARK: - Functions
extension SelectCategoriesVM {
    private func updateCellRepresentable() {
        guard let _categories = categories else {
            return
        }
        let selectedCategoriesId = selectedCategories.map { $0.id }
        self.data = _categories.map { SimpleCellVM($0.name, isSelected: selectedCategoriesId.contains($0.id)) }
        self.state.action = .tableUpdate
    }
    
    func doneSelection() {
        delegate?.selectedCategories(selectedCategories)
        self.state.action = .selectedCategories
    }
}

//MARK: - API Functions
extension SelectCategoriesVM {
    func getData() {
        state.action = .onCall
        let param = ["city_id": cityId]
        HTTPManager.instance.getCategories(param: param) { [unowned self] (result) in
            switch result {
            case .success(let data):
                self.categories = data
                self.state.action = .onSuccess(.getCategories)
            case .failure(let error):
                self.state.action = .onFailed(error.description)
            }
        }
    }
}

//MARK: - TableView Functions
extension SelectCategoriesVM {
    func didSelect(_ indexPath: IndexPath) {
        guard let _categories = categories else {
            return
        }
        let category = _categories[indexPath.row]
        let selectedCategoriesId = selectedCategories.map { $0.id }
        if selectedCategoriesId.contains(category.id) {
            let index = selectedCategoriesId.firstIndex(of: category.id)
            if let _index = index {
                selectedCategories.remove(at: _index)
            }
        } else {
            selectedCategories.append(category)
        }
        updateCellRepresentable()
        //self.state.action = .tableUpdate
    }
}
