import UIKit
import Flutter
import GoogleMaps
import flutter_background_service_ios

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    SwiftFlutterBackgroundServicePlugin.taskIdentifier = "com.whitefalcon.trucker"
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyCWO_OjMQ5weq00puKyGj47Umf2DJUetp0")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
