import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:monnify_flutter_sdk_plus/Transaction.dart';
import 'package:monnify_flutter_sdk_plus/TransactionResponse.dart';
import 'package:monnify_flutter_sdk_plus/ApplicationMode.dart';

import 'monnify_flutter_sdk_plus_platform_interface.dart';

export 'package:monnify_flutter_sdk_plus/Transaction.dart';
export 'package:monnify_flutter_sdk_plus/TransactionResponse.dart';
export 'package:monnify_flutter_sdk_plus/SubAccountDetails.dart';
export 'package:monnify_flutter_sdk_plus/PaymentMethod.dart';
export 'package:monnify_flutter_sdk_plus/ApplicationMode.dart';

class MonnifyFlutterSdkPlus {
  static const MethodChannel _channel =
      const MethodChannel('monnify_flutter_sdk_plus');
  Future<String?> getPlatformVersion() {
    return MonnifyFlutterSdkPlusPlatform.instance.getPlatformVersion();
  }
  static Future<bool> initialize(String apiKey, String contractCode,
      ApplicationMode applicationMode) async {
    Map<String, String> args = {
      "apiKey": apiKey,
      "contractCode": contractCode,
      "applicationMode": describeEnum(applicationMode)
    };

    return _channel
        .invokeMethod("initialize", args)
        .then<bool>((dynamic result) => result);
  }

  static Future<TransactionResponse> initializePayment(
      Transaction transaction) async {
    return _channel
        .invokeMethod("initializePayment", transaction.toMap())
        .then<TransactionResponse>((dynamic result) =>
            TransactionResponse.fromMap(new Map<String, dynamic>.from(result)));
  }
}
