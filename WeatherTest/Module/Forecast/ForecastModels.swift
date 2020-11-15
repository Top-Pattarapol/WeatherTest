enum Forecast {
    enum Tabel
    {
        struct Request
        {
        }
        struct Response
        {
            let forecastModel: ForecastModel
            var tempType: TempType
        }
        struct ViewModel
        {
            let dataStore: [ForecastCellViewModel]
        }
    }
}
