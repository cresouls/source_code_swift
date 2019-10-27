//
//  FormValidatable.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 04/06/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

enum ValidationError {
    case emptyFields(String)
    case invalidEmail
    case passwordNotMatch
    case notAgreedTerms
    
    var description: String {
        switch self {
        case .emptyFields(let desc):
            return desc
        case .invalidEmail:
            return "Email is Invalid"
        case .passwordNotMatch:
            return "Password and Confirm Password does not match"
        case .notAgreedTerms:
            return "You should agree to our terms and conditions"
        }
    }
}

protocol FormValidatable {
    func isValid() -> (Bool, ValidationError?)
}

