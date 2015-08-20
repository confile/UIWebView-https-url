

import UIKit

class ViewController: UIViewController, UIWebViewDelegate, NSURLConnectionDataDelegate {

  
  @IBOutlet weak var webView: UIWebView!
  var request: NSURLRequest!
  var urlString: String!
  private var isDone: Bool = false
  private var failedRequest: NSURLRequest!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    urlString = "https://buchung.salonmeister.de/ort/301655/menue/#offerId=907601&venueId=301655"
    
    request = NSURLRequest(URL: NSURL(string: urlString)!)
    
    webView.delegate = self
    
  }


  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  
    self.webView.loadRequest(self.request)
  }
  
  
  // MARK: UIWebViewDelegate
  
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    println("shouldStartLoadWithRequest()")
    
    if !isDone {
      isDone = false
      
      println("shouldStartLoadWithRequest() 111")
      failedRequest = request
      webView.stopLoading()
      var connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
      connection!.start()
      //      NSURLConnection(request: request, delegate: self)
      return false
    }
    println("shouldStartLoadWithRequest() -----------------------")
    return true
  }
  
  func webViewDidStartLoad(webView: UIWebView) {
    println("webViewDidStartLoad()")
  }
  
  func webViewDidFinishLoad(aWebView: UIWebView) {
    println("webViewDidFinishLoad()")
  }
  
  func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
    println("webView(): didFailLoadWithError(): \(error)")
  }
  
  // MARK: NSURLConnectionDataDelegate
  
  func connection(connection: NSURLConnection, willSendRequestForAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
    println("connection willSendRequestForAuthenticationChallenge")
    
    if challenge.previousFailureCount == 0 {
      self.isDone = true
      println("x1")
      let credential: NSURLCredential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
      challenge.sender.useCredential(credential, forAuthenticationChallenge: challenge)
      
    }
    else {
      println("x2")
      challenge.sender.cancelAuthenticationChallenge(challenge)
    }
  }
  
  
  func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
    println("connection didReceiveResponse")
    self.isDone = true
    
    connection.cancel()
    self.webView.loadRequest(self.failedRequest)
  }
  
  
  func connection(connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: NSURLProtectionSpace) -> Bool {
    println("connection canAuthenticateAgainstProtectionSpace")
    return protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
  }
  
  
}

