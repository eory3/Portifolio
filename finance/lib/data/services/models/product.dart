// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:finance/domain/models/product.dart';

class Product extends IProduct {
  Product({
    required super.id,
    required super.name,
    required super.price,
    required super.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'image': image,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as double,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
