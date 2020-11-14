import Foundation
import Moya

enum OpenWeatherService {
    case currentWeather(cityName: String)
    case fiveDayWeatherForecast(cityName: String)
}

extension OpenWeatherService: TargetType {
    
    var baseURL: URL { return URL(string: "https://api.openweathermap.org/data/2.5")! }
    
    var token: String {return "046aaa21a8bce9c4d00aa45fbc98d653"}
    
    var path: String {
        switch self {
        case .currentWeather:
            return "/weather"
        case .fiveDayWeatherForecast:
            return "/forecast"
        }
    }

    var method: Moya.Method {
        switch self {
        case .currentWeather, .fiveDayWeatherForecast:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .currentWeather(cityName), let .fiveDayWeatherForecast(cityName):
            return .requestParameters(parameters: ["q": cityName, "appid": token], encoding: URLEncoding.queryString)
        }
    }
    var sampleData: Data {
        switch self {
        case .currentWeather, .fiveDayWeatherForecast:
            // Provided you have a file named accounts.json in your bundle.
            guard let url = Bundle.main.url(forResource: "accounts", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
