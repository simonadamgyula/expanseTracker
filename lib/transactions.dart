import 'dart:developer';

class Transaction {
  final int? id;
  final String? createdAt;
  final String details;
  final double amount;
  final String category;

  const Transaction({
    this.id,
    this.createdAt,
    required this.details,
    required this.amount,
    required this.category,
  });

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "amount": amount,
      "details": details,
      "created_at": createdAt,
      "category": category,
    };
  }

  Map<String, Object?> toInsertMap() {
    return {
      "details": details,
      "amount": amount,
      "category": category,
    };
  }

  @override
  String toString() {
    return 'Transaction{id: $id, amount: $amount, receiver: $details, created_at: $createdAt, category: $category}';
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "id": int id,
        "amount": int amount,
        "details": String details,
        "createdAt": String createdAt,
        "category": String category,
      } =>
        Transaction(
          id: id,
          amount: amount.toDouble(),
          details: details,
          createdAt: createdAt,
          category: category,
        ),
      {
        "id": int id,
        "amount": double amount,
        "details": String details,
        "createdAt": String createdAt,
        "category": String category,
      } =>
        Transaction(
          id: id,
          amount: amount,
          details: details,
          createdAt: createdAt,
          category: category,
        ),
      _ => throw const FormatException("Wrong transaction format"),
    };
  }
}
