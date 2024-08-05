import 'package:expense_tracker/pages/new_transaction.dart';
import 'package:expense_tracker/people.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import 'colors.dart';

class NewTransactionsFab extends StatelessWidget {
  const NewTransactionsFab({super.key, required this.updateState, required this.fabKey, this.person});

  final void Function() updateState;
  final GlobalKey<ExpandableFabState> fabKey;
  final Person? person;

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      key: key,
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
            final state = fabKey.currentState;
            if (state != null) {
              state.toggle();
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                NewTransactionPage(isExpense: false, person: person,),
              ),
            ).then((_) {
              updateState();
            });
          },
          heroTag: null,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
        FloatingActionButton.small(
          onPressed: () {
            final state = fabKey.currentState;
            if (state != null) {
              debugPrint('isOpen:${state.isOpen}');
              state.toggle();
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                NewTransactionPage(isExpense: true, person: person,),
              ),
            ).then((_) {
              updateState();
            });
          },
          heroTag: null,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: const Icon(Icons.remove),
        )
      ],
    );
  }

}