import 'package:app_ordeus/app/data/models/bill.dart';
import 'package:app_ordeus/app/modules/home/controller.dart';
import 'package:app_ordeus/app/widgets/custom_textformfield.dart';
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
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
        child: controller.obx(
          (bills) => Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextField(
                    label: 'Pesquise aqui a sua comanda...',
                    icon: Icons.search),
              ),
              Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: [
                    for (BillModel bill in bills!)
                      Card(
                        color: bill.billBusy! ? Colors.redAccent : Colors.white,
                        child: Center(
                          child: ListTile(
                            title: Text(bill.billName!),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
