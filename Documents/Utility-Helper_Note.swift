class PlistHelper: NSObject {
	static let shared = PlistHelper()
	
	fileprivate let configFileName = "CustomConfiguration"
	fileprivate let fileType = "plist"
	var customData: Data?
	
	private override init() {
		if let plistFile = Bundle.main.url(forResource: configFileName, withExtension: fileType),
			let data = try? Data(contentsOf: plistFile) {
			self.customData = data
		} else {
			debugPrint("PlistHelper: custom plist cannot be got.")
			self.customData = nil
		}
	}

func getConfiguration(key: String) -> String {
		let emptyReturn = ""
		
		guard self.customData != nil && !key.isEmpty else {
			return emptyReturn
		}
		
		if let result = try? PropertyListSerialization.propertyList(from: self.customData!, options: [], format: nil) as? [String: Any], let valueString = result![key] as? String {
			return valueString
		} else {
			return emptyReturn
		}
	}
}

class DateTimeHelper {
	fileprivate static let formatterForCurrent: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM-dd HH:mm:ss"
		return formatter
	}()
	
	fileprivate static let formatterForDaily: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM-dd EEE"
		return formatter
	}()
	
	fileprivate static let formatterForHourly: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM-dd h:mma"
		return formatter
	}()
	
	class func getCurrentDateString(_ unixTime: Double) -> String {
		let date = Date(timeIntervalSince1970: unixTime)
		return DateTimeHelper.formatterForCurrent.string(from: date)
	}
	
	class func getDailyDateString(_ unixTime: Double) -> String {
		let date = Date(timeIntervalSince1970: unixTime)
		return DateTimeHelper.formatterForDaily.string(from: date)
	}
	
	class func getHourlyDateString(_ unixTime: Double) -> String {
		let date = Date(timeIntervalSince1970: unixTime)
		return DateTimeHelper.formatterForHourly.string(from: date)
	}

}