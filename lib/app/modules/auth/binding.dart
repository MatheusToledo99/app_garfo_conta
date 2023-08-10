import 'package:app_ordeus/app/data/providers/api.dart';
import 'package:app_ordeus/app/modules/auth/controller.dart';
import 'package:app_ordeus/app/modules/auth/repository.dart';
import 'package:get/get.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(
        AuthRepository(Get.find<Api>()),
      ),
    );
  }
}
