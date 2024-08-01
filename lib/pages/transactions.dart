import 'package:expense_tracker/colors.dart';
import 'package:expense_tracker/database.dart';
import 'package:expense_tracker/transaction_preview.dart';
import 'package:flutter/material.dart';

import '../transactions.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  Widget transactionsBuilder(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 20,
                ),
                child: Text(
                  "Transactions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ) as Widget,
            ] +
            children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final futureTransactions = getTransactions();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Transactions"),
        foregroundColor: Colors.white,
        backgroundColor: accentDarker,
      ),
      body: FutureBuilder<List<Transaction>>(
        future: futureTransactions,
        builder: (context, AsyncSnapshot<List<Transaction>> snapshot) {
          if (!snapshot.hasData) {
            return transactionsBuilder(
              [
                const Text(
                  "loading...",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            );
          }

          final transactions = snapshot.data!;

          return transactionsBuilder(
            transactions
                .map<Widget>(
                  (transaction) => TransactionPreview(transaction: transaction),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
