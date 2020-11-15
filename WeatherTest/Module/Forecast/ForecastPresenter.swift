protocol ForecastPresentationLogic {
    func presentForecast(response: Forecast.Tabel.Response)
    func presentError(error: WeatherError)
}

class ForecastPresenter: ForecastPresentationLogic {
    weak var viewController: ForecastDisplayLogic?
    
    func presentForecast(response: Forecast.Tabel.Response)
    {
        let data = response.forecastModel.list.map { item -> ForecastCellViewModel in
            return .init(model: item, tempType: response.tempType)
        }
        if data.isEmpty {
            viewController?.displayEmptyView()
        } else {
            viewController?.displayForecast(viewModel: .init(dataStore: data))
        }
    }
    
    func presentError(error: WeatherError) {
        viewController?.displayEmptyView()
    }
}
