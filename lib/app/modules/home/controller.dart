import 'package:app_ordeus/app/data/models/bill.dart';
import 'package:app_ordeus/app/data/services/auth/service.dart';
import 'package:app_ordeus/app/modules/home/repository.dart';
import 'package:app_ordeus/app/routes/routes.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with StateMixin<List<BillModel>> {
  final _authService = Get.find<AuthService>();
  final HomeRepository _repository;
  HomeController(this._repository);

  @override
  void onInit() {
    getAllBills();
    super.onInit();
  }

  Future<void> getAllBills() async {
    try {
      final bills = await _repository.getAllBills();
      if (bills.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(bills, status: RxStatus.success());
      }
    } catch (e) {
      //
    }
  }

  void logout() {
    _authService.logout();
    Get.offAllNamed(Routes.login);
  }
}
