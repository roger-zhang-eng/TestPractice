//
//  ShopLocation.swift
//  codeTestTry
//
//  Created by Roger Zhang on 14/3/18.
//  Copyright © 2018 Roger Zhang. All rights reserved.
//

import Foundation
import Gloss

protocol LocationDataModel {
    var lat: Double? { get }
    var lng: Double? { get }
    var address: [String] { get }
    var distance: Double? { get }
}

struct ShopLocation: LocationDataModel {
    var lat: Double?
    var lng: Double?
    var address: [String]
    var distance: Double?
}

extension ShopLocation: JSONDecodable {
    init(json: JSON) {
        self.lat = "lat" <~~ json
        self.lng = "lng" <~~ json
        self.address = ("formattedAddress" <~~ json)!
        self.distance = "distance" <~~ json
    }
}
