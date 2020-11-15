import XCTest
import Moya
import Foundation
@testable import WeatherTest

class MainInteractorTests: XCTestCase {
    
    var interactor: MainInteractor?
    var presenter: SpyMainPresenter?
    
    override func setUp() {
        let expect = expectation(description: "MainInteractorTest")
        
        let endpointClosure = { (target: OpenWeatherService) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: {.networkResponse(200, target.sampleData)},
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        interactor = MainInteractor(privider: MoyaProvider(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub))
        presenter = SpyMainPresenter(expect: expect)
        interactor?.presenter = presenter
    }
    
    func testGetWeather() {
        interactor?.getWeather(request: .init(cityName: "bangkok"))
        
        waitForExpectations(timeout: 3) { (_) in
            XCTAssertEqual(1, self.presenter?.presentWeatherCount)
        }
    }
    
    func testGetWeatherInEmptyCase() {
        interactor?.getWeather(request: .init(cityName: ""))
        
        waitForExpectations(timeout: 3) { (_) in
            XCTAssertEqual(1, self.presenter?.hideContentCount)
        }
    }
    
    func testGetWeatherInEmptyError() {
        
        let endpointClosure = { (target: OpenWeatherService) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: {.networkResponse(400, Data())},
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        interactor?.worker = .init(privider: MoyaProvider(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub))
        interactor?.getWeather(request: .init(cityName: "bangkoaak"))
        
        waitForExpectations(timeout: 10) { (_) in
            XCTAssertEqual(1, self.presenter?.presentErrorCount)
        }
    }
    
    func testChangeType() {
        
        let type:TempType = interactor?.tempType == .celsius ? .fahrenheit : .celsius
        let data = OpenWeatherService.currentWeather(cityName: "mock").sampleData
        interactor?.weatherModel = try? JSONDecoder().decode(WeatherModel.self, from: data)
        interactor?.changeType(request: .init(tempType: type))
        
        waitForExpectations(timeout: 3) { (_) in
            XCTAssertEqual(1, self.presenter?.updateTempCount)
        }
    }
    
}
