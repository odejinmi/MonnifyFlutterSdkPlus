# monnify_flutter_sdk_plus

Flutter plugin for Monnify SDK

[![pub package](https://img.shields.io/pub/v/monnify_flutter_sdk.svg)](https://pub.dartlang.org/packages/monnify_flutter_sdk_plus)

## Getting Started
To use this plugin, add `monnify_flutter_sdk_plus` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## How to use
This plugin exposes two APIs:

### 1. Initialize

Initialize the plugin. This should be done once, preferably in the `initState` of your widget.

``` dart
import 'package:monnify_flutter_sdk_plus/monnify_flutter_sdk_plus.dart';

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    MonnifyFlutterSdkPlus.initialize(
              'YOUR_API_KEY', 
              'CONTRACTCODE', 
              ApplicationMode.TEST
    )
  }
}
```

### 2. Initialize Payment

Create an object of the Transaction class and pass it to the initializePayment function

``` dart
Future<void> initPayment() async {
    TransactionResponse transactionResponse =
          await MonnifyFlutterSdkPlus.initializePayment(Transaction(
              2000,
              "NGN",
              "Customer Name",
              "mail.cus@tome.er",
              "PAYMENT_REF",
              "Description of payment",
              metaData: {
                "ip": "196.168.45.22",
                "device": "mobile_flutter"
                // any other info
              },
              paymentMethods: [PaymentMethod.CARD, PaymentMethod.ACCOUNT_TRANSFER],
              incomeSplitConfig: [
                SubAccountDetails("MFY_SUB_319452883968", 10.5, 500, true),
                SubAccountDetails("MFY_SUB_259811283666", 10.5, 1000, false)]
          )
    );
}
```

Optional params:
**Payment Methods** specify transaction-level payment methods.
**Sub-Accounts** in incomeSplitConfig are accounts that will receive settlement for the particular transaction being initialized.
**MetaData** is map with single depth for any extra information you want to pass along with the transaction.

The TransactionResponse class received after sdk is closed contains the below fields

```dart
String paymentDate;
double amountPayable;
double amountPaid;
String paymentMethod;
String transactionStatus;
String transactionReference;
String paymentReference;
```

## Need more information?
For further info about Monnify's mobile SDKs, including transaction status types,
see the documentations for the
[Android](https://teamapt.atlassian.net/wiki/spaces/MON/pages/213909311/Monnify+Android+SDK) and
[iOS](https://teamapt.atlassian.net/wiki/spaces/MON/pages/213909672/Monnify+iOS+SDK) SDKs# monnify_flutter_sdk_plus
# MonnifyFlutterSdkPlus
