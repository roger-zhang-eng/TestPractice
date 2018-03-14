//
//  UserLocation.swift
//  codeTestTry
//
//  Created by Roger Zhang on 14/3/18.
//  Copyright © 2018 Roger Zhang. All rights reserved.
//

import Foundation

struct UserLocation {
    let lat: Double
    let lng: Double
    
    var description: String {
        return [lat,lng].map{ String($0) }.joined(separator: ",")
    }
}
