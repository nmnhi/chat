import 'package:real_chat/features/auth/domain/entities/user_entity.dart';
import 'package:real_chat/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository authRepository;
  LoginUsecase({required this.authRepository});

  Future<UserEntity> call(String email, String password) {
    return authRepository.login(email, password);
  }
}
