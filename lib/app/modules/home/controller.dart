// ignore_for_file: avoid_print

import 'package:app_ordeus/app/data/services/auth/service.dart';
import 'package:app_ordeus/app/modules/home/repository.dart';
import 'package:app_ordeus/routes/routes.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final _authService = Get.find<AuthService>();
  final HomeRepository _repository;
  HomeController(this._repository);

  @override
  void onInit() {
    print('iniciou');
    super.onInit();
  }

  Future<void> getAllBills() async {
    try {
      await _repository.getAllBills();
    } catch (e) {
      print(e);
    }
  }

  void logout() {
    _authService.logout();
    Get.offAllNamed(Routes.login);
  }
}
