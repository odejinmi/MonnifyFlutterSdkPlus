import 'package:flutter/foundation.dart';
import 'package:monnify_flutter_sdk_plus/SubAccountDetails.dart';
import 'package:monnify_flutter_sdk_plus/PaymentMethod.dart';

class Transaction {
  double amount;
  String currencyCode;
  String customerName;
  String customerEmail;
  String paymentReference;
  String paymentDescription;
  Map<String, String> metaData;
  List<PaymentMethod> paymentMethods;
  List<SubAccountDetails> incomeSplitConfig;

  Transaction(this.amount, this.currencyCode, this.customerName,
      this.customerEmail, this.paymentReference, this.paymentDescription,
      {this.metaData = const {},
      this.paymentMethods = const [],
      this.incomeSplitConfig = const []});

  Map<String, dynamic> toMap() {
    var subAccountDetailsList = [];
    for (final subAccountDetails in incomeSplitConfig) {
      subAccountDetailsList.add(subAccountDetails.toMap());
    }

    var paymentMethodsList = [];
    for (final paymentMethod in paymentMethods) {
      paymentMethodsList.add(describeEnum(paymentMethod));
    }

    return {
      'amount': amount,
      'currencyCode': currencyCode,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'paymentReference': paymentReference,
      'paymentDescription': paymentDescription,
      'metaData': metaData,
      'paymentMethods': paymentMethodsList,
      'incomeSplitConfig': subAccountDetailsList,
    };
  }
}
