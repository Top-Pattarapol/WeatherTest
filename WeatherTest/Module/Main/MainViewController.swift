import UIKit
import Kingfisher

protocol MainDisplayLogic: class {
    func displayWeather(viewModel: Main.Weather.ViewModel)
    func updateTemp(viewModel: Main.Temp.ViewModel)
    func hideContent()
    func displayError(value: String)
}

class MainViewController: UIViewController, MainDisplayLogic, UITextFieldDelegate {
    var interactor: MainBusinessLogic?
    var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup()
    {
        let viewController = self
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupView()
    }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var tempButton: UIButton!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var errorDetail: UILabel!
    
    var rightItem: UIBarButtonItem?
    
    @IBAction func tempDidTap(_ sender: Any) {
        interactor?.changeType(request: .init(tempType: TempType.init(rawValue: tempButton.titleLabel?.text ?? "") ?? .celsius))
    }
    
    @objc func forecastDidTap() {
        router?.routeToForcast(segue: nil)
    }
    
    func setupView() {
        rightItem = UIBarButtonItem(title: "Forecast", style: .plain, target: self, action: #selector(forecastDidTap))
        navigationItem.rightBarButtonItem = nil
        shouldHideKeyboardWhenTappedAnyArea()
        contentView.isHidden = true
        errorView.isHidden = true
        contentView.applyShadowConner()
        errorView.applyShadowConner()
        cityNameTextField.applyShadowConner()
        cityNameTextField.delegate = self
        cityNameTextField.placeholder = "Entry City Name"
        tempButton.setTitle(TempType.celsius.rawValue, for: .normal)
    }
    
    func getWeather(cityName: String) {
        let request = Main.Weather.Request(cityName: cityName)
        interactor?.getWeather(request: request)
    }
    
    func displayWeather(viewModel: Main.Weather.ViewModel) {
        errorView.isHidden = true
        navigationItem.rightBarButtonItem = rightItem
        contentView.isHidden = false
        tempLabel.text = "Temp: \(viewModel.temp)"
        humidityLabel.text = "Humidity: \(viewModel.humidity)"
        imageView.kf.setImage(with: viewModel.imageUrl)
        imageView.contentMode = .center
    }
    
    func hideContent() {
        navigationItem.rightBarButtonItem = nil
        contentView.isHidden = true
        errorView.isHidden = true
    }
    
    func displayError(value: String) {
        errorView.isHidden = false
        errorDetail.text = "Error: \(value)"
    }
    
    func updateTemp(viewModel: Main.Temp.ViewModel) {
        tempLabel.text = "Temp: \(viewModel.temp)"
        tempButton.setTitle(viewModel.tempType.rawValue, for: .normal)
    }
}

extension MainViewController: UITextViewDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        getWeather(cityName: textField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

