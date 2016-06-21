import UIKit

class ViewController: UIViewController {
  
  
  @IBAction func buttonPressed(sender: AnyObject) {
    performSegueWithIdentifier("ShowWeather", sender: self)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
