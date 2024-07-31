import 'package:expese_tracker/pages/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        foregroundColor: Colors.white,
      ),
      body: const Column(
        children: [
          Text(
            "Here will be your this monthly report!",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            "Here will be your recent 5 transactions, and a button to show the rest!",
            style: TextStyle(
              color: Colors.grey,
            ),
          )
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.compare_arrows),
          fabSize: ExpandableFabSize.regular,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
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
              ),
            );
          },
        ),
        type: ExpandableFabType.up,
        overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.white.withOpacity(0.5),
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
            child: const Icon(Icons.remove),
          )
        ],
      ),
    );
  }
}
