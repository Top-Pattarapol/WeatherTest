import Foundation

@objc protocol ForecastRoutingLogic {
    
}

protocol ForecastDataPassing {
    var dataStore: ForecastDataStore? { get }
}

class ForecastRouter: NSObject, ForecastRoutingLogic, ForecastDataPassing {
    weak var viewController: ForecastViewController?
    var dataStore: ForecastDataStore?
}
