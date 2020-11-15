import Foundation
import Moya

enum WeatherError: Error {
    case network(detail: String)
    case mapData
}

class MainWorker {
    let privider: MoyaProvider<OpenWeatherService>
    
    init(privider: MoyaProvider<OpenWeatherService>) {
        self.privider = privider
    }
    
    func callCurrentWeather(cityName: String, completion: @escaping (Result<WeatherModel, WeatherError>) -> Void) {
        privider.request(.currentWeather(cityName: cityName)) { result in
            switch result {
            case .success(let response):
                guard response.statusCode == 200 else {
                    completion(.failure(.network(detail: "status \(response.statusCode)")))
                    return
                }
                guard let model = try? JSONDecoder().decode(WeatherModel.self, from: response.data) else {
                    completion(.failure(.mapData))
                    return
                }
                completion(.success(model))
            case .failure(let error):
                completion(.failure(.network(detail: error.errorDescription ?? "")))
            }
        }
    }
}
