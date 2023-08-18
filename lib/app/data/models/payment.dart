class PaymentModel {
  int? paymentId;
  String? paymentDescription;

  PaymentModel({
    this.paymentId,
    this.paymentDescription,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        paymentId: json['paymentId'],
        paymentDescription: json['paymentDescription'],
      );
}
