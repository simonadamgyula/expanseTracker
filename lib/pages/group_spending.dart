import 'package:budget_buddy/colors.dart';
import 'package:budget_buddy/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../people.dart';
import '../profile_icon.dart';
import '../transactions.dart';
import 'new_transaction.dart';

NumberFormat numberFormat = NumberFormat("#,##0.00", "hu_HU");

extension Toggle<T> on List<T> {
  void toggle(T value) {
    if (contains(value)) {
      remove(value);
    } else {
      add(value);
    }
  }
}

class GroupSpendingPage extends StatefulWidget {
  const GroupSpendingPage({super.key});

  @override
  State<GroupSpendingPage> createState() => _GroupSpendingPageState();
}

class _GroupSpendingPageState extends State<GroupSpendingPage> {
  Map<int, Person> peopleMap = {};
  List<Person>? people;
  List<int> selectedPeople = [];
  final TextEditingController amountController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  String selectedCategory = "";

  void _getPeople() {
    getPeople().then((people) {
      setState(() {
        this.people = people;
        for (var person in people) {
          peopleMap[person.id!] = person;
        }
      });
    });
  }

  void select(Person person, StateSetter setModalState) {
    setState(() {
      setModalState(() {
        selectedPeople.toggle(person.id!);
      });
    });
  }

  void showPeopleSelect() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context,
              void Function(void Function()) setModalState) {
            return Container(
              height: 300,
              color: accentDark,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 3 / 1,
                padding: const EdgeInsets.all(20),
                children: people == null
                    ? [
                        const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ) as Widget,
                      ]
                    : people!.map<Widget>((person) {
                        final isSelected = selectedPeople.contains(person.id);

                        return PersonSelectable(
                          person: person,
                          isSelected: isSelected,
                          setModalState: setModalState,
                          selectCallback: select,
                        );
                      }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  void categorySelectCallback(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  bool isFilledOut() {
    if (selectedPeople.isEmpty) return false;
    if (amountController.text.isEmpty) return false;
    if (detailsController.text.isEmpty) return false;
    if (selectedCategory.isEmpty) return false;

    return true;
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _getPeople();

    final amount = double.tryParse(amountController.text) ?? 0;
    final amountPerPerson = amount / (selectedPeople.length + 1);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Group spending"),
        foregroundColor: Colors.white,
        backgroundColor: accentDark,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                showPeopleSelect();
              },
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                  color: accentLight,
                  width: 4,
                ),
              ),
              child: const Text(
                "Select people",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: selectedPeople.isEmpty
                  ? [
                      const Text(
                        "No people selected",
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ]
                  : selectedPeople.map<Widget>((personId) {
                      final person = peopleMap[personId];

                      if (person == null) {
                        return const SizedBox();
                      }

                      return SelectedPerson(person: person);
                    }).toList(),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              margin: const EdgeInsets.only(top: 30, bottom: 14),
              child: TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  hintText: "Amount",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            DetailsInput(
              detailsController: detailsController,
            ),
            CategoriesSelect(
              selectCallback: categorySelectCallback,
              selected: selectedCategory,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 14),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "Total amount: ${numberFormat.format(amount)} HUF",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Amount per person: ${numberFormat.format(amountPerPerson)} HUF",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!isFilledOut()) return;

                final amount = double.tryParse(amountController.text);
                if (amount == null) return;

                final Transaction originalTransaction = Transaction(
                  details: detailsController.text,
                  amount: amount,
                  category: selectedCategory,
                );

                await addGroupExpanse(
                  originalTransaction,
                  selectedPeople,
                );

                if (!context.mounted) return;

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentLight,
                elevation: 8,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 5,
                ),
                child: Text(
                  "Create",
                  style: TextStyle(
                    color: isFilledOut() ? Colors.white : Colors.grey,
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

class SelectedPerson extends StatelessWidget {
  const SelectedPerson({super.key, required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: accentLight,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        person.name,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class PersonSelectable extends StatelessWidget {
  const PersonSelectable({
    super.key,
    required this.person,
    required this.isSelected,
    required this.selectCallback,
    required this.setModalState,
  });

  final Person person;
  final bool isSelected;
  final void Function(void Function()) setModalState;
  final void Function(Person, void Function(void Function())) selectCallback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        selectCallback(person, setModalState);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? const Border(
                  left: BorderSide(
                    color: primary,
                    width: 3,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  right: BorderSide(
                    color: primary,
                    width: 3,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  top: BorderSide(
                    color: primary,
                    width: 0.2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  bottom: BorderSide(
                    color: primary,
                    width: 0.2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            ProfileIcon(person: person),
            Text(
              person.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
