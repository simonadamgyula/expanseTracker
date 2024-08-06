import 'package:expense_tracker/people.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key, required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

}