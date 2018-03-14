pod 'Result', '~> 3.0.0’
Support Swift 4.0
Example:

typealias JSONObject = [String: Any]

enum JSONError: Error {
	case noSuchKey(String)
	case typeMismatch
}

func stringForKey(json: JSONObject, key: String) -> Result<String, JSONError> {
	guard let value = json[key] else {
		return .failure(.noSuchKey(key))
	}
	
	if let value = value as? String {
		return .success(value)
	}
	else {
		return .failure(.typeMismatch)
	}
}