//
//  City.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 17/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

struct City {
    var name: String
    var id: String
    
    init(_ dict: [String: Any]) {
        guard let id = dict["city_id"] as? String,
            let name = dict["city_name"] as? String else {
                fatalError("json wrong")
        }
        self.name = name
        self.id = id
    }
}


struct Category {
    var name: String
    var id: String
    
    init(_ dict: [String: Any]) {
        guard let id = dict["id"] as? String,
            let name = dict["name"] as? String else {
                fatalError("json wrong")
        }
        self.name = name
        self.id = id
    }
}
