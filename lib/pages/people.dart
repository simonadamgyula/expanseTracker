import 'package:expense_tracker/colors.dart';
import 'package:expense_tracker/database.dart';
import 'package:flutter/material.dart';

import '../people.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final futurePeople = getPeople();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("People"),
        foregroundColor: Colors.white,
        backgroundColor: accentDarker,
      ),
      body: FutureBuilder(
        future: futurePeople,
        builder: (context, AsyncSnapshot<List<Person>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          final people = snapshot.data!;

          return Column(
            children: people.map((person) {
              return Text(
                person.toString(),
              );
            }).toList(),
          );
        },
      )
    );
  }
}
