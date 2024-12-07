import 'package:flutter/material.dart';
import 'package:real_chat/core/theme.dart';
import 'package:real_chat/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const Scaffold(
        body: Center(
          child: LoginPage(),
        ),
      ),
    );
  }
}
