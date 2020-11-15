import XCTest
@testable import WeatherTest

class SpyForecastViewController: ForecastDisplayLogic {
    
    let expect: XCTestExpectation?
    var displayForecastCount = 0
    var displayEmptyViewCount = 0
    
    init(expect: XCTestExpectation? = nil) {
        self.expect = expect
    }
    
    func displayForecast(viewModel: Forecast.Tabel.ViewModel) {
        displayForecastCount += 1
        expect?.fulfill()
    }
    
    func displayEmptyView() {
        displayEmptyViewCount += 1
        expect?.fulfill()
    }
    
}
