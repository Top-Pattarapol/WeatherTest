import XCTest
@testable import WeatherTest

class MainPresenterTests: XCTestCase {
    
    var presenter = MainPresenter()
    var viewController: SpyMainViewController?
    
    override func setUp() {
        let expect = expectation(description: "MainPresenterTest")
        viewController = SpyMainViewController(expect: expect)
        presenter.viewController = viewController
    }
    
    func testPresentWeather() {
        let data = OpenWeatherService.currentWeather(cityName: "mock").sampleData
        let weatherModel = try? JSONDecoder().decode(WeatherModel.self, from: data)
        presenter.presentWeather(response: .init(weatherModel: weatherModel!, tempType: .celsius))
        
        waitForExpectations(timeout: 3) { (_) in
            XCTAssertEqual(1, self.viewController?.displayWeatherCount)
        }
    }
    
    func testUpdateTemp() {
        let data = OpenWeatherService.currentWeather(cityName: "mock").sampleData
        let weatherModel = try? JSONDecoder().decode(WeatherModel.self, from: data)
        presenter.updateTemp(response: .init(weatherModel: weatherModel!, tempType: .fahrenheit))
        
        waitForExpectations(timeout: 3) { (_) in
            XCTAssertEqual(1, self.viewController?.updateTempCount)
        }
    }
    
    func testHideContent() {
        presenter.hideContent()
        
        waitForExpectations(timeout: 3) { (_) in
            XCTAssertEqual(1, self.viewController?.hideContentCount)
        }
    }
    
    func testPresentError() {
        presenter.presentError(error: .mapData)
        waitForExpectations(timeout: 3) { (_) in
            XCTAssertEqual(1, self.viewController?.hideContentCount)
            XCTAssertEqual(1, self.viewController?.displayErrorCount)
        }
    }
    
    
}
