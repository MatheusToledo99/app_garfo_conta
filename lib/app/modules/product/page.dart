import 'package:app_ordeus/app/data/models/category.dart';
import 'package:app_ordeus/app/data/models/product.dart';
import 'package:app_ordeus/app/modules/product/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductPage extends GetView<ProductController> {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: Column(
        children: [
          for (CategoryModel category in controller.categories) ...[
            ListTile(
              title: Text(
                category.categoryName!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            for (ProductModel product in category.products!) ...[
              ListTile(
                onTap: () => controller.selectProduct(product),
                title: Text(product.productName!),
                subtitle: Text(product.productDescription ?? ''),
                trailing: Text(
                  'R\$${product.productPrice}',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
