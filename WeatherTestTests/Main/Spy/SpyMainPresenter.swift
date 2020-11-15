import XCTest
@testable import WeatherTest

class SpyMainPresenter: MainPresentationLogic {
    let expect: XCTestExpectation?
    var presentWeatherCount = 0
    var updateTempCount = 0
    var hideContentCount = 0
    var presentErrorCount = 0
    
    init(expect: XCTestExpectation? = nil) {
        self.expect = expect
    }
    
    func presentWeather(response: Main.Weather.Response) {
        presentWeatherCount += 1
        expect?.fulfill()
    }
    
    func updateTemp(response: Main.Temp.Response) {
        updateTempCount += 1
        expect?.fulfill()
    }
    
    func hideContent() {
        hideContentCount += 1
        expect?.fulfill()
    }
    
    func presentError(error: WeatherError) {
        presentErrorCount += 1
        expect?.fulfill()
    }
    
}
