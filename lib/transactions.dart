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

class PersonTransaction {
  final int? id;
  final int personId;
  final String? createdAt;
  final String details;
  final double amount;
  final String category;
  final bool isMoneyTransfer;

  const PersonTransaction({
    this.id,
    this.createdAt,
    required this.details,
    required this.amount,
    required this.category,
    required this.personId,
    required this.isMoneyTransfer,
  });

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "personId": personId,
      "amount": amount,
      "details": details,
      "created_at": createdAt,
      "category": category,
      "isMoneyTransfer": isMoneyTransfer
    };
  }

  Map<String, Object?> toInsertMap() {
    return {
      "personId": personId,
      "details": details,
      "amount": amount,
      "category": category,
      "isMoneyTransfer": isMoneyTransfer,
    };
  }

  Map<String, Object> toInsertRegular() {
    return {
      "details": details,
      "amount": amount,
      "category": category,
    };
  }

  @override
  String toString() {
    return 'PersonTransaction{id: $id, personId: $personId, amount: $amount, receiver: $details, created_at: $createdAt, category: $category}';
  }

  factory PersonTransaction.fromJson(Map<String, dynamic> json) {
    log(json["isMoneyTransfer"].runtimeType.toString());
    log(json.toString());

    return switch (json) {
      {
        "id": int id,
        "personId": int personId,
        "amount": int amount,
        "details": String details,
        "createdAt": String createdAt,
        "category": String category,
        "isMoneyTransfer": int isMoneyTransfer,
      } =>
        PersonTransaction(
          id: id,
          personId: personId,
          amount: amount.toDouble(),
          details: details,
          createdAt: createdAt,
          category: category,
          isMoneyTransfer: isMoneyTransfer == 1,
        ),
      {
        "id": int id,
        "personId": int personId,
        "amount": double amount,
        "details": String details,
        "createdAt": String createdAt,
        "category": String category,
        "isMoneyTransfer": int isMoneyTransfer,
      } =>
        PersonTransaction(
          id: id,
          personId: personId,
          amount: amount,
          details: details,
          createdAt: createdAt,
          category: category,
          isMoneyTransfer: isMoneyTransfer == 1,
        ),
      _ => throw const FormatException("Wrong person transaction format"),
    };
  }
}
