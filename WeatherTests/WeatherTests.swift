import Quick
import Nimble


@testable import Weather

class FakeURLSessionDataTask: URLSessionDataTaskProtocol {
  var response: NSURLResponse?
  func resume() {
  }
}

class FakeURLSession: URLSessionProtocol {
  func dataTaskWithRequest(request: NSURLRequest, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol {
    if request.URL == NSURL(string: "http://unavailableUrl") {
      let sessionDataTask = FakeURLSessionDataTask()
      let error = NSError(domain: "Invalid URL", code: 404, userInfo: ["":""])
      sessionDataTask.response = NSHTTPURLResponse(URL: request.URL!, statusCode: 404, HTTPVersion: "1.2", headerFields: nil)
      completionHandler(nil, sessionDataTask.response, error)
      return sessionDataTask
    } else  if request.URL == NSURL(string: "http://validURL") {
      let sessionDataTask = FakeURLSessionDataTask()
      sessionDataTask.response = NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: "1.2", headerFields: nil)
      completionHandler(nil, sessionDataTask.response, nil)
      return sessionDataTask
    } else {
      return NSURLSessionDataTask()
    }
  }
}

class NetworkSpec: QuickSpec {
  override func spec() {
    describe("Network") {
      context("with an unavailable url") {
        it("should provide an error") {
          
          let network = Network()
          network.taskProvider = FakeURLSession().dataTaskWithRequest
          network.httpGet("http://unavailableUrl") { jsonObject, error in
            
            expect(error).toNot(beNil())
          }
        }
      }
      
      context("with a valid url") {
        fit("should return the current weather data") {
          let network = Network()
          network.taskProvider = FakeURLSession().dataTaskWithRequest
          network.httpGet("http://validURL") { jsonObject, error in
            
            expect(error).to(beNil())
          }
        }
      }
      
      context("httpGet()") {
        it("resume gets called and starts the request") {
        }
      }
    }
  }
}
