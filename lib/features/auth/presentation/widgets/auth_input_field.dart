import 'package:flutter/material.dart';
import 'package:real_chat/core/theme.dart';

class AuthInputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;

  const AuthInputField(
      {super.key,
      required this.hint,
      required this.icon,
      required this.controller,
      this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: DefaultColors.sendMessageInput,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
