class Person {
  final int? id;
  final String name;

  const Person({
    this.id,
    required this.name,
  });

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }

  Map<String, Object?> toInsertMap() {
    return {
      "name": name,
    };
  }

  @override
  String toString() {
    return "Person(id: $id, name: $name)";
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "id": int id,
        "name": String name,
      } =>
        Person(
          id: id,
          name: name,
        ),
      _ => throw const FormatException("Wrong person format"),
    };
  }
}
