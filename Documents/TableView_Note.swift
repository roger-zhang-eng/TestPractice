
fileprivate let dailyTableView: UITableView

//Set Views
fileprivate func setViews() {
		self.dailyTableView.tableFooterView = UIView()
		
		//Set RefreshControl for refresh animation
		self.refresher = UIRefreshControl()
		self.dailyTableView.addSubview(self.refresher)
		self.refresher.attributedTitle = NSAttributedString(string: "Refreshing weather data...")
		self.refresher.tintColor = UIColor.init(red: 1.0, green: 0.21, blue: 0.55, alpha: 0.5)
		self.refresher.addTarget(self, action: #selector(refreshWeatherData), for: .valueChanged)
}

/* If manual config tableView, need register TableViewCell
tableView.register(SafeZoneTableViewCell.self, forCellReuseIdentifier: cellIndentifier)
*/

self.dailyTableView.dataSource = self
self.dailyTableView.delegate = self


	@objc fileprivate func refreshWeatherData() {
		guard !CurrentSpot.shared.isEmpty else {
			self.refresher.endRefreshing()
			return
		}
		
//viewModel-> func refreshData(complete: @escaping (()->Void)) { … }
		self.viewModel?.refreshData {
			tself.refresher.endRefreshing()
		}
	}



//MARK: UITableViewDataSource and UITableViewDelegate
extension DailyTableViewBinding: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return WeatherDataInfo.shared.dailyWeatherInfo.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as! DailyTableViewCell
		
		let cellData = WeatherDataInfo.shared.dailyWeatherInfo[indexPath.row]
		cell.dataText.text = DateTimeHelper.getDailyDateString(cellData.time!)
		cell.summayText.text = cellData.summary
		cell.minTemper.text = TemperatureHelper.getTemperString(cellData.temperatureMin!)
		cell.maxTemper.text = TemperatureHelper.getTemperString(cellData.temperatureMax!)
		
		return cell
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 100.0
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let tableFrame: CGRect = tableView.frame
		if currentInfoView == nil {
			currentInfoView = CurrentWeatherView(frame: CGRect(x: 0, y: 0, width: tableFrame.size.width, height: 100))
		}
		
		if !self.isCurrentInfoSet && !WeatherDataInfo.shared.isEmpty {
			self.fillCurrentInfo()
		}
		
		return currentInfoView
	}
	
}

