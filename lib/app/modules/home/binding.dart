import 'package:app_ordeus/app/data/providers/api.dart';
import 'package:app_ordeus/app/modules/home/controller.dart';
import 'package:app_ordeus/app/modules/home/repository.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
        () => HomeController(HomeRepository(Get.find<Api>())));
  }
}
