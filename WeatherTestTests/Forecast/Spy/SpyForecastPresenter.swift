import XCTest
@testable import WeatherTest

class SpyForecastPresenter: ForecastPresentationLogic {

    let expect: XCTestExpectation?
    var presentForecastCount = 0
    var presentErrorCount = 0
    
    init(expect: XCTestExpectation? = nil) {
        self.expect = expect
    }
    
    func presentForecast(response: Forecast.Tabel.Response) {
        presentForecastCount += 1
        expect?.fulfill()
    }
    
    func presentError(error: WeatherError) {
        presentErrorCount += 1
        expect?.fulfill()
    }
}
