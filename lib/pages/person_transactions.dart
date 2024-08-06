import 'package:budget_buddy/colors.dart';
import 'package:budget_buddy/database.dart';
import 'package:budget_buddy/new_transaction_fab.dart';
import 'package:budget_buddy/transaction_preview.dart';
import 'package:budget_buddy/transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../people.dart';

class PersonTransactionsPage extends StatefulWidget {
  const PersonTransactionsPage({super.key, required this.person});

  final Person person;

  @override
  State<PersonTransactionsPage> createState() => _PersonTransactionsPageState();
}

class _PersonTransactionsPageState extends State<PersonTransactionsPage> {
  final _key = GlobalKey<ExpandableFabState>();

  Widget transactionsBuilder(List<Widget> children) {
    final futurePersonalDebt = getPersonalDebt(widget.person.id!);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
              Container(
                height: 80,
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 60,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(40),
                  border: const Border(
                    top: BorderSide(color: primary, width: 0.2),
                    right: BorderSide(color: primary, width: 2),
                    bottom: BorderSide(color: primary, width: 0.2),
                    left: BorderSide(color: primary, width: 2),
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
                      future: futurePersonalDebt,
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

                        final text = switch (money) {
                          > 0 => "They owes you ${numberFormat.format(money)} HUF",
                          < 0 => "You owe them ${numberFormat.format(money)} HUF",
                          _ => "You are all settled",
                        };

                        return Column(
                          children: [
                            Text(
                              "${numberFormat.format(money)} HUF",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              text,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  bottom: 14,
                ),
                child: Text(
                  "Transactions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
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
    final futureTransactions =
        getPersonTransactions(personId: widget.person.id!);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.person.name),
        foregroundColor: Colors.white,
        backgroundColor: accentDarker,
      ),
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder<List<PersonTransaction>>(
          future: futureTransactions,
          builder: (context, AsyncSnapshot<List<PersonTransaction>> snapshot) {
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
                        PersonTransactionPreview(transaction: transaction),
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
        person: widget.person,
      ),
    );
  }
}
