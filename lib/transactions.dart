import 'dart:developer';

import 'package:flutter/material.dart';

class Transaction {
  final int? id;
  final double amount;
  final String? createdAt;
  final String category;

  const Transaction({
    this.id,
    this.createdAt,
    required this.amount,
    required this.category,
  });

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "amount": amount,
      "created_at": createdAt,
      "category": category,
    };
  }

  Map<String, Object?> toInsertMap() {
    return {
      "amount": amount,
      "category": category,
    };
  }

  @override
  String toString() {
    return 'Dog{amount: $amount, created_at: $createdAt, category: $category}';
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    log(json["id"].runtimeType.toString());
    log(json["amount"].runtimeType.toString());
    log(json["createdAt"].runtimeType.toString());
    log(json["category"].runtimeType.toString());

    return switch (json) {
      {
        "id": int id,
        "amount": double amount,
        "created_at": String createdAt,
        "category": String category,
      } =>
        Transaction(
          id: id,
          amount: amount,
          createdAt: createdAt,
          category: category,
        ),
      {
        "id": int id,
        "amount": int amount,
        "created_at": String createdAt,
        "category": String category,
      } =>
        Transaction(
          id: id,
          amount: amount.toDouble(),
          createdAt: createdAt,
          category: category,
        ),
      _ => throw const FormatException("Wrong transaction format"),
    };
  }
}
