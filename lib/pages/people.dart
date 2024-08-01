import 'package:expense_tracker/colors.dart';
import 'package:expense_tracker/database.dart';
import 'package:flutter/material.dart';

import '../people.dart';
import 'new_person.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewPersonPage(),
            ),
          ).then((_) {
            setState(() {});
          });
        },
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
