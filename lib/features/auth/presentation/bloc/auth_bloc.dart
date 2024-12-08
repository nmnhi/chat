import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:real_chat/features/auth/domain/usecases/login_usecase.dart";
import "package:real_chat/features/auth/domain/usecases/register_usecase.dart";
import "package:real_chat/features/auth/presentation/bloc/auth_event.dart";
import "package:real_chat/features/auth/presentation/bloc/auth_state.dart";

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUsecase registerUsecase;
  final LoginUsecase loginUsecase;
  final _storage = FlutterSecureStorage();

  AuthBloc({required this.registerUsecase, required this.loginUsecase})
      : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await registerUsecase.call(
          event.username, event.email, event.password);

      print(user.token);

      emit(AuthSuccess(message: "Registration successfully"));
    } catch (e) {
      emit(
        AuthFailure(error: e.toString()),
      );
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUsecase.call(event.email, event.password);
      await _storage.write(key: "token", value: user.token);
      print("Token ${user.token}");
      emit(AuthSuccess(message: "Login successfully"));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
