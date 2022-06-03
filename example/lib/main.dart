import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:monnify_flutter_sdk_plus/monnify_flutter_sdk_plus.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late BuildContext mContext;

  @override
  void initState() {
    super.initState();
    initializeSdk();
  }

  Future<void> initializeSdk() async {
    try {
      if (await MonnifyFlutterSdkPlus.initialize(
          'MK_TEST_G9YG93QQJA', '4551641593', ApplicationMode.TEST)) {
        _showToast("SDK initialized!");
      }
    } on PlatformException catch (e, s) {
      print("Error initializing sdk");
      print(e);
      print(s);

      _showToast("Failed to init sdk!");
    }
  }

  Future<void> initPayment() async {
    TransactionResponse transactionResponse;

    try {
      transactionResponse =
          await MonnifyFlutterSdkPlus.initializePayment(Transaction(
        2000.0,
        "NGN",
        "Customer Name",
        "mail.cus@tome.er",
        getRandomString(15),
        "Description of payment",
        metaData: {"ip": "196.168.45.22", "device": "mobile"},
        paymentMethods: [PaymentMethod.CARD, PaymentMethod.ACCOUNT_TRANSFER],
        /*incomeSplitConfig: [SubAccountDetails("MFY_SUB_319452883968", 10.5, 500, true),
                SubAccountDetails("MFY_SUB_259811283666", 10.5, 1000, false)]*/
      ));

      _showToast(
          "${transactionResponse.transactionStatus}\n${transactionResponse.paymentReference}\n${transactionResponse.transactionReference}\n${transactionResponse.amountPaid}\n${transactionResponse.amountPayable}\n${transactionResponse.paymentDate}\n${transactionResponse.paymentMethod}");
    } on PlatformException catch (e, s) {
      print("Error initializing payment");
      print(e);
      print(s);

      _showToast("Failed to init payment!");
    }
  }

  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  void _showToast(String message) {
    final scaffold = ScaffoldMessenger.of(mContext);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'CLOSE', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Monnify Plugin Sample'),
        ),
        body: Builder(
          builder: (context) {
            mContext = context;
            return Center(
              child: TextButton(
                child: const Text("PAY"),
                onPressed: () => initPayment(),
              ),
            );
          },
        ),
      ),
    );
  }
}
