// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_ordeus/app/data/models/establishment.dart';
import 'package:app_ordeus/app/data/models/user.dart';

class EmployeeModel {
  int? employeeId;
  UserModel? user;
  EstablishmentModel? establishment;

  EmployeeModel({
    this.employeeId,
    this.user,
    this.establishment,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        employeeId: json['employeeId'],
        user: UserModel.fromJson(json['user']),
        establishment: EstablishmentModel.fromJson(json['establishment']),
      );
}
