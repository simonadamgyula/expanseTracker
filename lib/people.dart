class Person {
  final int? id;
  final String name;
  double amount;

  Person({
    this.id,
    required this.name,
    required this.amount,
  });

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "name": name,
      "amount": amount,
    };
  }

  Map<String, Object?> toInsertMap() {
    return {
      "name": name,
      "amount": amount,
    };
  }

  @override
  String toString() {
    return "Person(id: $id, name: $name, amount: $amount)";
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "id": int id,
        "name": String name,
        "amount": double amount,
      } =>
        Person(
          id: id,
          name: name,
          amount: amount,
        ),
      _ => throw const FormatException("Wrong person format"),
    };
  }
}
