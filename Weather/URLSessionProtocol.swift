import Foundation


typealias DataTaskResult = (NSData?, NSURLResponse?, NSError?) -> Void

protocol URLSessionProtocol {
  func dataTaskWithRequest(request: NSURLRequest, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol
}


protocol URLSessionDataTaskProtocol {
  var response: NSURLResponse? { get }
  func resume()
}

extension NSURLSession: URLSessionProtocol {
  func dataTaskWithRequest(request: NSURLRequest, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol {
    let dataTask: NSURLSessionDataTask = dataTaskWithRequest(request, completionHandler: completionHandler)
    return dataTask as URLSessionDataTaskProtocol
  }
}

extension NSURLSessionDataTask: URLSessionDataTaskProtocol {}

