import 'package:app_ordeus/app/data/models/user.dart';
import 'package:app_ordeus/app/data/services/storage/service.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  Rxn<UserModel> user = Rxn<UserModel>();
  final _storageService = Get.find<StorageService>();

  void logout() async {
    await _storageService.removeToken();
  }
}
