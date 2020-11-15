import Foundation

protocol MainPresentationLogic {
    func presentWeather(response: Main.Weather.Response)
    func updateTemp(response: Main.Temp.Response)
    func hideContent()
    func presentError(error: WeatherError)
}

class MainPresenter: MainPresentationLogic {
    weak var viewController: MainDisplayLogic?
    
    func presentWeather(response: Main.Weather.Response) {
        let main = response.weatherModel.main
        let icon = response.weatherModel.weather.first?.icon ?? ""
        let url = "http://openweathermap.org/img/wn/\(icon)@2x.png"
        let viewModel = Main.Weather.ViewModel(temp: String(response.tempType.convertFromKelvin(main.temp)),
                                               humidity: String(main.humidity),
                                               imageUrl: URL(string: url))
        viewController?.displayWeather(viewModel: viewModel)
    }
    
    func presentError(error: WeatherError) {
        viewController?.hideContent()
        switch error {
        case .mapData:
            viewController?.displayError(value: "can't map data")
        case .network(let detail):
            viewController?.displayError(value: detail)
        }
    }
    
    func hideContent() {
        viewController?.hideContent()
    }
    
    func updateTemp(response: Main.Temp.Response) {
        let temp = String(response.tempType.convertFromKelvin(response.weatherModel.main.temp))
        viewController?.updateTemp(viewModel: .init(temp: temp, tempType: response.tempType))
    }
}
