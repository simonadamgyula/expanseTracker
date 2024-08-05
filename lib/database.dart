import 'dart:developer';

import 'package:expense_tracker/people.dart';
import 'package:expense_tracker/transactions.dart' as transactions;
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

late final Future<Database> database;

void createDb(Database db) {
  db.execute("CREATE TABLE keyedData (key TEXT PRIMARY KEY, value TEXT)");
  db.execute(
      "CREATE TABLE transactions (id INTEGER PRIMARY KEY AUTOINCREMENT, amount FLOAT, details TEXT, createdAt Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP, category TEXT)");
  db.execute(
      "CREATE TABLE people_transactions (id INTEGER PRIMARY KEY AUTOINCREMENT, personId INTEGER, amount FLOAT, details TEXT, createdAt Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP, category TEXT)");
  db.execute(
      "CREATE TABLE people (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount FLOAT);");
  db.execute("INSERT INTO keyedData (key, value) VALUES('money', '0')");
}

void initDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();

  database = openDatabase(
    join(await getDatabasesPath(), 'database.db'),
    onCreate: (db, version) => createDb(db),
    version: 1,
  );
}

Future<void> insertTransaction(transactions.Transaction transaction) async {
  final db = await database;

  await db.insert(
    "transactions",
    transaction.toInsertMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  final money = await getMoney();
  await updateMoney(money + transaction.amount);
}

Future<void> insertPersonTransaction(
  transactions.PersonTransaction transaction, {
  Person? person,
}) async {
  final db = await database;

  person ??= await getPerson(transaction.personId);

  await db.insert(
    "people_transactions",
    transaction.toInsertMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  person.amount += transaction.amount;

  await updatePerson(person);
  final money = await getMoney();
  await updateMoney(money + transaction.amount);
}

Future<List<transactions.Transaction>> getTransactions({int? limit}) async {
  final db = await database;

  final List<Map<String, Object?>> transactionMaps =
      await db.query('transactions', limit: limit, orderBy: "createdAt DESC");

  return [
    for (final transaction in transactionMaps)
      transactions.Transaction.fromJson(transaction),
  ];
}

Future<List<transactions.PersonTransaction>> getPersonTransactions({
  required int personId,
  int? limit,
}) async {
  final db = await database;

  final List<Map<String, Object?>> transactionMaps = await db.query(
    'people_transactions',
    where: "personId = ?",
    whereArgs: [personId],
    limit: limit,
    orderBy: "createdAt DESC",
  );

  return [
    for (final transaction in transactionMaps)
      transactions.PersonTransaction.fromJson(transaction),
  ];
}

Future<void> deleteTransaction(int id) async {
  final db = await database;

  await db.delete(
    "transaction",
    where: "id = ?",
    whereArgs: [id],
  );
}

Future<void> insertKey(String key, String value) async {
  final db = await database;

  await db.insert(
    "keyedData",
    {
      "key": key,
      "value": value,
    },
  );
}

Future<void> updateKey(String key, String value) async {
  final db = await database;

  await db.update(
    "keyedData",
    {"key": key, "value": value},
    where: "key = ?",
    whereArgs: [key],
  );
}

Future<String> getValue(String key) async {
  final db = await database;

  final keyList =
      await db.query("keyedData", where: "key = ?", whereArgs: [key]);
  return keyList[0]["value"] as String;
}

Future<void> updateMoney(double money) async {
  await updateKey(
    "money",
    money.toString(),
  );
}

Future<double> getMoney() async {
  return double.parse(await getValue("money"));
}

Future<void> insertPerson(Person person) async {
  final db = await database;

  await db.insert(
    "people",
    person.toInsertMap(),
  );
}

Future<List<Person>> getPeople() async {
  final db = await database;

  final List<Map<String, Object?>> transactionMaps =
      await db.query('people', orderBy: "id");

  return [
    for (final transaction in transactionMaps) Person.fromJson(transaction),
  ];
}

Future<Person> getPerson(int id) async {
  final db = await database;

  final List<Map<String, Object?>> persons = await db.query(
    "people",
    where: "id = ?",
    whereArgs: [id],
    limit: 1,
  );

  return Person.fromJson(persons.first);
}

Future<void> updatePerson(Person person) async {
  final db = await database;

  await db.update(
    "people",
    person.toMap(),
    where: "id = ?",
    whereArgs: [
      person.id,
    ],
  );
}
