import 'package:app_ordeus/app/data/models/bill.dart';
import 'package:app_ordeus/app/data/models/payment.dart';
import 'package:app_ordeus/app/data/models/product.dart';

class OrderModel {
  int? orderId;
  BillModel? bill;
  PaymentModel? payment;
  double? orderValue;
  double? orderDiscount;
  String? orderObservation;
  String? orderResponsible;
  bool? orderOpen;
  List<ProductModel>? products;

  OrderModel({
    this.orderId,
    this.bill,
    this.payment,
    this.orderValue,
    this.orderDiscount,
    this.orderObservation,
    this.orderResponsible,
    this.orderOpen,
    this.products,
  });

  Map<String, dynamic> toJson() => {
        if (bill?.billId != null) 'billId': bill!.billId,
        if (payment?.paymentId != null) 'paymentId': payment!.paymentId,
        if (orderObservation != null) 'orderObservation': orderObservation,
        if (orderResponsible != null) 'orderResponsible': orderResponsible,
        if (products != null)
          'products': products!
              .map((product) => {'productId': product.productId})
              .toList(),
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderId: json['orderId'],
        bill: json['bill'] != null ? BillModel.fromJson(json['bill']) : null,
        payment: json['payment'] != null
            ? PaymentModel.fromJson(json['payment'])
            : null,
        orderValue: double.tryParse(json['orderValue']),
        orderDiscount: double.tryParse(json['orderDiscount']),
        orderObservation: json['orderObservation'],
        orderResponsible: json['orderResponsible'],
        orderOpen: json['orderOpen'],
        products: json['products'] != null
            ? List<ProductModel>.from(
                json['products']
                    .map((thisProduct) => ProductModel.fromJson(thisProduct)),
              )
            : null,
      );
}
