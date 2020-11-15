import UIKit

@objc protocol MainRoutingLogic {
    func routeToForcast(segue: UIStoryboardSegue?)
}

protocol MainDataPassing {
    var dataStore: MainDataStore? { get }
}

class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {
    weak var viewController: MainViewController?
    var dataStore: MainDataStore?
    
    func routeToForcast(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! ForecastViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToForecast(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ForecastViewController") as! ForecastViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToForecast(source: dataStore!, destination: &destinationDS)
            navigateToForecast(source: viewController!, destination: destinationVC)
        }
    }
    
    func navigateToForecast(source: MainViewController, destination: ForecastViewController) {
        source.show(destination, sender: nil)
    }
    
    func passDataToForecast(source: MainDataStore, destination: inout ForecastDataStore) {
        destination.cityName = source.cityName
        destination.tempType = source.tempType
    }
}
