import Flutter
import UIKit
import GoogleMaps;
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyBWi8eR9BJmi6nKpp4eos31rJdGEn-3Tts")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
