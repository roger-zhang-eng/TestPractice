//
//  ViewController.swift
//  codeTestTry
//
//  Created by Roger Zhang on 14/3/18.
//  Copyright © 2018 Roger Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var shopTableView: UITableView!
    var viewModel: CafeShopViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = CafeShopViewModel(searchBar: searchBar, tableView: shopTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel?.loadingData()
    }


}

