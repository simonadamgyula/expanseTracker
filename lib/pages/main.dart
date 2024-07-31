import 'package:expense_tracker/colors.dart';
import 'package:expense_tracker/database.dart';
import 'package:expense_tracker/pages/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../transactions.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    final futureTransactions = getTransactions(limit: 5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        foregroundColor: Colors.white,
        backgroundColor: accentDarker,
      ),
      body: Column(
        children: [
          const Text(
            "Here will be your this monthly report!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          FutureBuilder(
            future: futureTransactions,
            builder: (context, AsyncSnapshot<List<Transaction>> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error while loading transactions"),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }

              final transactions = snapshot.data!;

              return Column(
                children: transactions
                    .map((transaction) =>
                        TransactionPreview(transaction: transaction))
                    .toList(),
              );
            },
          )
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.compare_arrows),
          fabSize: ExpandableFabSize.regular,
          foregroundColor: Colors.white,
          backgroundColor: primary,
          shape: const CircleBorder(),
        ),
        closeButtonBuilder: FloatingActionButtonBuilder(
          size: 56,
          builder: (BuildContext context, void Function()? onPressed,
              Animation<double> progress) {
            return IconButton(
              onPressed: onPressed,
              icon: const Icon(
                Icons.close,
                size: 40,
                color: Colors.white,
              ),
            );
          },
        ),
        distance: 80,
        childrenOffset: const Offset(4, 0),
        type: ExpandableFabType.up,
        overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.white.withOpacity(0.1),
          blur: 5,
        ),
        children: [
          FloatingActionButton.small(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const NewTransactionPage(isExpanse: false),
                ),
              );
            },
            heroTag: null,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton.small(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const NewTransactionPage(isExpanse: true),
                ),
              );
            },
            heroTag: null,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: const Icon(Icons.remove),
          )
        ],
      ),
    );
  }
}

class TransactionPreview extends StatelessWidget {
  const TransactionPreview({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: accentColor,
      child: Row(
        children: [
          const Icon(Icons.noise_aware, color: Colors.white),
          Expanded(
            child: Column(
              children: [
                Text(
                  transaction.receiver,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  transaction.createdAt!,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Text(
            transaction.amount.toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
