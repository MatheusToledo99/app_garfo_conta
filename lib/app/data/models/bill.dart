class BillModel {
  int? billId;
  // EstablishmentModel? establishment;
  String? billName;
  bool? billBusy;

  BillModel({
    this.billId,
    // this.establishment,
    this.billName,
    this.billBusy,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) => BillModel(
        billId: json['billId'],
        // establishment: EstablishmentModel.fromJson(json['establishment']),
        billName: json['billName'],
        billBusy: json['billBusy'],
      );
}
