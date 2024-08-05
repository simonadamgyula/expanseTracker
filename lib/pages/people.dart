import 'package:expense_tracker/colors.dart';
import 'package:expense_tracker/database.dart';
import 'package:expense_tracker/pages/person_transactions.dart';
import 'package:expense_tracker/pages/transactions.dart';
import 'package:expense_tracker/transaction_preview.dart';
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
        actions: [
          IconButton(
            onPressed: () {},
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
                )),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(
                  right: 20,
                  left: 5,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentLight,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      person.name.characters.first,
                      style: const TextStyle(
                        color: primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
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
