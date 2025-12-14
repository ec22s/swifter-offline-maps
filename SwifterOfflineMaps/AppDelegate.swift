import UIKit
import Swifter

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  private var server: HttpServer?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    do {
      let port: in_port_t = 80
      let server = HttpServer()
      for path in [
        "images", "styles"
      ] {
        server["/\(path)/:path"] = { request in
          return serveFilesAllowCORS(request)
        }
      }
      server["/fonts/:path1/:path2"] = { request in
        return serveFilesAllowCORS(request)
      }
      server["/tiles/:path1/:path2/:path3"] = { request in
        return serveFilesAllowCORS(request)
      }
      try server.start(port)
      print("Listening for requests on :\(port)")
      self.server = server
    } catch {
      print("Failed to start tiles server, \(error)")
      return false
    }
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
}

func serveFilesAllowCORS(_ r: HttpRequest) -> HttpResponse {
  let path = URL(string: Bundle.main.resourcePath! + "/\(HTML_DOC_ROOT)/")!
    .appendingPathComponent(r.path)
    .absoluteString
  var rsp_headers = [String: String]()
  guard let file =  FileHandle(forReadingAtPath: path) else {
    return .raw(404, "Not found", rsp_headers, {_ in })
  }
  defer {
    do {
      try file.close()
    } catch (let error) {
      print("Failed to close \(path), \(error)")
    }
  }
  let body: Data!
  do {
    body = try file.readToEnd()
  } catch (let error){
    print("Failed to read \(path), \(error)")
    return .raw(500, "Internal Server Error", rsp_headers, {_ in })
  }
  rsp_headers["Access-Control-Allow-Origin"] = "*"
  return .raw(200, "OK", rsp_headers, { writer in
    do {
      try writer.write(body)
    } catch (let error) {
      print("Failed to write body, \(error)")
    }
  })
}
