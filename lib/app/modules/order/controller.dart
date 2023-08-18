import 'package:app_ordeus/app/data/models/bill.dart';
import 'package:app_ordeus/app/data/models/category.dart';
import 'package:app_ordeus/app/data/models/order.dart';
import 'package:app_ordeus/app/data/models/product.dart';
import 'package:app_ordeus/app/modules/home/controller.dart';
import 'package:app_ordeus/app/modules/order/repository.dart';
import 'package:app_ordeus/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final OrderRepository _repository;
  OrderController(this._repository);

  final title = 'Comanda sem pedido'.obs;
  late BillModel bill;
  final productsMemory = <ProductModel>[].obs;
  final clientNameController = TextEditingController();
  final orderObservationController = TextEditingController();
  final currentOrder = Rxn<OrderModel>();
  RxDouble orderPrice = 0.0.obs;
  final _homeController = Get.find<HomeController>();
  bool canfaturar = false;

  //categories será usada na próxima página
  final categories = <CategoryModel>[].obs;

  @override
  void onInit() async {
    bill = Get.arguments['bill'];
    await getOrder(billId: bill.billId);
    await getCategories();
    super.onInit();
  }

  Future<void> getOrder({required billId}) async {
    try {
      final order = await _repository.getOrderByBill(billId: billId);
      title.value = "Pedido: nº ${order.orderId}";
      currentOrder.value = order;

      if (currentOrder.value != null) implementsDatas(currentOrder.value!);
    } catch (error) {
      if (error is Map<String, dynamic> && error['status-code'] == 204) {
        // Está vazio
      } else {
        // Erro
      }
    } finally {
      calctotalPrice();
    }
  }

  Future<void> getCategories() async {
    try {
      categories.value = await _repository.getAllCategories();
    } catch (e) {
      //
    }
  }

  Future<void> getback() async {
    await _homeController.getAllBills();

    if (Get.isRegistered<OrderController>()) Get.delete<OrderController>();
  }

  void implementsDatas(OrderModel order) {
    clientNameController.text = order.orderResponsible ?? '';
    orderObservationController.text = order.orderObservation ?? '';
    canfaturar = true;
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
      if (productsMemory.isEmpty) throw 'Lista de Produtos vazia';

      //
      final order = OrderModel(
        bill: bill,
        orderResponsible: clientNameController.text.isEmpty
            ? null
            : clientNameController.text,
        orderObservation: orderObservationController.text.isEmpty
            ? null
            : orderObservationController.text,
        products: productsMemory,
      );

      currentOrder.value == null
          ? await _repository.postOrder(order)
          : await _repository.addProductsInOrder(
              products: productsMemory,
              orderId: currentOrder.value!.orderId,
            );

      Get.back();
    } catch (e) {
      // print('erro apresentado -> $e');
    }
  }

  void invoiceOrder() async {
    try {
      if (currentOrder.value == null) {
        throw 'Não foi possível faturar este pedido';
      } else if (currentOrder.value!.products!.isEmpty) {
        // Excluo este pedido
      } else {
        await _repository.invoiceOrder(order: currentOrder.value!);
      }
      Get.back();
    } catch (e) {
      //
    }
  }
}
