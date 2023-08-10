import 'package:app_ordeus/app/data/models/user.dart';
import 'package:app_ordeus/app/data/services/storage/service.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

class Api extends GetConnect {
  final _storageService = Get.find<StorageService>();

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

  Future<UserModel> getUser() async {
    final result = _errorHandler(await get('auth/me'));

    return UserModel.fromJson(result.body['message']);
  }

  Future<void> getAllBills() async {
    // final result = _errorHandler(await get('bill/all/1'));
  }

  Response<dynamic> _errorHandler(Response response) {
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
