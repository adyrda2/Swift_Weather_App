import Foundation

struct Server {
  
  static func getApiKey() -> String {
    
    var keys: NSDictionary?
    
    if let path = NSBundle.mainBundle().pathForResource("APIKey", ofType: "plist") {
      keys = NSDictionary(contentsOfFile: path)
    }
    
    guard let dict = keys, key = dict["key"] as? String else { return "" }
    return key
  }
}
