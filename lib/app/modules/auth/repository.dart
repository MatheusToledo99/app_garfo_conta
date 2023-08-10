import 'package:app_ordeus/app/data/models/user.dart';
import 'package:app_ordeus/app/data/providers/api.dart';

class AuthRepository {
  final Api _api;

  AuthRepository(this._api);

  Future<String> login(UserModel user) async {
    return await _api.login(user);
  }

  Future<UserModel> getUser() async {
    return await _api.getUser();
  }
}
