//
//  NetworkHelper.swift
//  codeTestTry
//
//  Created by Roger Zhang on 14/3/18.
//  Copyright © 2018 Roger Zhang. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

enum Result<T, Error: Swift.Error> {
    case success(T)
    case failure(Error)
}

enum NetworkError: Swift.Error {
    case invalidURL
    case failedJSONParsing
    case networkFailure
}

class NetworkHelper: NSObject {
    fileprivate let scheme = "https"
    fileprivate let host = "api.foursquare.com"
    fileprivate let path = "/v2/venues/search"
    //Fix value for cafe
    fileprivate let categoryID = "4bf58dd8d48988d1e0931735,4bf58dd8d48988d16d941735"
    fileprivate let clientID = "ACAO2JPKM1MXHQJCK45IIFKRFR2ZVL0QASMCBCG5NPJQWF2G"
        fileprivate let secretKey = "YZCKUYJ1WHUV2QICBXUBEILZI1DMPUIDP5SHV043O04FKBHL"
    
    static let shared = NetworkHelper()
    
    private override init() { }
    
    fileprivate func url() -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        return components.url
    }
    
    func networkRequest(currentLocation: UserLocation, completion: @escaping (Result<[CafeShop], NetworkError>) -> ()) {
        let urlText = self.url()!.absoluteString
        let headers : [String : String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let parameters : [String : String] = [
            "client_id": clientID,
            "client_secret": secretKey,
            "categoryId": categoryID,
            "ll": currentLocation.description,
            "v": DateTimeHelper.getLatestDateText()
        ]
        
        Alamofire.request(urlText, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
        .responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success(let sucValue):
                if let jsonData = sucValue as? [String: Any], let entry = jsonData["response"] as? [String: Any], let venues = entry["venues"] as? [[String: Any]], let cafeShopArray = [CafeShop].from(jsonArray: venues) {
                    completion(Result.success(cafeShopArray))
                } else {
                    completion(Result.failure(NetworkError.failedJSONParsing))
                }
            case .failure(let nwError):
                debugPrint("Network connect error: \(nwError.localizedDescription)")
                completion(Result.failure(NetworkError.networkFailure))
            }
        })
    }
}
