class UserModel {
  int? userId;
  String? userCpfCnpj;
  String? userPassword;
  String? userName;
  bool? userBlocked;
  String? userEmail;
  String? userType;
  String? userToken;

  UserModel({
    this.userId,
    this.userCpfCnpj,
    this.userPassword,
    this.userName,
    this.userBlocked,
    this.userEmail,
    this.userType,
    this.userToken,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userCpfCnpj': userCpfCnpj,
        'userPassword': userPassword,
        'userName': userName,
        'userBlocked': userBlocked,
        'userEmail': userEmail,
        'userType': userType,
        'userToken': userToken,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json['userId'],
        userCpfCnpj: json['userCpfCnpj'],
        userPassword: json['userPassword'],
        userName: json['userName'],
        userBlocked: json['userBlocked'],
        userEmail: json['userEmail'],
        userType: json['userType'],
        userToken: json['userToken'],
      );
}
