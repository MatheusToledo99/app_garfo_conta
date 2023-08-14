import 'package:app_ordeus/app/data/models/establishment.dart';
import 'package:app_ordeus/app/data/models/user.dart';
import 'package:app_ordeus/app/data/services/storage/service.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final _storageService = Get.find<StorageService>();
  final userLogado = Rxn<UserModel>();
  final establishment = Rxn<EstablishmentModel>();

  void logout() async {
    await _storageService.removeToken();
  }
}
