import 'dart:developer';

import 'package:expense_tracker/colors.dart';
import 'package:expense_tracker/database.dart';
import 'package:expense_tracker/transactions.dart';
import 'package:flutter/material.dart';

import '../categories.dart';
import '../people.dart';

class NewTransactionPage extends StatefulWidget {
  const NewTransactionPage({
    super.key,
    required this.isExpense,
    this.person,
  });

  final bool isExpense;
  final Person? person;

  @override
  State<NewTransactionPage> createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransactionPage> {
  bool isExpense = false;
  bool isMoneyTransfer = false;
  TextEditingController amountController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  String selectedCategory = "";

  @override
  void initState() {
    setState(() {
      isExpense = widget.isExpense;
    });
    super.initState();
  }

  void setCallback(bool isExpense) {
    setState(() {
      this.isExpense = isExpense;
    });
  }

  void categorySelectCallback(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  Future<void> createGeneralTransaction(double amount) async {
    final newTransaction = Transaction(
      amount: amount,
      category: selectedCategory,
      details: detailsController.text,
    );
    await insertTransaction(newTransaction);
  }

  Future<void> createPersonTransaction(double amount) async {
    final newTransaction = PersonTransaction(
      personId: widget.person!.id!,
      amount: amount,
      category: selectedCategory,
      details: detailsController.text,
      isMoneyTransfer: isMoneyTransfer,
    );
    await insertPersonTransaction(newTransaction, person: widget.person);
  }

  @override
  Widget build(BuildContext context) {
    log(widget.person.toString());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
            "Add a transaction ${widget.person == null ? "" : "(${widget.person!.name})"}"),
        foregroundColor: Colors.white,
        backgroundColor: accentDarker,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TypeSelectButton(
              isExpense: isExpense,
              setCallback: setCallback,
            ),
            AmountInput(
              isExpense: isExpense,
              amountController: amountController,
              setIsExpense: setCallback,
            ),
            DetailsInput(
              detailsController: detailsController,
            ),
            widget.person != null
                ? Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: CheckboxListTile(
                      value: isMoneyTransfer,
                      title: const Text(
                        "Money transfer?",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      activeColor: primary,
                      checkColor: accentColor,
                      controlAffinity: ListTileControlAffinity.trailing,
                      onChanged: (bool? value) {
                        setState(() {
                          isMoneyTransfer = value!;
                        });
                      },
                    ),
                )
                : const SizedBox(),
            const Text(
              "Categories",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            CategoriesSelect(
              selectCallback: categorySelectCallback,
              selected: selectedCategory,
            ),
            ElevatedButton(
              onPressed: () async {
                final amount =
                    double.parse(amountController.text.replaceAll(",", "")) *
                        (isExpense ? -1 : 1);
                if (widget.person == null) {
                  await createGeneralTransaction(amount);
                } else {
                  await createPersonTransaction(amount);
                }

                if (!context.mounted) return;

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentLight,
                elevation: 8,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 5,
                ),
                child: Text(
                  "Create",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TypeSelectButton extends StatefulWidget {
  const TypeSelectButton({
    super.key,
    required this.isExpense,
    required this.setCallback,
  });

  final bool isExpense;
  final void Function(bool) setCallback;

  @override
  State<TypeSelectButton> createState() => _TypeSelectButtonState();
}

class _TypeSelectButtonState extends State<TypeSelectButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 2,
        left: 16,
        right: 8,
      ),
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<bool>(
          value: widget.isExpense,
          items: const [
            DropdownMenuItem<bool>(
              value: true,
              child: Text(
                "Expense",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DropdownMenuItem<bool>(
              value: false,
              child: Text(
                "Income",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          onChanged: (value) {
            widget.setCallback(value ?? false);
          },
          style: const TextStyle(
            color: Colors.white,
          ),
          dropdownColor: accentLight,
          borderRadius: BorderRadius.circular(10),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class AmountInput extends StatefulWidget {
  const AmountInput({
    super.key,
    required this.isExpense,
    required this.amountController,
    required this.setIsExpense,
  });

  final bool isExpense;
  final TextEditingController amountController;
  final void Function(bool) setIsExpense;

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  @override
  void initState() {
    widget.amountController.addListener(() {
      final number = double.tryParse(widget.amountController.text);
      if (number != null && number.isNegative) {
        setState(() {
          widget.setIsExpense(!widget.isExpense);
          widget.amountController.text =
              widget.amountController.text.substring(1);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              widget.isExpense ? "-" : "+",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: widget.amountController,
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
        ],
      ),
    );
  }
}

class DetailsInput extends StatefulWidget {
  const DetailsInput({
    super.key,
    required this.detailsController,
  });

  final TextEditingController detailsController;

  @override
  State<DetailsInput> createState() => _DetailsInputState();
}

class _DetailsInputState extends State<DetailsInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      margin: const EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: widget.detailsController,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: const InputDecoration(
          hintText: "Details",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class CategoriesSelect extends StatelessWidget {
  const CategoriesSelect({
    super.key,
    required this.selectCallback,
    required this.selected,
  });

  final void Function(String) selectCallback;
  final String selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: (1 / 1.1),
          children: categories.map<Widget>((category) {
            bool isSelected = selected == category;

            return Column(
              children: [
                MaterialButton(
                  color: isSelected ? primary : accentColor,
                  onPressed: () {
                    selectCallback(category);
                  },
                  shape: const CircleBorder(),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      category.characters.first,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    category,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
