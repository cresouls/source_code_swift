//
//  DynamicTypes.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 04/06/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation
import UIKit

class Dynamic<T> {
    
    var bind: (T) -> () = { _ in }
    
    var value: T?
//    {
//        didSet {
//            bind(value!)
//        }
//    }
    
    init(_ v: T) {
        value = v
    }
    
    init(_ v: T?) {
        value = v
    }
    
    func setValue(_ v: T?) {
        value = v
        
        //if value null wont call bind
        if let _value = value {
            bind(_value)
        }
    }
}

protocol Bindable {
    associatedtype T
    var bindClosure: ((T) -> ()) { set get }
    func bind(callback :@escaping (T) -> ())
    func removeBind()
}

//MARK: - UITextField
protocol TextFieldBindable: Bindable {
    //textfield.text wont call .editingChanged
    func setText(_ string: String)
}

extension UITextField: TextFieldBindable {
    private static var binderCollection = [String: (String) -> ()]()
    
    typealias T = String
    
    var bindClosure: ((String) -> ()) {
        get {
            let key = String(UInt(bitPattern: ObjectIdentifier(self)))
            if let binder = UITextField.binderCollection[key] {
                return binder
            }
            return { _ in }
        }
        set {
            let key = String(UInt(bitPattern: ObjectIdentifier(self)))
            
            UITextField.binderCollection[key] = newValue
        }
    }
    
    func bind(callback :@escaping (String) -> ()) {
        bindClosure = callback
        
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func removeBind() {
        let key = String(UInt(bitPattern: ObjectIdentifier(self)))
        UITextField.binderCollection.removeValue(forKey: key)
    }
    
    func setText(_ string: String) {
        text = ""
        insertText(string)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        bindClosure(textField.text!)
    }
}


//MARK: - UIButton
protocol ButtonBindable: Bindable {
}

extension UIButton: ButtonBindable {
    private static var binderCollection = [String: (Bool) -> ()]()
    
    typealias T = Bool
    
    var bindClosure: ((Bool) -> ()) {
        get {
            let key = String(UInt(bitPattern: ObjectIdentifier(self)))
            if let binder = UIButton.binderCollection[key] {
                return binder
            }
            return { _ in }
        }
        set {
            let key = String(UInt(bitPattern: ObjectIdentifier(self)))
            
            UIButton.binderCollection[key] = newValue
        }
    }
    
    func bind(callback :@escaping (Bool) -> ()) {
        bindClosure = callback
        
        addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    func removeBind() {
        let key = String(UInt(bitPattern: ObjectIdentifier(self)))
        UIButton.binderCollection.removeValue(forKey: key)
    }

    @objc func buttonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        bindClosure(sender.isSelected)
    }
}

//Mark: - Switch
protocol SwitchBindable: Bindable {
}

extension UISwitch: SwitchBindable {
    private static var binderCollection = [String: (Bool) -> ()]()
    
    typealias T = Bool
    
    var bindClosure: ((Bool) -> ()) {
        get {
            let key = String(UInt(bitPattern: ObjectIdentifier(self)))
            if let binder = UISwitch.binderCollection[key] {
                return binder
            }
            return { _ in }
        }
        set {
            let key = String(UInt(bitPattern: ObjectIdentifier(self)))
            
            UISwitch.binderCollection[key] = newValue
        }
    }
    
    func bind(callback :@escaping (Bool) -> ()) {
        bindClosure = callback
        
        addTarget(self, action: #selector(switchAction(_:)), for: .valueChanged)
    }
    
    func removeBind() {
        let key = String(UInt(bitPattern: ObjectIdentifier(self)))
        UISwitch.binderCollection.removeValue(forKey: key)
    }
    
    @objc func switchAction(_ sender: UISwitch) {
        bindClosure(sender.isOn)
    }
}


//MARK: - UITextView
protocol TextViewBindable: Bindable {
}

extension UITextView: TextViewBindable {
    private static var binderCollection = [String: (String) -> ()]()
    
    typealias T = String
    
    var bindClosure: ((String) -> ()) {
        get {
            let key = String(UInt(bitPattern: ObjectIdentifier(self)))
            if let binder = UITextView.binderCollection[key] {
                return binder
            }
            return { _ in }
        }
        set {
            let key = String(UInt(bitPattern: ObjectIdentifier(self)))
            
            UITextView.binderCollection[key] = newValue
        }
    }
    
    func bind(callback :@escaping (String) -> ()) {
        bindClosure = callback
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }
    
    func removeBind() {
        let key = String(UInt(bitPattern: ObjectIdentifier(self)))
        UITextView.binderCollection.removeValue(forKey: key)
    }

    @objc func textDidChange() {
        bindClosure(self.text!)
    }
}
