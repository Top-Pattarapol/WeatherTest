import XCTest
@testable import WeatherTest

class SpyMainViewController: MainDisplayLogic {
    let expect: XCTestExpectation?
    var displayWeatherCount = 0
    var updateTempCount = 0
    var hideContentCount = 0
    var displayErrorCount = 0
    
    init(expect: XCTestExpectation? = nil) {
        self.expect = expect
    }
    
    func displayWeather(viewModel: Main.Weather.ViewModel) {
        displayWeatherCount += 1
        expect?.fulfill()
    }
    
    func updateTemp(viewModel: Main.Temp.ViewModel) {
        updateTempCount += 1
        expect?.fulfill()
    }
    
    func hideContent() {
        hideContentCount += 1
        expect?.fulfill()
    }
    
    func displayError(value: String) {
        displayErrorCount += 1
    }
    
}
