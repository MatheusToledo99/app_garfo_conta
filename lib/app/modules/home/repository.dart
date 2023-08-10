import 'package:app_ordeus/app/data/providers/api.dart';

class HomeRepository {
  final Api _api;

  HomeRepository(this._api);

  Future<void> getAllBills() async {
    return await _api.getAllBills();
  }
}
