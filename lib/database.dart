import 'package:expense_tracker/transactions.dart' as transactions;
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

late final Future<Database> database;

void initDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();

  database = openDatabase(
    join(await getDatabasesPath(), 'database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE transactions (id INTEGER PRIMARY KEY AUTOINCREMENT, amount INTEGER, details TEXT, createdAt Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP, category TEXT)",
      );
    },
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
}

Future<List<transactions.Transaction>> getTransactions({int? limit}) async {
  final db = await database;

  final List<Map<String, Object?>> transactionMaps =
      await db.query('transactions', limit: limit, orderBy: "createdAt");

  return [
    for (final transaction in transactionMaps)
      transactions.Transaction.fromJson(transaction),
  ];
}

Future<void> deleteTransaction(int id) async {
  final db = await database;

  db.delete(
    "transaction",
    where: "id = ?",
    whereArgs: [id],
  );
}
