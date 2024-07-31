import 'dart:developer';

import 'package:flutter/material.dart';

class NewTransactionPage extends StatefulWidget {
  const NewTransactionPage({super.key, required this.isExpanse});

  final bool isExpanse;

  @override
  State<NewTransactionPage> createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransactionPage> {
  bool isExpanse = false;
  TextEditingController amountController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Add a transaction"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const Text(
            "this is a text",
            style: TextStyle(color: Colors.white),
          ),
          TypeSelectButton(
            isExpanse: isExpanse,
            setCallback: setCallback,
          ),
          AmountInput(
            isExpanse: isExpanse,
            amountController: amountController,
            setIsExpanse: setCallback,
          ),
        ],
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
    return DropdownButton<bool>(
      value: widget.isExpanse,
      items: const [
        DropdownMenuItem<bool>(
          value: true,
          child: Text("Expanse"),
        ),
        DropdownMenuItem<bool>(
          value: false,
          child: Text("Income"),
        ),
      ],
      onChanged: (value) {
        widget.setCallback(value ?? false);
      },
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
    return Row(
      children: [
        widget.isExpanse
            ? const Icon(
                Icons.remove,
                color: Colors.white,
              )
            : const Icon(
                Icons.add,
                color: Colors.white,
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
              labelText: "Amount",
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
