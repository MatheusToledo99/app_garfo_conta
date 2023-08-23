import 'package:app_ordeus/app/data/models/establishment.dart';

class BillModel {
  int? billId;
  EstablishmentModel? establishment;
  String? billName;
  bool? billBusy;

  BillModel({
    this.billId,
    this.establishment,
    this.billName,
    this.billBusy,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) => BillModel(
        billId: json['billId'],
        establishment: json['establishment'] != null
            ? EstablishmentModel.fromJson(json['establishment'])
            : null,
        billName: json['billName'],
        billBusy: json['billBusy'],
      );

  Map<String, dynamic> toJson() => {
        'billId': billId,
        if (establishment?.establishmentId != null)
          'establishmentId': establishment!.establishmentId,
        if (billName != null) 'billName': billName,
        'billBusy': billBusy,
      };
}
