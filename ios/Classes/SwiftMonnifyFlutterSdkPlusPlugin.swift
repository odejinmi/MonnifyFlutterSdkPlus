import Flutter
import UIKit
import MonnifyiOSSDK

public class SwiftMonnifyFlutterSdkPlusPlugin: NSObject, FlutterPlugin {

    let ERROR_CODE_SDK_INITIALIZATION = "INIT_ERROR"
    let ERROR_CODE_PAYMENT_INITIALIZATION = "INIT_PAYMENT_ERROR"

    public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "monnify_flutter_sdk_plus", binaryMessenger: registrar.messenger())
    let instance = SwiftMonnifyFlutterSdkPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

   public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

         switch call.method {
         case "initialize":
             self.initialize(call, result)

         case "initializePayment":
             self.initializePayment(call, result)

         default:
             result(FlutterError(code: ERROR_CODE_SDK_INITIALIZATION,
                                 message: "Request not understood",
                                 details: nil))
         }
     }

     private func initialize(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

         if let dict = call.arguments as? [String: Any] {
             let apiKey = (dict["apiKey"] as? String) ?? ""
             let contractCode = (dict["contractCode"] as? String) ?? ""
             let applicationMode = (dict["applicationMode"] as? String) ?? "TEST"
             Monnify.shared.setApiKey(apiKey: apiKey)
             Monnify.shared.setContractCode(contractCode: contractCode)
             if applicationMode == "TEST" {
                 Monnify.shared.setApplicationMode(applicationMode: ApplicationMode.test)
             } else if applicationMode == "LIVE" {
                 Monnify.shared.setApplicationMode(applicationMode: ApplicationMode.live)
             }

             Monnify.shared.setLoggingEnabled(enabled: (applicationMode == "TEST"))

             result(true)
         }

         result(false)

     }

     private func initializePayment(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

         if let dict = call.arguments as? [String: Any] {

             let parameter = TransactionParameters(
                 amount: Decimal.init((dict["amount"] as? Double) ?? 0),
                 currencyCode: (dict["currencyCode"] as? String) ?? "NGN",
                 paymentReference: (dict["paymentReference"] as? String) ?? "",
                 customerEmail: (dict["customerEmail"] as? String) ?? "",
                 customerName: (dict["customerName"] as? String) ?? "",
                 customerMobileNumber: (dict["customerMobileNumber"] as? String) ?? "",
                 paymentDescription: (dict["paymentDescription"] as? String) ?? "",
                 incomeSplitConfig: extractIncomeSplitConfig(dict),
                 metaData: (dict["metaData"] as? [String: String]) ?? [:],
                 paymentMethods: extractPaymentMethods(dict),
                 tokeniseCard: false)

             if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {

                 Monnify.shared.initializePayment(
                     withTransactionParameters: parameter,
                     presentingViewController: rootViewController,
                     onTransactionSuccessful: { _response in
                         let response: [String: Any] = [
                             "transactionReference": _response.transactionReference as Any,
                             "transactionStatus": _response.transactionStatus.rawValue,
                             "paymentReference": _response.paymentReference as Any,
                             "paymentMethod": _response.paymentMethod?.rawValue as Any,
                             "amountPaid": _response.amountPaid as Any,
                             "amountPayable": _response.amountPayable as Any,
                         ]
                         result(response)
                 })

             }

         } else {
             result(FlutterError(
                 code: ERROR_CODE_PAYMENT_INITIALIZATION,
                 message: "Invalid input(s)",
                 details: nil))
         }


     }


     private func extractPaymentMethods(_ dict: [String: Any]) -> [PaymentMethod]? {

         var paymentMethods: [PaymentMethod]

         if dict["paymentMethods"] == nil {
             paymentMethods = []
         } else {
             let paymentMethodList = dict["paymentMethods"] as! [String]

             paymentMethods = paymentMethodList.map {
                 PaymentMethod(rawValue: $0)!
             }
         }

         return paymentMethods

     }

     private func extractIncomeSplitConfig(_ dict: [String: Any]) -> [SubAccountDetails]? {

         var incomeSplitConfig: [SubAccountDetails]

         if dict["incomeSplitConfig"] == nil {
             incomeSplitConfig = []
         } else {
             let incomeSplitConfigDictionary = dict["incomeSplitConfig"] as! [[String: Any]]

             incomeSplitConfig = incomeSplitConfigDictionary.map {
                 SubAccountDetails.init(subAccountCode: ($0["subAccountCode"] as? String) ?? "",
                                        feePercentage: $0["feePercentage"] as? Float,
                                        splitAmount: Decimal.init(($0["splitAmount"] as? Double) ?? 0),
                                        feeBearer: $0["feeBearer"] as? Bool)
             }
         }

         return incomeSplitConfig
     }


 }
