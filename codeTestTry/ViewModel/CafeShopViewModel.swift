//
//  CafeShopViewModel.swift
//  codeTestTry
//
//  Created by Roger Zhang on 14/3/18.
//  Copyright © 2018 Roger Zhang. All rights reserved.
//

import UIKit

class CafeShopViewModel: NSObject {
    let searchBar: UISearchBar
    let tableView: UITableView
    let cellIdentification = "CafeShopTableViewCell"
    //Set fixed location to simulate
    let currentLocation = UserLocation(lat: -33.87294542928269,lng: 151.2079882621765)
    var cafeShops: [CafeShop] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    var updateViewByKeyboard: ((CGFloat) -> Void)?
    
    init(searchBar: UISearchBar, tableView: UITableView) {

        self.searchBar = searchBar
        self.tableView = tableView
        self.cafeShops = [CafeShop]()
        super.init()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func loadingData() {
        NetworkHelper.shared.networkRequest(currentLocation: self.currentLocation, completion: { [weak self] result in
            switch result {
            case .success(let shopArray):
                self?.cafeShops = shopArray.sorted{ $0.location.distance! < $1.location.distance! }
            case .failure(let error):
                debugPrint("loading data failed by \(error.localizedDescription)")
            }
        })
        
        //Test callback function updateViewByKeyboard
        self.updateViewByKeyboard?(15.0)
        
    }
    
}
