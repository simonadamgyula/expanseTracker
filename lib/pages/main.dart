import 'package:expense_tracker/colors.dart';
import 'package:expense_tracker/database.dart';
import 'package:expense_tracker/pages/new_transaction.dart';
import 'package:expense_tracker/pages/people.dart';
import 'package:expense_tracker/pages/transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../transaction_preview.dart';
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
    final futureMoney = getMoney();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PeoplePage(),
                ),
              );
            },
            icon: const Icon(
              Icons.group,
              color: Colors.white,
            ),
          )
        ],
        foregroundColor: Colors.white,
        backgroundColor: accentDarker,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80,
            margin: const EdgeInsets.only(
              top: 20,
              bottom: 10,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(40),
              border: const Border(
                top: BorderSide(color: primary, width: 0.2),
                right: BorderSide(color: primary, width: 5),
                bottom: BorderSide(color: primary, width: 0.2),
                left: BorderSide(color: primary, width: 5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 5),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<double>(
                  future: futureMoney,
                  builder: (context, AsyncSnapshot<double> snapshot) {
                    if (!snapshot.hasData) {
                      return const Text(
                        "Loading...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                        ),
                      );
                    }

                    final money = snapshot.data!;

                    return Text(
                      "${numberFormat.format(money)} HUF",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
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

              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accentDark,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: transactions
                          .map(
                            (transaction) =>
                                TransactionPreview(transaction: transaction)
                                    as Widget,
                          )
                          .toList() +
                      [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TransactionsPage(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "View transactions",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.arrow_right_alt,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                ),
              );
            },
          ),
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
              final state = _key.currentState;
              if (state != null) {
                state.toggle();
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const NewTransactionPage(isExpense: false),
                ),
              ).then((_) {
                setState(() {});
              });
            },
            heroTag: null,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton.small(
            onPressed: () {
              final state = _key.currentState;
              if (state != null) {
                debugPrint('isOpen:${state.isOpen}');
                state.toggle();
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const NewTransactionPage(isExpense: true),
                ),
              ).then((_) {
                setState(() {});
              });
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
