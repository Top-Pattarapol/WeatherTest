import Moya

protocol MainBusinessLogic {
    func getWeather(request: Main.Weather.Request)
    func changeType(request: Main.Temp.Request)
}

protocol MainDataStore {
    var weatherModel: WeatherModel? { get set }
    var tempType: TempType { get set }
    var cityName: String { get set }
}

class MainInteractor: MainBusinessLogic, MainDataStore {
    var presenter: MainPresentationLogic?
    var worker: MainWorker?
    var weatherModel: WeatherModel?
    var tempType: TempType = .celsius
    var cityName: String = ""
    
    init(privider: MoyaProvider<OpenWeatherService> = MoyaProvider<OpenWeatherService>()) {
        worker = MainWorker(privider: privider)
    }
    
    func getWeather(request: Main.Weather.Request) {
        guard !request.cityName.isEmpty else {
            presenter?.hideContent()
            return
        }
        guard request.cityName != cityName else {
            return
        }
        cityName = request.cityName
        worker?.callCurrentWeather(cityName: request.cityName, completion: { result in
            switch result {
            case .success(let model):
                self.weatherModel = model
                let response = Main.Weather.Response(weatherModel: model, tempType: self.tempType)
                self.presenter?.presentWeather(response: response)
            case .failure(let error):
                self.presenter?.presentError(error: error)
                break
            }
        })
    }
    
    func changeType(request: Main.Temp.Request) {
        guard let weatherModel = weatherModel else { return }
        let type: TempType = request.tempType == .celsius ? .fahrenheit : .celsius
        tempType = type
        presenter?.updateTemp(response: .init(weatherModel: weatherModel, tempType: type))
    }
}
