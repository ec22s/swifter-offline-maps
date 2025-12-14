import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
  private let mapWebView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())

  override func viewDidLoad() {
    super.viewDidLoad()
    guard let www_url = URL(string: Bundle.main.resourcePath! + "/\(HTML_DOC_ROOT)/") else {
      return
    }
    let index_url = www_url.appendingPathComponent("index.html")
    guard let file_url = URL(string: "file://\(index_url.absoluteString)") else {
      return
    }
    mapWebView.navigationDelegate = self
    mapWebView.isInspectable = true
    view = mapWebView
    mapWebView.load(URLRequest(url: file_url))
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    // Ensure that the local HTTP server is running
    // To do: If not running signal the web application via the JavaScript
    // bridge and report an error / provide feedback.
    guard let url = URL(string: "http://localhost") else {
      print("Failed to create URL")
      return
    }
    var req = URLRequest(url: url)
    req.httpMethod = "GET"
    let task = URLSession.shared.dataTask(with: req) { data, response, error in
      guard let rsp = response as? HTTPURLResponse else {
        print("Bunk response")
        return
      }
      if error != nil {
        print("Server returned an error, \(String(describing: error))")
        return
      }
      if rsp.statusCode != 200 {
        print("Server returned unexpected status code \(rsp.statusCode)")
        return
      }
    }
    task.resume()
  }
}
