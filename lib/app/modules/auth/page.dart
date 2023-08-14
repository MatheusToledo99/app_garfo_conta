import 'package:app_ordeus/app/modules/auth/controller.dart';
import 'package:app_ordeus/app/widgets/custom_appbar.dart';
import 'package:app_ordeus/app/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        message: 'Garfo & Conta',
        textHeight: Get.height * 0.04,
        color: Colors.white,
        height: Get.height * 0.15,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              label: 'cpf/cnpj',
              icon: Icons.person,
              controller: controller.cpfCnpjController,
              textInputType: TextInputType.number,
            ),
            CustomTextField(
              icon: Icons.email,
              label: 'senha',
              isPassword: true,
              controller: controller.passwordController,
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.login),
              onPressed: () => controller.login(),
              label: const Text('entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
