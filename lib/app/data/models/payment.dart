class PaymentModel {
  int paymentId;
  String paymentDescription;

  PaymentModel({
    required this.paymentId,
    required this.paymentDescription,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        paymentId: json['paymentId'] as int,
        paymentDescription: json['paymentDescription'] as String,
      );
}
