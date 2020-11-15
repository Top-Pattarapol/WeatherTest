import Moya

protocol ForecastBusinessLogic {
    func getWeatherForecast(request: Forecast.Tabel.Request)
}

protocol ForecastDataStore {
    var cityName: String { get set }
    var tempType: TempType { get set }
}

class ForecastInteractor: ForecastBusinessLogic, ForecastDataStore {
    var presenter: ForecastPresentationLogic?
    var worker: ForecastWorker?
    var cityName: String = ""
    var tempType: TempType = .celsius
    
    init(privider: MoyaProvider<OpenWeatherService> = MoyaProvider<OpenWeatherService>()) {
        worker = ForecastWorker(privider: privider)
    }
    
    func getWeatherForecast(request: Forecast.Tabel.Request) {
        worker?.callWeatherForecast(cityName: cityName, completion: { result in
            switch result {
            case .success(let model):
                self.presenter?.presentForecast(response: .init(forecastModel: model, tempType: self.tempType))
            case .failure(let error):
                self.presenter?.presentError(error: error)
            }
        })
    }
}
