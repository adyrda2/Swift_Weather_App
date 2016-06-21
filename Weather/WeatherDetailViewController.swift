import UIKit
import Foundation

class WeatherDetailViewController: UIViewController, UISearchBarDelegate {
  
  @IBOutlet var humidityLabel: UILabel!
  @IBOutlet var summaryLabel: UILabel!
  @IBOutlet var temperatureLabel: UILabel!
  @IBOutlet var timezoneLabel: UILabel!
  @IBOutlet var locationSearchBar: UISearchBar!
  
  @IBOutlet var sunImage: UIImageView!
  @IBOutlet var myLabel: UILabel!
  
  var currentTemperature: Double? {
    didSet {
      guard (currentTemperature != nil) else { return }
      temperatureNumberFormatter()
      temperatureBackgroundColor()
    }
  }
  
  var currentHumidity: Double? {
    didSet {
      guard let currentHumidity = currentHumidity else { return }
      humidityLabel.text = "\(currentHumidity)"
    }
  }
  
  var summary: String? {
    didSet {
      guard let summary = summary else { return }
      summaryLabel.text = "\(summary)"
    }
  }
  
  var timezone: String? {
    didSet {
      guard let timezone = timezone else { return }
      timezoneLabel.text = "\(timezone)"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Server.getApiKey()
    locationSearchBar.delegate = self
    
    Network.sharedInstance.getCurrentWeather { (weather, error) in
      if let currentWeather = weather {
        dispatch_async(dispatch_get_main_queue()) {
          
          self.currentTemperature = currentWeather.temperature
          self.currentHumidity = currentWeather.humidity
          self.summary = currentWeather.summary
          self.timezone = currentWeather.timezone
        }
      }
    }
  }
  
  func temperatureBackgroundColor() {
    if self.currentTemperature < 50 {
      view.backgroundColor = UIColor(red: 1, green: 165/255, blue: 0, alpha: 1)
    } else if self.currentTemperature >= 90 {
      view.backgroundColor = UIColor.redColor()
    }
  }
  
  func temperatureNumberFormatter() {
    let roundTemp = round(self.currentTemperature!)
    self.temperatureLabel.text = "\(roundTemp)°"
  }
}