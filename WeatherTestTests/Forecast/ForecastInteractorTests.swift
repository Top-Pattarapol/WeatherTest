import XCTest
import Moya
import Foundation
@testable import WeatherTest

class ForecastInteractorTests: XCTestCase {
    
    var interactor: ForecastInteractor?
    var presenter: SpyForecastPresenter?
    
    override func setUp() {
        
        let expect = expectation(description: "ForecastInteractorTest")
        
        let endpointClosure = { (target: OpenWeatherService) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: {.networkResponse(200, target.sampleData)},
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        interactor = ForecastInteractor(privider: MoyaProvider(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub))
        presenter = SpyForecastPresenter(expect: expect)
        interactor?.presenter = presenter
    }
    
    func testGetWeatherForecast() {
        interactor?.cityName = "bangkok"
        interactor?.getWeatherForecast(request: .init())
        
        waitForExpectations(timeout: 3) { (_) in
            XCTAssertEqual(1, self.presenter?.presentForecastCount)
        }
    }
    
    func testGetWeatherForecastInEmptyError() {
        
        let endpointClosure = { (target: OpenWeatherService) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: {.networkResponse(400, Data())},
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        interactor?.worker = .init(privider: MoyaProvider(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub))
        interactor?.cityName = "bangkok"
        interactor?.getWeatherForecast(request: .init())
        
        waitForExpectations(timeout: 10) { (_) in
            XCTAssertEqual(1, self.presenter?.presentErrorCount)
        }
    }
    
}
