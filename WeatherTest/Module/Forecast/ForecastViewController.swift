import UIKit

protocol ForecastDisplayLogic: class {
    func displayForecast(viewModel: Forecast.Tabel.ViewModel)
    func displayEmptyView()
}

class ForecastViewController: UIViewController, ForecastDisplayLogic {
    var interactor: ForecastBusinessLogic?
    var router: (NSObjectProtocol & ForecastRoutingLogic & ForecastDataPassing)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let interactor = ForecastInteractor()
        let presenter = ForecastPresenter()
        let router = ForecastRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var tempTitle: UILabel!
    @IBOutlet weak var humidityTitle: UILabel!
    @IBOutlet weak var emptyView: UIView!
    
    var dataStore: [ForecastCellViewModel] = []
    
    func setupView() {
        emptyView.isHidden = true
        dateTitle.text = "Date"
        tempTitle.text = "Temp"
        humidityTitle.text = "Humidity"
        tableView.dataSource = self
        interactor?.getWeatherForecast(request: .init())
    }
    
    func displayForecast(viewModel: Forecast.Tabel.ViewModel) {
        dataStore = viewModel.dataStore
        tableView.reloadData()
    }
    
    func displayEmptyView() {
        emptyView.isHidden = false
    }
}

extension ForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastViewCell
        cell.setup(model: dataStore[indexPath.item])
        return cell
    }
}
