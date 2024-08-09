import 'dart:developer';

import 'package:budget_buddy/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'colors.dart';
import 'database.dart';

NumberFormat numberFormat = NumberFormat("#,##0.00", "en_US");

class TransactionPreview extends StatelessWidget {
  const TransactionPreview({super.key, required this.transaction});

  final Transaction transaction;

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete transaction"),
          titleTextStyle: const TextStyle(
            color: Colors.white,
          ),
          content: const Text("Are you sure you want to delete this transaction?"),
          backgroundColor: accentColor,
          contentTextStyle: const TextStyle(
            color: Colors.white70,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                deleteTransaction(transaction.id!);
                Navigator.pop(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPopupMenu(BuildContext context, Offset offset) {
    double left = offset.dx;
    double top = offset.dy;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      color: accentLight,
      items: [
        PopupMenuItem(
          onTap: () {
            showDeleteDialog(context);
          },
          child: const Text(
            "Delete",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (TapDownDetails details) {
        _showPopupMenu(context, details.globalPosition);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(10),
          border: const Border(
            left: BorderSide(
              color: primary,
              width: 3,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 5),
              blurRadius: 5,
            )
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.noise_aware, color: Colors.white),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.details,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      transaction.createdAt!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              "${numberFormat.format(transaction.amount)} HUF",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PersonTransactionPreview extends StatelessWidget {
  const PersonTransactionPreview({super.key, required this.transaction});

  final PersonTransaction transaction;

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete transaction"),
          titleTextStyle: const TextStyle(
            color: Colors.white,
          ),
          content: const Text("Are you sure you want to delete this transaction?"),
          backgroundColor: accentColor,
          contentTextStyle: const TextStyle(
            color: Colors.white70,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                deletePersonTransaction(transaction.id!);
                Navigator.pop(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPopupMenu(BuildContext context, Offset offset) {
    double left = offset.dx;
    double top = offset.dy;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      color: accentLight,
      items: [
        PopupMenuItem(
          onTap: () {
            showDeleteDialog(context);
          },
          child: const Text(
            "Delete",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (TapDownDetails details) {
        _showPopupMenu(context, details.globalPosition);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(10),
          border: const Border(
            left: BorderSide(
              color: primary,
              width: 3,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 5),
              blurRadius: 5,
            )
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.noise_aware, color: Colors.white),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.details,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      transaction.createdAt!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              "${numberFormat.format(transaction.amount)} HUF",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
