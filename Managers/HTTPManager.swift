//
//  HTTPManager.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 14/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation
import Alamofire

enum API {
    case createKey
    case updateKey
}

enum APIResult<T> {
    case success(T)
    case failure(APIError)
}

enum APIError {
    case wrongResponse
    case networkError
    case serializationError
    case otherError(String)
    
    var description: String {
        switch self {
        case .wrongResponse:
            return "Response from server is wrong. Please contact admin."
        case .networkError:
            return "Connection lost. Please try again later."
        case .serializationError:
            return "Invalid serialization. Please contact admin"
        case let .otherError(message):
            return message
        }
    }
}

class HTTPManager {
    static let instance = HTTPManager()
    
    private let rootURL = "http://test.joboy.ae/provider/"
    
    func createKey(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46MTIzNA==", "session": Settings.defaultKey]
        Alamofire.request(URL(string: "\(rootURL)key/createkey")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? Int {
                    if status == 1 {
                        if let key = _data["key"] as? String {
                            Settings.sessionKey = key
                            completionHandler(APIResult.success("success"))
                            return
                        }
                    } else if status == 0 {
                        if let error = _data["error"] as? String {
                            completionHandler(APIResult.failure(.otherError(error)))
                            return
                        }
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func updateKey(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46MTIzNA=="]
        Alamofire.request(URL(string: "\(rootURL)key/provider")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? Int {
                    if status == 1 {
                        //force unwrapping session key as its already checking before api call
                        LocalUser.instance.setKey(Settings.sessionKey!)
                        completionHandler(APIResult.success("success"))
                        return
                    } else if status == 0 {
                        if let message = _data["message"] as? String {
                            completionHandler(APIResult.failure(.otherError(message)))
                            return
                        }
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func login(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        //login will be called only
        //if session key is available
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": Settings.sessionKey!]
        Alamofire.request(URL(string: "\(rootURL)provider/login")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        if let modelData = _data["data"] as? [String: Any] {
                            LocalUser.instance.updateIdFromJson(dict: modelData)
                            completionHandler(APIResult.success("success"))
                            return
                        }
                    } else if status == "fail" {
                        //no message from server
                        completionHandler(APIResult.failure(.otherError("Username or password you enetered is wrong.")))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func verifyMobile(param: [String: Any], completionHandler: @escaping (APIResult<Bool>) -> ()) {
        //verifyMobile will be called only
        //if session key is available
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": Settings.sessionKey!]
        Alamofire.request(URL(string: "\(rootURL)provider/verify_mobile")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        completionHandler(APIResult.success(false))
                        return
                    } else if status == "fail" {
                        completionHandler(APIResult.success(true))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func generateOTP(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        Alamofire.request(URL(string: "\(rootURL)provider/generate_otp")!, method: .post, parameters: param, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        if let responseData = _data["data"] as? [String: Any],
                            let otp = responseData["otp"] as? String {
                            
                            completionHandler(APIResult.success(otp))
                            return
                        }
                    } else if status == "fail" {
                        //no message from server
                        completionHandler(APIResult.failure(.otherError("Could not generate OTP.")))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func resendOTP(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        Alamofire.request(URL(string: "\(rootURL)provider/resend_otp")!, method: .post, parameters: param, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        if let responseData = _data["data"] as? [String: Any],
                            let otp = responseData["otp"] as? String {
                            
                            completionHandler(APIResult.success(otp))
                            return
                        }
                    } else if status == "fail" {
                        //no message from server
                        completionHandler(APIResult.failure(.otherError("Could not resend OTP.")))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func getCities(param: [String: Any], completionHandler: @escaping (APIResult<[City]>) -> ()) {
        //just in case
        guard let key = Settings.sessionKey else {
            completionHandler(APIResult.failure(.otherError("Session key is missing.")))
            return
        }
        
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": key]
        
        Alamofire.request(URL(string: "\(rootURL)city/list")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        if let responseData = _data["data"] as? [[String: Any]] {
                            completionHandler(APIResult.success(responseData.map { City($0) }))
                            return
                        }
                    } else if status == "fail" {
                        //no message from server
                        completionHandler(APIResult.failure(.otherError("Could not fetch cities.")))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func getCategories(param: [String: Any], completionHandler: @escaping (APIResult<[Category]>) -> ()) {
        //just in case
        guard let key = Settings.sessionKey else {
            completionHandler(APIResult.failure(.otherError("Session key is missing.")))
            return
        }
        
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": key]
        
        Alamofire.request(URL(string: "\(rootURL)provider/categories")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        if let responseData = _data["data"] as? [[String: Any]] {
                            completionHandler(APIResult.success(responseData.map { Category($0) }))
                            return
                        }
                    } else if status == "fail" {
                        //no message from server
                        completionHandler(APIResult.failure(.otherError("Could not fetch categories.")))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func signUp(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        //just in case
        guard let key = Settings.sessionKey else {
            completionHandler(APIResult.failure(.otherError("Session key is missing.")))
            return
        }
        
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": key]
        Alamofire.request(URL(string: "\(rootURL)provider/signup")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        completionHandler(APIResult.success("success"))
                        return
                    } else if status == "fail" {
                        //no message from server
                        completionHandler(APIResult.failure(.otherError("Some error occurred. Please try again.")))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func forgotPassword(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        //just in case
        guard let key = Settings.sessionKey else {
            completionHandler(APIResult.failure(.otherError("Session key is missing.")))
            return
        }
        
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": key]
        Alamofire.request(URL(string: "\(rootURL)provider/forgot")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        completionHandler(APIResult.success("success"))
                        return
                    } else if status == "fail" {
                        //no message from server
                        completionHandler(APIResult.failure(.otherError("Some error occurred. Please try again.")))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func getProviderProfile(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)provider/profile")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        if let modelData = _data["data"] as? [String: Any] {
                            LocalUser.instance.updateModelFromJson(dict: modelData)
                            completionHandler(APIResult.success("success"))
                            return
                        }
                    } else if status == "fail" {
                        //no message from server
                        completionHandler(APIResult.failure(.otherError("Couldn't fetch profile details.")))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }

    func updateProfile(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)provider/update")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        //no data from server
                        completionHandler(APIResult.success("success"))
                        return
                    } else if status == "fail" {
                        //no message from server
                        completionHandler(APIResult.failure(.otherError("Some error occurred. Please try again.")))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func updateDp(imageData: Data, param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        
        let timestamp = Int64(NSDate().timeIntervalSince1970)
        let fileName = "\(timestamp).jpg"

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                let _value = value as! String
                multipartFormData.append(_value.data(using: String.Encoding.utf8)!, withName: key)
            }
            multipartFormData.append(imageData, withName: "image", fileName: fileName, mimeType: "image/jpeg")
        }, usingThreshold: UInt64.init(), to: URL(string: "\(rootURL)provider/updateprofilepic")!, method: .post, headers: header) { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response.result.value!)
                    if let data = response.result.value, let _data = data as? [String: Any], let status = _data["status"] as? String {
                        if status == "success" {
                            completionHandler(APIResult.success("success"))
                            return
                        } else if status == "fail" {
                            if let message = _data["message"] as? String {
                                completionHandler(APIResult.failure(.otherError(message)))
                                return
                            }
                        }
                    }
                    completionHandler(APIResult.failure(APIError.wrongResponse))
                }
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }

    func updateAvailability(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)provider/updateavailability")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        //no data from server
                        completionHandler(APIResult.success("success"))
                        return
                    } else if status == "fail" {
                        if let message = _data["message"] as? String {
                            completionHandler(APIResult.failure(.otherError(message)))
                            return
                        }
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func getQuotationOrders(param: [String: Any], completionHandler: @escaping (APIResult<[Quotation]>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)order/quotation")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        if let modelData = _data["data"] as? [[String: Any]] {
                            let quotations = modelData.map { Quotation($0) }
                            completionHandler(APIResult.success(quotations))
                            return
                        }
                    } else if status == "fail" {
                        if let message = _data["message"] as? String {
                            completionHandler(APIResult.failure(.otherError(message)))
                            return
                        } else if let _ = _data["data"] as? String {
                            completionHandler(APIResult.success([]))
                            return
                        }
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func getOpenOrders(param: [String: Any], completionHandler: @escaping (APIResult<[Job]>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)order/open")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        if let modelData = _data["data"] as? [[String: Any]] {
                            let jobs = modelData.map { Job($0) }
                            completionHandler(APIResult.success(jobs))
                            return
                        }
                    } else if status == "fail" {
                        if let message = _data["message"] as? String {
                            completionHandler(APIResult.failure(.otherError(message)))
                            return
                        } else if let _ = _data["data"] as? String {
                            completionHandler(APIResult.success([]))
                            return
                        }
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func getInProgressOrders(param: [String: Any], completionHandler: @escaping (APIResult<[Job]>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)order/progress")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        if let modelData = _data["data"] as? [[String: Any]] {
                            let jobs = modelData.map { Job($0) }
                            completionHandler(APIResult.success(jobs))
                            return
                        }
                    } else if status == "fail" {
                        if let message = _data["message"] as? String {
                            completionHandler(APIResult.failure(.otherError(message)))
                            return
                        } else if let _ = _data["data"] as? String {
                            completionHandler(APIResult.success([]))
                            return
                        }
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func getCompletedOrders(param: [String: Any], completionHandler: @escaping (APIResult<[Job]>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)order/complete")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        if let modelData = _data["data"] as? [[String: Any]] {
                            let jobs = modelData.map { Job($0) }
                            completionHandler(APIResult.success(jobs))
                            return
                        }
                    } else if status == "fail" {
                        if let message = _data["message"] as? String {
                            completionHandler(APIResult.failure(.otherError(message)))
                            return
                        } else if let _ = _data["data"] as? String {
                            completionHandler(APIResult.success([]))
                            return
                        }
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func getAllOrders(param: [String: Any], completionHandler: @escaping (APIResult<[Job]>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)order/complete")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        if let modelData = _data["data"] as? [[String: Any]] {
                            let jobs = modelData.map { Job($0) }
                            completionHandler(APIResult.success(jobs))
                            return
                        }
                    } else if status == "fail" {
                        if let message = _data["message"] as? String {
                            completionHandler(APIResult.failure(.otherError(message)))
                            return
                        } else if let _ = _data["data"] as? String {
                            completionHandler(APIResult.success([]))
                            return
                        }
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func getOrderDetails(param: [String: Any], completionHandler: @escaping (APIResult<[String: Any]>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)order/details")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        if let modelData = _data["data"] as? [[String: Any]], let _modelData = modelData.first {
                            completionHandler(APIResult.success(_modelData))
                            return
                        }
                    } else if status == "fail" {
                        if let message = _data["message"] as? String {
                            completionHandler(APIResult.failure(.otherError(message)))
                            return
                        }
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func addQuotation(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)order/addquotation")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        //no data from server
                        completionHandler(APIResult.success("success"))
                        return
                    } else if status == "fail" {
                        if let message = _data["data"] as? String {
                            completionHandler(APIResult.failure(.otherError(message)))
                            return
                        }
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func getPage(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)page/details")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        if let modelData = _data["data"] as? [String: String], let content = modelData["content"] {
                            completionHandler(APIResult.success(content))
                            return
                        }
                    } else if status == "fail" {
                        //no message from server
                        completionHandler(APIResult.failure(.otherError("Some error occurred. Please try again.")))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func addEnquiry(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)enquiry/add")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        //no data from server
                        completionHandler(APIResult.success("success"))
                        return
                    } else if status == "fail" {
                        //no message from server
                        completionHandler(APIResult.failure(.otherError("Some error occurred. Please try again.")))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func getPaymentList(param: [String: Any], completionHandler: @escaping (APIResult<[Settlement]>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)order/settlement")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        if let modelData = _data["data"] as? [[String: Any]] {
                            let settlements = modelData.map { Settlement($0) }
                            completionHandler(APIResult.success(settlements))
                            return
                        }
                    } else if status == "fail" {
                        //no message from server
                        completionHandler(APIResult.failure(.otherError("Some error occurred. Please try again.")))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    //JOB DETAIL WORK
    func startWork(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)order/startwork")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        if let modelData = _data["data"] as? Int {
                            let modelDataString = String(modelData)
                            completionHandler(APIResult.success(modelDataString))
                            return
                        }
                    } else if status == "fail" {
                        completionHandler(APIResult.failure(.otherError("Some error occurred. Please try again.")))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func stopWork(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)order/stopwork")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        completionHandler(APIResult.success("success"))
                        return
                    } else if status == "fail" {
                        completionHandler(APIResult.failure(.otherError("Some error occurred. Please try again.")))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func changeStatus(param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        Alamofire.request(URL(string: "\(rootURL)order/update")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                if let _data = data as? [String: Any], let status = _data["status"] as? String {
                    if status == "success" {
                        completionHandler(APIResult.success("success"))
                        return
                    } else if status == "fail" {
                        completionHandler(APIResult.failure(.otherError("Some error occurred. Please try again.")))
                        return
                    }
                }
                completionHandler(APIResult.failure(APIError.wrongResponse))
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
    
    func uploadBeforeImage(imageData: Data, param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        let timestamp = Int64(NSDate().timeIntervalSince1970)
        let fileName = "\(timestamp).jpg"
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                let _value = value as! String
                multipartFormData.append(_value.data(using: String.Encoding.utf8)!, withName: key)
            }
            multipartFormData.append(imageData, withName: "image", fileName: fileName, mimeType: "image/jpeg")
        }, usingThreshold: UInt64.init(), to: URL(string: "\(rootURL)order/updateimage1")!, method: .post, headers: header) { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response.result.value!)
                    if let data = response.result.value, let _data = data as? [String: Any], let status = _data["status"] as? String {
                        if status == "success" {
                            completionHandler(APIResult.success("success"))
                            return
                        } else if status == "fail" {
                            if let message = _data["message"] as? String {
                                completionHandler(APIResult.failure(.otherError(message)))
                                return
                            }
                        }
                    }
                    completionHandler(APIResult.failure(APIError.wrongResponse))
                }
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }

    func uploadAfterImage(imageData: Data, param: [String: Any], completionHandler: @escaping (APIResult<String>) -> ()) {
        let header = ["Authorization": "Basic YWRtaW46NTY3OA==", "session": LocalUser.instance.key!]
        let timestamp = Int64(NSDate().timeIntervalSince1970)
        let fileName = "\(timestamp).jpg"
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                let _value = value as! String
                multipartFormData.append(_value.data(using: String.Encoding.utf8)!, withName: key)
            }
            multipartFormData.append(imageData, withName: "image", fileName: fileName, mimeType: "image/jpeg")
        }, usingThreshold: UInt64.init(), to: URL(string: "\(rootURL)order/updateimage2")!, method: .post, headers: header) { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response.result.value!)
                    if let data = response.result.value, let _data = data as? [String: Any], let status = _data["status"] as? String {
                        if status == "success" {
                            completionHandler(APIResult.success("success"))
                            return
                        } else if status == "fail" {
                            if let message = _data["message"] as? String {
                                completionHandler(APIResult.failure(.otherError(message)))
                                return
                            }
                        }
                    }
                    completionHandler(APIResult.failure(APIError.wrongResponse))
                }
            case .failure(_):
                completionHandler(APIResult.failure(APIError.networkError))
            }
        }
    }
}
