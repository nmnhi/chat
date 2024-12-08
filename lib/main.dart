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
import 'package:real_chat/features/conversation/data/datasources/conversations_remote_data_source.dart';
import 'package:real_chat/features/conversation/data/repositories/conversation_repository_impl.dart';
import 'package:real_chat/features/conversation/domain/usecases/fetch_conversation_use_case.dart';
import 'package:real_chat/features/conversation/presentation/bloc/conversations_bloc.dart';
import 'package:real_chat/features/conversation/presentation/pages/conversations_page.dart';

void main() {
  final authRepository =
      AuthRepositoryImpl(authRemoteDataSource: AuthRemoteDataSource());

  final conversationRepository = ConversationRepositoryImpl(
      conversationsRemoteDataSource: ConversationsRemoteDataSource());

  runApp(MainApp(
    authRepository: authRepository,
    conversationsRepository: conversationRepository,
  ));
}

class MainApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final ConversationRepositoryImpl conversationsRepository;

  const MainApp(
      {super.key,
      required this.authRepository,
      required this.conversationsRepository});

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
        BlocProvider(
          create: (_) => ConversationsBloc(
            fetchConversationsUseCase: FetchConversationUseCase(
              conversationsRepository: conversationsRepository,
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: RegisterPage(),
        routes: {
          "/login": (_) => LoginPage(),
          "/register": (_) => RegisterPage(),
          "/chatPage": (_) => ChatPage(),
          "/conversationPage": (_) => ConversationsPage(),
        },
      ),
    );
  }
}
