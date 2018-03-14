let scheme = "https"
	let host = "api.foursquare.com"
	let path = "/v2/venues/search"
	let clientID = "ACAO2JPKM1MXHQJCK45IIFKRFR2ZVL0QASMCBCG5NPJQWF2G"
	let clientSecret = "YZCKUYJ1WHUV2QICBXUBEILZI1DMPUIDP5SHV043O04FKBHL"
	let categoryID = "4bf58dd8d48988d1e0931735,4bf58dd8d48988d16d941735"
	
//Get the latest date string
		let dateText = Utilities.getFSCurrentDateString()
		let urlText = self.url()!.absoluteString
		let headers : [String : String] = [
			"Content-Type": "application/json",
			"Accept": "application/json"
		]
		let parameters : [String : String] = [
			"client_id": clientID,
			"client_secret": clientSecret,
			"v": Utilities.getFSCurrentDateString(),
			"categoryId": categoryID,
			"ll": location.locationQuery
		]

fileprivate static let formatterForFS: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyyMMdd"
		return formatter
	}()

class func getFSCurrentDateString() -> String {
		return Utilities.formatterForFS.string(from: Date())
	}

