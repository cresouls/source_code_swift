//
//  String+Date.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 24/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import Foundation

extension String {
    //date to local forat
    func dateToLocalFormat(_ format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        
        if let date = df.date(from: self) {
            let newdf = DateFormatter()
            //newdf.dateFormat = "dd MMM yyyy"
            newdf.dateFormat = "dd MMMM, yyyy"
            return newdf.string(from: date)
        }
        return ""
    }
    
    //date to date, monthYear split
    func dateToLocalSplitFormat() -> (String, String) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let serverDate = df.date(from: self) {
            let newdf = DateFormatter()
            newdf.dateFormat = "d"
            let date = newdf.string(from: serverDate)
            
            let newdf2 = DateFormatter()
            newdf2.dateFormat = "MMM yyyy"
            let monthYear = newdf2.string(from: serverDate)
            return (date, monthYear)
        }
        return ("", "")
    }
}
