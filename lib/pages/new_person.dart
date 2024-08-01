import 'package:expense_tracker/colors.dart';
import 'package:expense_tracker/database.dart';
import 'package:flutter/material.dart';

import '../people.dart';

class NewPersonPage extends StatefulWidget {
  const NewPersonPage({super.key});

  @override
  State<NewPersonPage> createState() => _NewPersonPageState();
}

class _NewPersonPageState extends State<NewPersonPage> {
  TextEditingController nameController = TextEditingController();

  String firstCharacter = "0";

  bool error = false;

  bool validate() {
    if (nameController.text.isEmpty) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: accentDarker,
        title: const Text("New person"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: accentLight,
                  width: 2,
                ),
                color: accentColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      firstCharacter,
                      style: const TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 5,
                  )
                ],
              ),
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: TextStyle(
                    color: error ? Colors.red : Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {
                    firstCharacter =
                        value.isEmpty ? "0" : value.characters.first;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: ElevatedButton(
                onPressed: () async {
                  if (!validate()) {
                    setState(() {
                      error = true;
                    });
                    return;
                  }

                  final person = Person(
                    name: nameController.text,
                    amount: 0,
                  );

                  await insertPerson(person);

                  if (!context.mounted) return;

                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                    backgroundColor: accentLight,
                    elevation: 10,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    )),
                child: const Text(
                  "Create",
                  style: TextStyle(
                    color: primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
