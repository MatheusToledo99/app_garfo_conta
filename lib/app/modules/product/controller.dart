import 'package:app_ordeus/app/data/models/category.dart';
import 'package:app_ordeus/app/data/models/product.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  ProductController();

  late List<CategoryModel> categories;

  @override
  void onInit() {
    categories = Get.arguments['categories'];
    super.onInit();
  }

  void selectProduct(ProductModel product) {
    try {
      Get.back(result: product);
    } catch (e) {
      //
    }
  }
}
