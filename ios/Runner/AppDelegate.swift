import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "bank_wallet_card", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
        switch call.method {
        case "configureHttp":
            if let args = call.arguments as? [String: String],
               let baseUrl = args["baseUrl"],
               let token = args["token"] {
                BankWalletCard.shared.configureHttp(baseUrl: baseUrl, token: token)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Base URL or Token is missing", details: nil))
            }
        case "addPaymentCard":
            if let args = call.arguments as? [String: String],
               let cardholderName = args["cardholderName"],
               let primaryAccountSuffix = args["primaryAccountSuffix"],
               let customerId = args["customerId"],
               let rootViewController = controller as? UIViewController {
                BankWalletCard.shared.startAddPaymentPass(cardholderName: cardholderName, primaryAccountSuffix: primaryAccountSuffix, _customerId: customerId, result: result, viewController: rootViewController)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Cardholder Name or Primary Account Suffix is missing", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
