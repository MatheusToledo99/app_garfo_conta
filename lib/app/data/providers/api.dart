import 'package:app_ordeus/app/data/models/bill.dart';
import 'package:app_ordeus/app/data/models/category.dart';
import 'package:app_ordeus/app/data/models/employee.dart';
import 'package:app_ordeus/app/data/models/establishment.dart';
import 'package:app_ordeus/app/data/models/order.dart';
import 'package:app_ordeus/app/data/models/payment.dart';
import 'package:app_ordeus/app/data/models/product.dart';
import 'package:app_ordeus/app/data/models/user.dart';
import 'package:app_ordeus/app/data/services/auth/service.dart';
import 'package:app_ordeus/app/data/services/storage/service.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

class Api extends GetConnect {
  final _storageService = Get.find<StorageService>();
  final _authService = Get.find<AuthService>();

  @override
  void onInit() {
    httpClient.baseUrl = 'http://192.168.1.73:3333/api/v1/';

    httpClient.addRequestModifier((Request request) {
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';

      return request;
    });

    httpClient.addAuthenticator((Request request) {
      final token = _storageService.token;

      final headers = {'Authorization': 'Bearer $token'};

      request.headers.addAll(headers);

      return request;
    });

    super.onInit();
  }

  Future<String> login(UserModel user) async {
    String token;

    final result = _errorHandler(await post('login', user.toJson()));
    token = result.body['message']['token'];

    return token;
  }

  Future<dynamic> getUser() async {
    final result = _errorHandler(await get('auth/me'));

    return result.body['message']['user']['userType'] == 'ESTABELECIMENTO'
        ? EstablishmentModel.fromJson(result.body['message'])
        : EmployeeModel.fromJson(result.body['message']);
  }

  Future<List<BillModel>> getAllBills() async {
    int establishementId = _authService.establishment.value!.establishmentId!;

    final result = _errorHandler(await get('bill/all/$establishementId'));

    final List<BillModel> bills = [];

    for (var bill in result.body['message']) {
      bills.add(BillModel.fromJson(bill));
    }

    return bills;
  }

  Future<OrderModel> getOrderByBill({required int billId}) async {
    final result = _errorHandler(await get('order/bill/$billId'));

    if (result.statusCode == 204) {
      throw {
        'status-code': 204,
        'message': "Não há nenhum pedido em aberto para esta comanda"
      };
    }

    return OrderModel.fromJson(result.body);
  }

  Future<List<CategoryModel>> getAllCategories() async {
    int establishementId = _authService.establishment.value!.establishmentId!;
    final result = _errorHandler(await get("category/all/$establishementId"));

    List<CategoryModel> categories = [];
    for (var category in result.body['message']) {
      categories.add(CategoryModel.fromJson(category));
    }
    return categories;
  }

  Future<List<PaymentModel>> getPayments() async {
    final result = _errorHandler(await get("payment"));

    List<PaymentModel> payments = [];
    for (Map<String, dynamic> payment in result.body['message']) {
      payments.add(PaymentModel.fromJson(payment));
    }

    return payments;
  }

  Future<void> postOrder(OrderModel order) async {
    _errorHandler(await post('order', order.toJson()));
  }

  Future<void> addProducts(
      {required List<ProductModel> products, required int orderId}) async {
    final List<Map<String, dynamic>> listProductsJson = [];

    for (var product in products) {
      listProductsJson.add({'productId': product.productId});
    }

    final Map<String, dynamic> productsJson = {"products": listProductsJson};

    _errorHandler(await post('order/$orderId/product', productsJson));
  }

  Future<void> invoiceOrder({required OrderModel order}) async {
    _errorHandler(await post('order/${order.orderId}/invoice', null));
  }

  Future<void> deleteProduct(
      {required int orderId, required int productId}) async {
    _errorHandler(await delete('order/$orderId/product/$productId'));
  }

  Future<void> updateBill({required BillModel bill}) async {
    _errorHandler(await patch('bill/${bill.billId}', bill.toJson()));
  }

  Future<void> deleteOrder({required OrderModel order}) async {
    _errorHandler(await delete('order/${order.orderId}'));
  }

  Future<void> updateOrder({required OrderModel order}) async {
    _errorHandler(await patch('order/${order.orderId}', order.toJson()));
  }

  Response<dynamic> _errorHandler(Response response) {
    // print('Aqui -> ${response.bodyString}');
    switch (response.statusCode) {
      case 200:
      case 202:
      case 204:
        return response;
      default:
        throw (response.body['errors'][0]['message']).toString();
    }
  }
}
