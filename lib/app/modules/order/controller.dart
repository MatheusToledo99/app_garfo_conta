import 'package:app_ordeus/app/data/models/bill.dart';
import 'package:app_ordeus/app/data/models/category.dart';
import 'package:app_ordeus/app/data/models/order.dart';
import 'package:app_ordeus/app/data/models/payment.dart';
import 'package:app_ordeus/app/data/models/product.dart';
import 'package:app_ordeus/app/modules/home/controller.dart';
import 'package:app_ordeus/app/modules/order/page.dart';
import 'package:app_ordeus/app/modules/order/repository.dart';
import 'package:app_ordeus/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final OrderRepository _repository;
  OrderController(this._repository);

  RxBool showDialog = false.obs;

  //instancias
  final _homeController = Get.find<HomeController>();

  //objetos
  late BillModel bill;
  final productsMemory = <ProductModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final payments = <PaymentModel>[].obs;
  final currentOrder = Rxn<OrderModel>();

  //variaveis
  final orderPrice = 0.0.obs;
  final title = ''.obs;
  Rxn<PaymentModel> payment = Rxn<PaymentModel>();

  //controllers
  final orderResponsibleController = TextEditingController();
  final orderObservationController = TextEditingController();

  @override
  void onInit() async {
    bill = Get.arguments['bill'];
    super.onInit();
  }

  Future<void> initializeData() async {
    await getOrder(billId: bill.billId);
    await getCategoriesAndPayments();
  }

  Future<void> getOrder({required billId}) async {
    try {
      final order = await _repository.getOrderByBill(billId: billId);
      title.value = "${bill.billName} | Pedido: nº ${order.orderId}";
      currentOrder.value = order;

      if (currentOrder.value != null) implementsDatas(currentOrder.value!);
    } catch (error) {
      if (error is Map<String, dynamic> && error['status-code'] == 204) {
        // Comanda não tem pedido em aberto
        title.value = '${bill.billName} | Sem pedido';
      } else {
        // Erro
      }
    } finally {
      calctotalPrice();
    }
  }

  Future<void> getCategoriesAndPayments() async {
    try {
      categories.value = await _repository.getAllCategories();
      payments.value = await _repository.getPayments();
    } catch (e) {
      //
    }
  }

  Future<void> getback() async {
    await _homeController.getAllBills();
    if (Get.isRegistered<OrderController>()) Get.delete<OrderController>();
  }

  Future<bool> showDialogPayment(BuildContext context) async {
    return await Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        content: const Text(
          'Escolha a forma de pagamento',
          textAlign: TextAlign.justify,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        actions: [
          Obx(
            () => Center(
              child: DropdownButton(
                value: payment.value,
                items: [
                  for (var value in payments)
                    DropdownMenuItem(
                      value: value,
                      child: Text(value.paymentDescription),
                    ),
                ],
                onChanged: (value) {
                  payment.value = value!;
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Voltar')),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Confirmar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> updateOrderInformation() async {
    try {
      final order = OrderModel(
        orderId: currentOrder.value!.orderId,
        orderResponsible: orderResponsibleController.text.isEmpty
            ? null
            : orderResponsibleController.text,
        orderObservation: orderObservationController.text.isEmpty
            ? null
            : orderObservationController.text,
        payment: payment.value,
      );
      await _repository.updateOrder(order: order);
    } catch (e) {
      //
    }
  }

  void choiceOperation(BuildContext context, {required Operacoes operacao}) {
    switch (operacao) {
      case Operacoes.faturar:
        invoiceOrder(context);

      case Operacoes.busy:
        updateBillBusy();

      default:
        return;
    }
  }

  void implementsDatas(OrderModel order) {
    orderResponsibleController.text = order.orderResponsible ?? '';
    orderObservationController.text = order.orderObservation ?? '';
    if (order.products == null) currentOrder.value!.products = [];
  }

  void choiceProduct() async {
    try {
      if (categories.isEmpty) return;

      Get.focusScope?.unfocus();

      var product = await Get.toNamed(Routes.products,
          arguments: {'categories': categories});

      productsMemory.add(product);

      calctotalPrice();
    } catch (e) {
      //
    }
  }

  void calctotalPrice() {
    try {
      double total = 0;

      //Calculo do total já enviado
      if (currentOrder.value != null) {
        for (ProductModel product in currentOrder.value!.products!) {
          total = total + product.productPrice!;
        }
      }

      //Calculo do total ainda não enviado
      for (ProductModel product in productsMemory) {
        total = total + product.productPrice!;
      }

      orderPrice.value = total;
    } catch (e) {
      //
    }
  }

  void removeProduct(ProductModel product) async {
    try {
      if (currentOrder.value != null &&
          currentOrder.value!.products!.contains(product)) {
        //

        await _repository.deleteProductInOrder(
          orderId: currentOrder.value!.orderId!,
          productId: product.productId!,
        );

        currentOrder.value!.products!.remove(product);
        currentOrder.refresh();
      } else {
        productsMemory.remove(product);
        productsMemory.refresh();
      }
      calctotalPrice();
    } catch (error) {
      //
    }
  }

  void sendProduction() async {
    try {
      //
      final order = OrderModel(
        bill: bill,
        orderResponsible: orderResponsibleController.text.isEmpty
            ? null
            : orderResponsibleController.text,
        orderObservation: orderObservationController.text.isEmpty
            ? null
            : orderObservationController.text,
        products: productsMemory,
      );

      bool hasAlteration = (currentOrder.value?.orderResponsible?.trim() !=
              orderResponsibleController.text.trim() ||
          currentOrder.value?.orderObservation?.trim() !=
              orderObservationController.text.trim());

      if (currentOrder.value != null) {
        if (hasAlteration) await updateOrderInformation();

        if (productsMemory.isNotEmpty) {
          await _repository.addProductsInOrder(
            products: productsMemory,
            orderId: currentOrder.value!.orderId,
          );
        }
      } else {
        productsMemory.isEmpty
            ? throw 'Lista de Produtos vazia'
            : await _repository.postOrder(order);
      }
    } finally {
      Get.back();
    }
  }

  void invoiceOrder(BuildContext context) async {
    try {
      if (currentOrder.value == null) {
        throw 'Não foi possível faturar este pedido';
      }

      if (currentOrder.value!.products!.isEmpty) {
        // Excluo este pedido
        await _repository.deleteOrder(order: currentOrder.value!);
        updateBillBusy();
        Get.back();
      } else {
        //devo exibir um dialog perguntando a forma de pagamento e atualizar
        if (await showDialogPayment(context) && payment.value != null) {
          await updateOrderInformation();
          await _repository.invoiceOrder(order: currentOrder.value!);
          Get.back();
        }
        return;
      }
    } catch (e) {
      //
    }
  }

  void updateBillBusy() async {
    try {
      final billUpdate = BillModel(
        billId: bill.billId,
        billBusy: bill.billBusy! ? false : true,
      );

      await _repository.updateBill(bill: billUpdate);
    } catch (error) {
      //
    } finally {
      Get.back();
    }
  }
}
