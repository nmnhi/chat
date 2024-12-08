import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_chat/chat_page.dart';
import 'package:real_chat/core/theme.dart';
import 'package:real_chat/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:real_chat/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:real_chat/features/auth/domain/usecases/login_usecase.dart';
import 'package:real_chat/features/auth/domain/usecases/register_usecase.dart';
import 'package:real_chat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:real_chat/features/auth/presentation/pages/login_page.dart';
import 'package:real_chat/features/auth/presentation/pages/register_page.dart';
import 'package:real_chat/message_page.dart';

void main() {
  final authRepository =
      AuthRepositoryImpl(authRemoteDataSource: AuthRemoteDataSource());
  runApp(MainApp(
    authRepository: authRepository,
  ));
}

class MainApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;

  const MainApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            registerUsecase: RegisterUsecase(authRepository: authRepository),
            loginUsecase: LoginUsecase(authRepository: authRepository),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: Center(
            child: RegisterPage(),
          ),
        ),
        routes: {
          "/login": (_) => LoginPage(),
          "/register": (_) => RegisterPage(),
          "/chatPage": (_) => ChatPage(),
          "/messagePage": (_) => MessagePage(),
        },
      ),
    );
  }
}
