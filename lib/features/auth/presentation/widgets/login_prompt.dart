import 'package:flutter/material.dart';

class LoginPrompt extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback action;

  const LoginPrompt({
    super.key,
    required this.title,
    required this.subtitle,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: action,
        child: RichText(
          text: TextSpan(
              text: title,
              style: TextStyle(color: Colors.grey),
              children: [
                TextSpan(
                  text: subtitle,
                  style: TextStyle(color: Colors.blue),
                )
              ]),
        ),
      ),
    );
  }
}