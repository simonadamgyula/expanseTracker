import 'package:expense_tracker/colors.dart';
import 'package:flutter/material.dart';

import '../people.dart';

class GroupSpendingPage extends StatefulWidget {
  const GroupSpendingPage({super.key});

  @override
  State<GroupSpendingPage> createState() => _GroupSpendingPageState();
}

class _GroupSpendingPageState extends State<GroupSpendingPage> {
  List<Person>? people;

  void showPeopleSelect() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          color: accentDarker,
          child: GridView.count(
            crossAxisCount: 2,
            children: const [],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Group spending"),
        foregroundColor: Colors.white,
        backgroundColor: accentDark,
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
