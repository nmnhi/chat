import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_chat/core/socket_service.dart';
import 'package:real_chat/core/theme.dart';
import 'package:real_chat/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:real_chat/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:real_chat/features/auth/domain/usecases/login_usecase.dart';
import 'package:real_chat/features/auth/domain/usecases/register_usecase.dart';
import 'package:real_chat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:real_chat/features/auth/presentation/pages/login_page.dart';
import 'package:real_chat/features/auth/presentation/pages/register_page.dart';
import 'package:real_chat/features/chat/data/datasources/message_remote_data_source.dart';
import 'package:real_chat/features/chat/data/repositories/message_repository_impl.dart';
import 'package:real_chat/features/chat/domain/usecases/fetch_message_use_case.dart';
import 'package:real_chat/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:real_chat/features/conversation/data/datasources/conversations_remote_data_source.dart';
import 'package:real_chat/features/conversation/data/repositories/conversation_repository_impl.dart';
import 'package:real_chat/features/conversation/domain/usecases/fetch_conversation_use_case.dart';
import 'package:real_chat/features/conversation/presentation/bloc/conversations_bloc.dart';
import 'package:real_chat/features/conversation/presentation/pages/conversations_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final socketService = SocketService();
  await socketService.initSocket();

  final authRepository =
      AuthRepositoryImpl(authRemoteDataSource: AuthRemoteDataSource());

  final conversationRepository = ConversationRepositoryImpl(
      conversationsRemoteDataSource: ConversationsRemoteDataSource());

  final messageRepository =
      MessageRepositoryImpl(messageRemoteDataSource: MessageRemoteDataSource());

  runApp(MainApp(
    authRepository: authRepository,
    conversationsRepository: conversationRepository,
    messageRepository: messageRepository,
  ));
}

class MainApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final ConversationRepositoryImpl conversationsRepository;
  final MessageRepositoryImpl messageRepository;

  const MainApp({
    super.key,
    required this.authRepository,
    required this.conversationsRepository,
    required this.messageRepository,
  });

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
        BlocProvider(
          create: (_) => ChatBloc(
            fetchMessageUseCase:
                FetchMessageUseCase(messageRepository: messageRepository),
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
          "/conversationPage": (_) => ConversationsPage(),
        },
      ),
    );
  }
}
