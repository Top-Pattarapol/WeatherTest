import Foundation
import Moya

enum TempType: String {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    
    func convertFromKelvin(_ value: Double) -> Double {
        let measurement = Measurement(value: value, unit: UnitTemperature.kelvin)
        switch self {
        case .celsius:
            return measurement.converted(to: .celsius).value.rounded(toPlaces: 2)
        case .fahrenheit:
            return measurement.converted(to: .fahrenheit).value.rounded(toPlaces: 2)
        }
    }
    
}

enum OpenWeatherService {
    case currentWeather(cityName: String)
    case fiveDayWeatherForecast(cityName: String)
    
    var mockFileName: String {
        switch self {
        case .currentWeather:
            return "Weather"
        case .fiveDayWeatherForecast:
            return "Forecast"
        }
    }
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
            let parameters = ["q": cityName, "appid": token]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    var sampleData: Data {
        switch self {
        case .currentWeather, .fiveDayWeatherForecast:
            guard let url = Bundle.main.url(forResource: mockFileName, withExtension: "json"),
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
