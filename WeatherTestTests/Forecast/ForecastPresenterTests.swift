import XCTest
@testable import WeatherTest

class ForecastPresenterTests: XCTestCase {
    
    var presenter = ForecastPresenter()
    var viewController: SpyForecastViewController?
    
    override func setUp() {
        let expect = expectation(description: "ForecastPresenterTest")
        viewController = SpyForecastViewController(expect: expect)
        presenter.viewController = viewController
    }
    
    func testPresentForecast() {
        let data = OpenWeatherService.fiveDayWeatherForecast(cityName: "mock").sampleData
        let forecastModel = try? JSONDecoder().decode(ForecastModel.self, from: data)
        presenter.presentForecast(response: .init(forecastModel: forecastModel!, tempType: .celsius))
        
        waitForExpectations(timeout: 3) { (_) in
            XCTAssertEqual(1, self.viewController?.displayForecastCount)
        }
    }
    
    func testPresentError() {
        presenter.presentError(error: .mapData)
        waitForExpectations(timeout: 3) { (_) in
            XCTAssertEqual(1, self.viewController?.displayEmptyViewCount)
        }
    }
    
    
}
