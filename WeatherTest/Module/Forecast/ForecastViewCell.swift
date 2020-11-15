import UIKit

struct ForecastCellViewModel {
    let date: Date
    let temp: String
    let humidity: String
    let iconUrl: URL?
    
    init(model: ForecastList, tempType: TempType) {
        date = Date(timeIntervalSince1970: TimeInterval(model.dt))
        temp = String(tempType.convertFromKelvin(model.main.temp))
        humidity = String(model.main.humidity)
        iconUrl = URL(string: "http://openweathermap.org/img/wn/\(model.weather.first?.icon ?? "")@2x.png")
    }
}

class ForecastViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    public func setup(model: ForecastCellViewModel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM YY \n HH:mm"
        dateLabel.text = formatter.string(from: model.date)
        tempLabel.text = model.temp
        humidityLabel.text = model.humidity
        iconImageView.kf.setImage(with: model.iconUrl)
    }
}
