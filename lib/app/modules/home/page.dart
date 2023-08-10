import 'package:app_ordeus/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Operacoes {
  logout;
}

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comandas'),
        actions: [
          PopupMenuButton<Operacoes>(
            onSelected: (value) => controller.logout(),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Operacoes.logout,
                child: Text('Logout'),
              ),
            ],
          )
        ],
      ),
      body: const Column(
        children: [
          Text('data'),
          Text('data2'),
        ],
      ),
    );
  }
}
