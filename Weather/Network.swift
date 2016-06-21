import Foundation

class Network {
  
  static let sharedInstance = Network()
  var taskProvider: (NSURLRequest, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol = {
    return Network.getDataTask
  }()
  
  func getCurrentWeather(callback: (weather: CurrentWeather?, error: NSError?)->Void) {
    self.httpGet(self.completeURL()) { (jsonObject, error) in
      var currentWeather : CurrentWeather?
      if let json = jsonObject, current = json["currently"] as? [String: AnyObject] {
        currentWeather = CurrentWeather(weatherDictionary: json)
      }
      callback(weather: currentWeather, error: error)
    }
  }
  
  func httpSendRequest(request: NSMutableURLRequest,callback: (jsonObject: [String: AnyObject]?, error: NSError?) -> Void) {
    
    taskProvider(request) { (data, response, error) -> Void in
      
      if let jsonData = data {
        do {
          guard let jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? [String: AnyObject] else { fatalError("could not decode JSON!") }
          
          callback(jsonObject: jsonObject, error: nil)
          
        } catch let error {
          print("Error creating JSON object \(error)")
          callback(jsonObject: nil, error: nil)
        }
      } else if let requestError = error {
        print("Error fetching currentWeather: \(requestError)")
        callback(jsonObject: nil, error: error)
      } else {
        print("Unexpected error with the request")
        callback(jsonObject: nil, error: error)
      }
      }.resume()
  }
  
  class func getDataTask(request: NSURLRequest, completionHandler: DataTaskResult) -> NSURLSessionDataTask {
     return NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: completionHandler)
  }
  
  func httpGet(url: String, callback: (jsonObject: [String: AnyObject]?, error: NSError?) -> Void) {
    let request = NSMutableURLRequest(URL: NSURL(string: url)!)
    httpSendRequest(request, callback: callback)
  }
  
  let baseURL = "https://api.forecast.io/forecast/"
  
  func completeURL() -> String {
    return "\(baseURL)\(Server.getApiKey())/41.881832,-87.623177"
  }
}