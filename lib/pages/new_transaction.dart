import 'package:expense_tracker/colors.dart';
import 'package:expense_tracker/database.dart';
import 'package:expense_tracker/transactions.dart';
import 'package:flutter/material.dart';

import '../categories.dart';

class NewTransactionPage extends StatefulWidget {
  const NewTransactionPage({super.key, required this.isExpanse});

  final bool isExpanse;

  @override
  State<NewTransactionPage> createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransactionPage> {
  bool isExpanse = false;
  TextEditingController amountController = TextEditingController();
  String selectedCategory = "";

  @override
  void initState() {
    setState(() {
      isExpanse = widget.isExpanse;
    });
    super.initState();
  }

  void setCallback(bool isExpanse) {
    setState(() {
      this.isExpanse = isExpanse;
    });
  }

  void categorySelectCallback(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Add a transaction"),
        foregroundColor: Colors.white,
        backgroundColor: accentDarker,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TypeSelectButton(
              isExpanse: isExpanse,
              setCallback: setCallback,
            ),
            AmountInput(
              isExpanse: isExpanse,
              amountController: amountController,
              setIsExpanse: setCallback,
            ),
            CategoriesSelect(
              selectCallback: categorySelectCallback,
              selected: selectedCategory,
            ),
            TextButton(
              onPressed: () async {
                final newTransaction = Transaction(
                  amount: double.parse(amountController.text) *
                      (isExpanse ? -1 : 1),
                  category: selectedCategory,
                  receiver: '',
                );
                await insertTransaction(newTransaction);

                if (!context.mounted) return;

                Navigator.pop(context);
              },
              child: const Text(
                "Create",
                style: TextStyle(
                  color: Colors.white,
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
    required this.isExpanse,
    required this.setCallback,
  });

  final bool isExpanse;
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
          value: widget.isExpanse,
          items: const [
            DropdownMenuItem<bool>(
              value: true,
              child: Text(
                "Expanse",
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
    required this.isExpanse,
    required this.amountController,
    required this.setIsExpanse,
  });

  final bool isExpanse;
  final TextEditingController amountController;
  final void Function(bool) setIsExpanse;

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
          widget.setIsExpanse(!widget.isExpanse);
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              widget.isExpanse ? "+" : "-",
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
          horizontal: 30,
          vertical: 10,
        ),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: categories.map<Widget>((category) {
            bool isSelected = selected == category;

            return MaterialButton(
              color: isSelected ? accentLight : accentColor,
              onPressed: () {
                selectCallback(category);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
              child: Text(
                category,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
