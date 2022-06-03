class SubAccountDetails {
  String subAccountCode;
  double feePercentage;
  double splitAmount;
  bool feeBearer;

  SubAccountDetails(this.subAccountCode, this.feePercentage, this.splitAmount,
      this.feeBearer);

  SubAccountDetails.fromMap(Map<String, dynamic> map)
      : subAccountCode = map['subAccountCode'],
        feePercentage = map['feePercentage'],
        splitAmount = map['splitAmount'],
        feeBearer = map['feeBearer'];

  Map<String, dynamic> toMap() => {
        'subAccountCode': subAccountCode,
        'feePercentage': feePercentage,
        'splitAmount': splitAmount,
        'feeBearer': feeBearer,
      };
}
