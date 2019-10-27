//
//  LocalUser.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 02/06/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

class LocalUser {
    var id: String?
    var firstName: String?
    var lastName: String?
    var dp: String?
    var email: String?
    var mobile: String?
    var referralCode: String?
    var key: String?
    var isAvailable = false
    var notificationId: String?
    
    var name: String {
        var _name = ""
        if let _firstName = firstName {
            _name = _name + _firstName
        }
        if let _lastName = lastName {
            _name = _name + " \(_lastName)"
        }
        return _name
    }
    
    var dpURL: URL? {
        if let _dp = dp?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: _dp)
        }
        return nil
    }
    
    static let instance = LocalUser()
    
    private lazy var keychain = KeychainSwift()
    
    private init() { }
    
    func updateIdFromJson(dict: [String: Any]) {
        print(dict)
        guard let id = dict["id"] else {
            fatalError("wrong json")
        }
        
        if let _id = id as? String {
            self.id = _id
        } else if let _id = id as? Int {
            self.id = String(_id)
        } else {
            fatalError("wrong data type")
        }
        
        keychain.set(self.id!, forKey: "id")
    }
    
    func updateModelFromJson(dict: [String: Any]) {
        guard let firstName = dict["sp_first_name"] as? String,
            let lastName = dict["sp_last_name"] as? String,
            let dp = dict["profile_image"] as? String,
            let email = dict["sp_email_id"] as? String,
            let mobile = dict["sp_mobile_number"] as? String,
            let referralCode = dict["referral_code"] as? String,
            let isAvailable = dict["availability_status"] as? String else {
                fatalError("wrong json")
        }
        self.firstName = firstName
        self.lastName = lastName
        self.dp = dp
        self.email = email
        self.mobile = mobile
        self.referralCode = referralCode
        self.isAvailable = Int(isAvailable) == 1
        
        keychain.set(self.firstName!, forKey: "firstName")
        keychain.set(self.lastName!, forKey: "lastName")
        keychain.set(self.dp!, forKey: "dp")
        keychain.set(self.email!, forKey: "email")
        keychain.set(self.mobile!, forKey: "mobile")
        keychain.set(self.referralCode!, forKey: "referralCode")
        keychain.set(self.isAvailable, forKey: "isAvailable")
    }

    func updateIdFromKeychain() {
        guard let id = keychain.get("id"),
            let key = keychain.get("key"),
            let notificationId = keychain.get("notificationId")    else {
                fatalError("keychain issue")
        }
        
        self.id = id
        self.key = key
        self.notificationId = notificationId
    }
    
    func updateModelFromKeychain() {
        if let id = keychain.get("id"),
            let firstName = keychain.get("firstName"),
            let lastName = keychain.get("lastName"),
            let dp = keychain.get("dp"),
            let email = keychain.get("email"),
            let mobile = keychain.get("mobile"),
            let referralCode = keychain.get("referralCode"),
            let isAvailable = keychain.getBool("isAvailable") {
            
            self.id = id
            self.firstName = firstName
            self.lastName = lastName
            self.dp = dp
            self.email = email
            self.mobile = mobile
            self.referralCode = referralCode
            self.isAvailable = isAvailable
        }
    }

    func setKey(_ key: String) {
        self.key = key
        keychain.set(self.key!, forKey: "key")
    }
    
    func setNotificationId(_ notificationId: String) {
        self.notificationId = notificationId
        keychain.set(self.notificationId!, forKey: "notificationId")
    }
    
    private func clearCache() {
        keychain.delete("id")
        keychain.delete("firstName")
        keychain.delete("lastName")
        keychain.delete("dp")
        keychain.delete("email")
        keychain.delete("mobile")
        keychain.delete("referralCode")
        keychain.delete("isAvailable")
        keychain.delete("key")
    }
    
    func isLoggedIn() -> Bool {
        if UserDefaults.standard.object(forKey: "isLaunched") == nil {
            clearCache()
            
            self.notificationId = ""
            keychain.set(self.notificationId!, forKey: "notificationId")
            
            UserDefaults.standard.set("YES", forKey: "isLaunched")
        } else if let _ = keychain.get("key"), let _ = keychain.get("id") {
            //can force unwrap these variables post-login after this test case
            updateIdFromKeychain()
            //cannot force wrap these variables post-login
            updateModelFromKeychain()
            return true
        } else {
            //if logged in is successful in previous and updateKey api is not called
            //data set should be cleared
            clearCache()
        }
        return false
    }
    
    func setIsAvailable(_ isAvailable: Bool) {
        self.isAvailable = isAvailable
        keychain.set(self.isAvailable, forKey: "isAvailable")
    }
    
    func signOut() {
        clearCache()
    }
}
