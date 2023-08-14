import 'package:app_ordeus/app/data/providers/api.dart';
import 'package:app_ordeus/app/data/services/auth/service.dart';
import 'package:app_ordeus/app/data/services/storage/service.dart';
import 'package:app_ordeus/app/core/theme/app_theme.dart';
import 'package:app_ordeus/app/routes/pages.dart';
import 'package:app_ordeus/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

void main() async {
  // setUrlStrategy(PathUrlStrategy());
  await GetStorage.init();

  Get.put<StorageService>(StorageService());
  Get.put<AuthService>(AuthService());
  Get.put<Api>(Api());

  Intl.defaultLocale = 'pt_BR';
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.login,
      theme: themeData,
      getPages: AppPages.pages,
      locale: const Locale('pt', 'BR'),
    ),
  );
}
