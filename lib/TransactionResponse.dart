class TransactionResponse {
  String paymentDate;
  double amountPayable;
  double amountPaid;
  String paymentMethod;
  String transactionStatus;
  String transactionReference;
  String paymentReference;

  TransactionResponse(
      this.paymentDate,
      this.amountPayable,
      this.amountPaid,
      this.paymentMethod,
      this.transactionStatus,
      this.transactionReference,
      this.paymentReference);

  TransactionResponse.fromMap(Map<String, dynamic> map)
      : paymentDate = map['paymentDate'],
        amountPayable = map['amountPayable'] ?? 0.0,
        amountPaid = map['amountPaid'] ?? 0.0,
        paymentMethod = map['paymentMethod'],
        transactionStatus = map['transactionStatus'],
        transactionReference = map['transactionReference'],
        paymentReference = map['paymentReference'];

  Map<String, dynamic> toMap() => {
        'paymentDate': paymentDate,
        'amountPayable': amountPayable,
        'amountPaid': amountPaid,
        'paymentMethod': paymentMethod,
        'transactionStatus': transactionStatus,
        'transactionReference': transactionReference,
        'paymentReference': paymentReference,
      };
}
