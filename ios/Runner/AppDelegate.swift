import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

      let channel = FlutterMethodChannel(name: "samples.flutter.dev/battery", binaryMessenger: controller.binaryMessenger)

      let factory = FLNativeViewFactory(messenger: controller.binaryMessenger, channel: channel)
              self.registrar(forPlugin: "<plugin-name>")!.register(
                  factory,
                  withId: "<platform-view-type>")
      
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
