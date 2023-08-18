// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_ordeus/app/data/models/establishment.dart';
import 'package:app_ordeus/app/data/models/product.dart';

class CategoryModel {
  int? categoryId;
  EstablishmentModel? establishment;
  String? categoryName;
  String? categoryDescription;
  List<ProductModel>? products;

  CategoryModel({
    this.categoryId,
    this.establishment,
    this.categoryName,
    this.categoryDescription,
    this.products,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categoryId: json['categoryId'],
        establishment: json['establishment'] != null
            ? EstablishmentModel.fromJson(json['establishment'])
            : null,
        categoryName: json['categoryName'],
        categoryDescription: json['categoryDescription'],
        products: json['products'] != null
            ? List<ProductModel>.from(
                json['products']
                    .map((thisProduct) => ProductModel.fromJson(thisProduct)),
              )
            : null,
      );
}
