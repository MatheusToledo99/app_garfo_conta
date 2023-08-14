import 'package:app_ordeus/app/modules/auth/binding.dart';
import 'package:app_ordeus/app/modules/auth/page.dart';
import 'package:app_ordeus/app/modules/home/binding.dart';
import 'package:app_ordeus/app/modules/home/page.dart';
import 'package:get/get.dart';
import 'package:app_ordeus/app/routes/routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.home,
      binding: HomeBinding(),
      page: () => const HomePage(),
    ),
    GetPage(
      name: Routes.login,
      binding: AuthBinding(),
      page: () => const AuthPage(),
    ),
  ];
}
