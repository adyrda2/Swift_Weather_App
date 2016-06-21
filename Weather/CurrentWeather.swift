import Foundation

struct CurrentWeather {
  let temperature: Double
  let humidity: Double
  let summary: String
  let timezone: String
  
  init(weatherDictionary: [String: AnyObject]) {
    let currentNode = weatherDictionary["currently"] as! [String: AnyObject]
    
    self.temperature = currentNode["apparentTemperature"] as! Double
    self.humidity = currentNode["humidity"] as! Double
    self.summary = currentNode["summary"] as! String
    self.timezone = weatherDictionary["timezone"] as! String
  }
}
