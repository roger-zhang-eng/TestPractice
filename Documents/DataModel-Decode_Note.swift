pod 'Gloss', '~> 2.0’
Swift 4.0 support




struct UserLocation {
	let lat: Double
	let long: Double
	
	fileprivate var locationQuery: String {
		return [lat, long]
			.map { String(describing: $0) }
			.joined(separator: ",")
	}
}

//Decode example
Import Gloss

protocol WSDailyWeatherInfoModel {
	var time: Double? { get }
	var summary: String? { get }
	var icon: String? { get }
	var sunriseTime: Double? { get }
	var sunsetTime: Double? { get }
	var temperatureMin: Double? { get }
	var temperatureMax: Double? { get }
	var windSpeed: Double? { get }
}

struct WSDailyWeatherInfo: WSDailyWeatherInfoModel {
	let time: Double?
	let summary: String?
	let icon: String?
	let sunriseTime: Double?
	let sunsetTime: Double?
	let temperatureMin: Double?
	let temperatureMax: Double?
	let windSpeed: Double?
}

extension WSDailyWeatherInfo: JSONDecodable {
	init?(json: JSON) {
		self.time = "time" <~~ json
		self.summary = "summary" <~~ json
		self.icon = "icon" <~~ json
		self.sunriseTime = "sunriseTime" <~~ json
		self.sunsetTime = "sunsetTime" <~~ json
		self.temperatureMin = "temperatureMin" <~~ json
		self.temperatureMax = "temperatureMax" <~~ json
		self.windSpeed = "windSpeed" <~~ json
	}
}


/* Gloss decode example: JSON data
{
		"id" : 40102424,
		"name": "Gloss",
		"description" : "A shiny JSON parsing library in Swift",
		"html_url" : "https://github.com/hkellaway/Gloss",
		"owner" : {
				"id" : 5456481,
				"login" : "hkellaway"
		},
		"language" : "Swift"
}
*/

struct Repo: JSONDecodable {

	let repoId: Int?
	let name: String?
	let desc: String?
	let url: NSURL?
	let owner: RepoOwner?
	let primaryLanguage: Language?

	enum Language: String {
		case Swift = "Swift"
		case ObjectiveC = "Objective-C"
	}

	// MARK: - Deserialization

	init?(json: JSON) {
		self.repoId = "id" <~~ json
		self.name = "name" <~~ json
		self.desc = "description" <~~ json
		self.url = "html_url" <~~ json
		self.owner = "owner" <~~ json
		self.primaryLanguage = "language" <~~ json
	}

}


struct RepoOwner: JSONDecodable {
	let ownerId: Int?
	let username: String?

	// MARK: - Deserialization

	init?(json: JSON) {
		self.ownerId = "id" <~~ json
		self.username = "login" <~~ json
	}

}

