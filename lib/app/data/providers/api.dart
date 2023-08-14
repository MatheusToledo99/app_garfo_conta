import 'package:app_ordeus/app/data/models/bill.dart';
import 'package:app_ordeus/app/data/models/employee.dart';
import 'package:app_ordeus/app/data/models/establishment.dart';
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

  Response<dynamic> _errorHandler(Response response) {
    print('Aqui -> ${response.bodyString}');
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
