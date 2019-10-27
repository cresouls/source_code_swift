//
//  Date+Now.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 19/08/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

extension Date {
    static func currentDataInServerFormat() -> String {
        let now = Date()
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return df.string(from: now)
    }
}
