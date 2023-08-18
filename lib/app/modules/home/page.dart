import 'package:app_ordeus/app/data/models/bill.dart';
import 'package:app_ordeus/app/modules/home/controller.dart';
import 'package:app_ordeus/app/routes/routes.dart';
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
      body: RefreshIndicator(
        onRefresh: () async => await controller.getAllBills(),
        child: Padding(
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
                          color: bill.billBusy!
                              ? Colors.red[400]
                              : Colors.green[400],
                          child: Center(
                            child: ListTile(
                              onTap: () => Get.toNamed(Routes.orderbill,
                                  arguments: {'bill': bill}),
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
      ),
    );
  }
}
