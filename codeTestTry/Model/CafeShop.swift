//
//  CafeShop.swift
//  codeTestTry
//
//  Created by Roger Zhang on 14/3/18.
//  Copyright © 2018 Roger Zhang. All rights reserved.
//

import Foundation
import  Gloss

protocol CafeShopDataModel {
    var name: String { get }
    var location: ShopLocation { get }
}

struct CafeShop: CafeShopDataModel {
    var name: String
    var location: ShopLocation
}

extension CafeShop: JSONDecodable {
    init?(json: JSON) {
        self.name = ("name" <~~ json)!
        self.location = ("location" <~~ json)!
    }
}
