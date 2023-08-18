import 'package:app_ordeus/app/data/models/category.dart';
import 'package:app_ordeus/app/data/models/order.dart';
import 'package:app_ordeus/app/data/models/product.dart';
import 'package:app_ordeus/app/data/providers/api.dart';

class OrderRepository {
  final Api _api;

  OrderRepository(this._api);
  Future<OrderModel> getOrderByBill({required int billId}) async {
    return await _api.getOrderByBill(billId: billId);
  }

  Future<List<CategoryModel>> getAllCategories() async {
    return await _api.getAllCategories();
  }

  Future<void> postOrder(OrderModel order) async {
    await _api.postOrder(order);
  }

  Future<void> addProductsInOrder(
      {required List<ProductModel> products, required orderId}) async {
    await _api.addProducts(products: products, orderId: orderId);
  }

  Future<void> invoiceOrder({required OrderModel order}) async {
    await _api.invoiceOrder(order: order);
  }

  Future<void> deleteProductInOrder(
      {required int orderId, required int productId}) async {
    await _api.deleteProduct(orderId: orderId, productId: productId);
  }
}
