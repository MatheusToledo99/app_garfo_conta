import 'package:app_ordeus/app/modules/auth/binding.dart';
import 'package:app_ordeus/app/modules/auth/page.dart';
import 'package:app_ordeus/app/modules/home/binding.dart';
import 'package:app_ordeus/app/modules/home/page.dart';
import 'package:app_ordeus/app/modules/order/binding.dart';
import 'package:app_ordeus/app/modules/order/page.dart';
import 'package:app_ordeus/app/modules/product/binding.dart';
import 'package:app_ordeus/app/modules/product/page.dart';
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
    GetPage(
      name: Routes.orderbill,
      binding: OrderBinding(),
      page: () => OrderPage(),
    ),
    GetPage(
      name: Routes.products,
      binding: ProductBinding(),
      page: () => const ProductPage(),
    ),
  ];
}
