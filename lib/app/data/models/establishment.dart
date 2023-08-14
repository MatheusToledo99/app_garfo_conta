import 'package:app_ordeus/app/data/models/user.dart';

class EstablishmentModel {
  int? establishmentId;
  String? establishmentFantasy;
  UserModel? user;

  EstablishmentModel({
    this.establishmentId,
    this.establishmentFantasy,
    this.user,
  });

  factory EstablishmentModel.fromJson(Map<String, dynamic> json) =>
      EstablishmentModel(
        establishmentId: json['establishmentId'],
        establishmentFantasy: json['establishmentFantasy'],
        user: UserModel.fromJson(json['user']),
      );
}
