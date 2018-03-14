pod 'Alamofire', '~> 4.7’
Swift 4.0

####### Setup URL text #####
fileprivate let scheme = "https"
	fileprivate let dataSource = PlistHelper.shared.getConfiguration(key: "DataSource")
	fileprivate let secretKey = PlistHelper.shared.getConfiguration(key: "SecretKey")
	fileprivate let path = PlistHelper.shared.getConfiguration(key: "Path")
	
	
	fileprivate func url() -> URL? {
		var components = URLComponents()
		components.scheme = scheme
		components.host = dataSource
		components.path = path + "/" + secretKey
		
		return components.url
	}

let urlText = self.url()!.absoluteString + "/" + location.locationQuery

#######

enum Error: Swift.Error {
	case invalidURL
	case failedJSONParsing
	case networkFailure
}

enum Result<T, Error: Swift.Error> {
	case success(T)
	case failure(Error)
}

//Load data from NW
	func loadWeatherData(_ position: UserLocation, completion: @escaping (Result<WSRawData, Error>) -> ()) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		let request = networkConnectRequest(position)
	
		request?.validate()
			.responseJSON(completionHandler: { response in
				switch response.result {
				case .success:
//Decode JSON data into model data by Gloss
					if let value = response.result.value as? [String: Any], let currentEle = value["currently"] as? [String: Any], let currentData = WSWeatherInfo.init(json: currentEle), let hourlyEle = value["hourly"] as? [String: Any], let hourlyArray = hourlyEle["data"] as? [[String: Any]], let hourlyData = [WSWeatherInfo].from(jsonArray: hourlyArray), let dailyEle = value["daily"] as? [String: Any], let dailyArray = dailyEle["data"] as? [[String: Any]], let dailyData = [WSDailyWeatherInfo].from(jsonArray: dailyArray)
					{
						let decodeData = WSRawData(currentWeather: currentData, hourlyWeather: hourlyData, dailyWeather: dailyData)
						
						completion(Result.success(decodeData))
					} else {
						completion(Result.failure(.failedJSONParsing))
					}
					
				case .failure(let error):
					print("load Venues error: \(error.localizedDescription)")
					completion(Result.failure(.networkFailure))
				}
				
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
			})
	}

//Create DataRequest
func networkConnectRequest(_ location: UserLocation) -> DataRequest?
	{
		let urlText = self.url()!.absoluteString + "/" + location.locationQuery
		let headers : [String : String] = [
			"Content-Type": "application/json",
			"Accept": "application/json"
		]

/* Set access username and password by Header Authorization parameter
if let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8) {
			let base64Credentials = credentialData.base64EncodedString()
			headers["Authorization"] = "Basic \(base64Credentials)"
		}
		
		if let uuidText = UIDevice.current.identifierForVendor?.uuidString {
			headers["x-device-uid"] = uuidText
		}
*/

		let parameters : [String : String] = [
			"lang": "en",
			"units": "si"
		]
		
		//Request msg format: https://api.darksky.net/forecast/27dc8bb2761e07624d9d399ed87dd668/-33.8734,151.2068?lang=en&units=si
		
		return Alamofire.SessionManager.default.requestWithoutCache(urlText, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)

/* Simple request with cache ---
Alamofire.request(url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: URLEncoding.default (query) / JSONEncoding.default (data body), headers: HTTPHeaders?)
*/

/* Simple request by Post with body data
var request = URLRequest(url: URL(string: url)!)
request.httpMethod = HTTPMethod.post.rawValue
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//Convert string to Data
let pjson = attendences.toJSONString(prettyPrint: false)
let data = (pjson?.data(using: .utf8))! as Data

request.httpBody = data

Alamofire.request(request).responseJSON { (response) in
	print(response)
}

*/
		
	}

//Extension to disable cache for latest data
extension Alamofire.SessionManager{
	@discardableResult
	open func requestWithoutCache(
		_ url: URLConvertible,
		method: HTTPMethod = .get,
		parameters: Parameters? = nil,
		encoding: ParameterEncoding = URLEncoding.default,
		headers: HTTPHeaders? = nil)
		-> DataRequest?
	{
		do {
			var urlRequest = try URLRequest(url: url, method: method, headers: headers)
			urlRequest.cachePolicy = .reloadIgnoringCacheData //Cache disabled
			let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
			return request(encodedURLRequest)
		} catch {
			print(error)
			return nil
		}
	}
}

//How to call nw data load function
NetworkConnection.sharedInstance.loadWeatherData(currentLocation, completion: { [unowned self] result in
			DispatchQueue.main.async {
				switch result {
				case .success(let resultData):
					debugPrint("Successfully get weather data.")
					
					WeatherDataInfo.shared.resetData()
					
					WeatherDataInfo.shared.currentWeatherInfo = resultData.currentWeather
					WeatherDataInfo.shared.dailyWeatherInfo = resultData.dailyWeather
					WeatherDataInfo.shared.hourlyWeatherInfo = resultData.hourlyWeather
					
					self.dailyViewDelegate?.updateTableView()
					self.hourlyViewDeleage?.updateTableView()
					
				case .failure(let error):
					// Propogate and present error to user
					debugPrint("Get weather data failed: \(error)")
				}
				
				//Dissmiss indication
				SVProgressHUD.dismiss()
				if complete != nil {
					complete!()
				}
			}
		})
