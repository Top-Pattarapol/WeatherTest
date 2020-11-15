import Foundation

enum Main {
    
    enum Weather {
        struct Request {
            let cityName: String
        }
        struct Response {
            let weatherModel: WeatherModel
            let tempType: TempType
        }
        struct ViewModel {
            let temp: String
            let humidity: String
            let imageUrl: URL?
        }
    }
    
    enum Temp {
        struct Request {
            let tempType: TempType
        }
        struct Response {
            let weatherModel: WeatherModel
            let tempType: TempType
        }
        struct ViewModel {
            let temp: String
            let tempType: TempType
        }
    }
}
