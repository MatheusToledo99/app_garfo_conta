import 'package:app_ordeus/app/data/models/category.dart';
import 'package:app_ordeus/app/data/models/unit.dart';

class ProductModel {
  int? productId;
  CategoryModel? category;
  UnitModel? unit;
  String? productName;
  double? productPrice;
  String? productImage;
  String? productDescription;
  bool? productBlocked;

  ProductModel({
    this.productId,
    this.category,
    this.unit,
    this.productName,
    this.productPrice,
    this.productImage,
    this.productDescription,
    this.productBlocked,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productId: json['productId'],
        category: json['category'] != null
            ? CategoryModel.fromJson(json['category'])
            : null,
        unit: json['unit'] != null ? UnitModel.fromJson(json['unit']) : null,
        productName: json['productName'],
        productPrice: double.tryParse(json['productPrice']),
        productImage: json['productImage'],
        productDescription: json['productDescription'],
        productBlocked: json['productBlocked'],
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'category': null,
        'unit': null,
        'productName': productName,
        'productPrice': productPrice,
        'productImage': productImage,
        'productDescription': productDescription,
        'productBlocked': productBlocked,
      };
}
