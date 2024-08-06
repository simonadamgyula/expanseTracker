import 'package:budget_buddy/colors.dart';
import 'package:budget_buddy/database.dart';
import 'package:budget_buddy/new_transaction_fab.dart';
import 'package:budget_buddy/transaction_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final _key = GlobalKey<ExpandableFabState>();

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
                    fontSize: 35,
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
    final futureTransactions =  getTransactions();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: accentDarker,
      ),
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder<List<dynamic>>(
          future: futureTransactions,
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
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
                    (transaction) =>
                        TransactionPreview(transaction: transaction),
                  )
                  .toList(),
            );
          },
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: NewTransactionsFab(
        updateState: () {
          setState(() {});
        },
        fabKey: _key,
      ),
    );
  }
}
