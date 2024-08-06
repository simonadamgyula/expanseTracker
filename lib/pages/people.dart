import 'package:budget_buddy/colors.dart';
import 'package:budget_buddy/database.dart';
import 'package:budget_buddy/pages/group_spending.dart';
import 'package:budget_buddy/pages/person_transactions.dart';
import 'package:flutter/material.dart';

import '../people.dart';
import '../profile_icon.dart';
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GroupSpendingPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.groups,
              color: Colors.white,
            ),
          ),
        ],
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

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: people.map((person) {
                return PersonPreview(person: person);
              }).toList(),
            ),
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

class PersonPreview extends StatelessWidget {
  const PersonPreview({super.key, required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonTransactionsPage(
                person: person,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(10),
            border: const Border(
              left: BorderSide(
                color: primary,
                width: 0.5,
              ),
              right: BorderSide(
                color: primary,
                width: 0.5,
              ),
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ProfileIcon(person: person),
              Expanded(
                child: Text(
                  person.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "${numberFormat.format(person.amount)} HUF",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
