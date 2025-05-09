import 'dart:convert';

import 'package:finance/domain/models/transaction.dart';

class TransactionModel extends ITransaction {
  TransactionModel({
    super.id,
    required super.value,
    required super.date,
    required super.category,
    required super.type,
    required super.description,
    required super.day,
    required super.month,
    required super.year,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'value': value,
      'date': date,
      'category': category,
      'type': type,
      'description': description,
      'day': day,
      'month': month,
      'year': year,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      value: map['value'] as double,
      date: map['date'] as String,
      category: map['category'] as String,
      type: map['type'] as String,
      description: map['description'] as String,
      day: map['day'] as String,
      month: map['month'] as String,
      year: map['year'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
