import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_chat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:real_chat/features/auth/presentation/bloc/auth_event.dart';
import 'package:real_chat/features/auth/presentation/bloc/auth_state.dart';
import 'package:real_chat/features/auth/presentation/widgets/auth_button.dart';
import 'package:real_chat/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:real_chat/features/auth/presentation/widgets/login_prompt.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onLogin() {
    BlocProvider.of<AuthBloc>(context).add(
      LoginEvent(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/messagePage", (route) => false);
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthInputField(
                      hint: "Email",
                      icon: Icons.mail,
                      controller: _emailController),
                  const SizedBox(height: 15),
                  AuthInputField(
                      hint: "Password",
                      icon: Icons.lock,
                      controller: _passwordController,
                      isPassword: true),
                  const SizedBox(height: 35),
                  AuthButton(
                    label: "Login",
                    onPressed: _onLogin,
                  ),
                  const SizedBox(height: 25),
                  LoginPrompt(
                    title: "Don't have an account? ",
                    subtitle: "Click here to register",
                    action: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/register", (route) => false);
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
