// ignore_for_file: avoid_print

import 'package:app_ordeus/app/data/models/user.dart';
import 'package:app_ordeus/app/data/services/auth/service.dart';
import 'package:app_ordeus/app/data/services/storage/service.dart';
import 'package:app_ordeus/app/modules/auth/repository.dart';
import 'package:app_ordeus/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthRepository _repository;
  final _storageService = Get.find<StorageService>();
  final _authService = Get.find<AuthService>();

  AuthController(this._repository);

  final TextEditingController cpfCnpjController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    if (_storageService.token != null) {
      getUser();
    }
    super.onInit();
  }

  Future<void> getUser() async {
    try {
      final userDynamic = await _repository.getUser();

      _authService.userLogado.value = userDynamic.user;

      _authService.userLogado.value!.userType == 'ESTABELECIMENTO'
          ? _authService.establishment.value = userDynamic
          : _authService.establishment.value = userDynamic.establishment;

      Get.offAllNamed(Routes.home);
      //Navegar para a proxima página
    } catch (e) {
      print(e);
      _authService.logout();
    }
  }

  Future<void> login() async {
    try {
      final user = UserModel(
        userCpfCnpj: cpfCnpjController.text,
        userPassword: passwordController.text,
      );

      final token = await _repository.login(user);
      _storageService.saveToken(token);
      getUser();
    } catch (e) {
      print(e);
    }
  }
}
