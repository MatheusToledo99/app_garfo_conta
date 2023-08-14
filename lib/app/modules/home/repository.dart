import 'package:app_ordeus/app/data/models/bill.dart';
import 'package:app_ordeus/app/data/providers/api.dart';

class HomeRepository {
  final Api _api;

  HomeRepository(this._api);

  Future<List<BillModel>> getAllBills() async {
    return await _api.getAllBills();
  }
}
