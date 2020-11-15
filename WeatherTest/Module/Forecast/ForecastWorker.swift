import Moya
import Foundation

class ForecastWorker {
    let privider: MoyaProvider<OpenWeatherService>
    
    init(privider: MoyaProvider<OpenWeatherService>) {
        self.privider = privider
    }
    
    func callWeatherForecast(cityName: String, completion: @escaping (Result<ForecastModel, WeatherError>) -> Void) {
        privider.request(.fiveDayWeatherForecast(cityName: cityName)) { result in
            switch result {
            case .success(let response):
                guard response.statusCode == 200 else {
                    completion(.failure(.network(detail: "status \(response.statusCode)")))
                    return
                }
                guard let model = try? JSONDecoder().decode(ForecastModel.self, from: response.data) else {
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
