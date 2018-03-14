//
//  CafeShopView+TableView.swift
//  codeTestTry
//
//  Created by Roger Zhang on 14/3/18.
//  Copyright © 2018 Roger Zhang. All rights reserved.
//

import UIKit

extension CafeShopViewModel: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cafeShops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentification, for: indexPath) as! CafeShopTableViewCell
        
        cell.shopName.text = self.cafeShops[indexPath.row].name
        cell.distanceLabel.text = String(self.cafeShops[indexPath.row].location.distance!)
        cell.addressLabel.text = self.cafeShops[indexPath.row].location.address[0] + "\n" + self.cafeShops[indexPath.row].location.address[1]
        
        return cell
    }
}
