//
//  DateTimeHelper.swift
//  codeTestTry
//
//  Created by Roger Zhang on 14/3/18.
//  Copyright © 2018 Roger Zhang. All rights reserved.
//

import Foundation

class DateTimeHelper {
    fileprivate static let  currentDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    class func getLatestDateText() -> String {
        return currentDateFormatter.string(from: Date())
    }
}
