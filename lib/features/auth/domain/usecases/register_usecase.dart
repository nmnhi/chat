import 'package:real_chat/features/auth/domain/entities/user_entity.dart';
import 'package:real_chat/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository authRepository;
  RegisterUsecase({required this.authRepository});

  Future<UserEntity> call(String username, String email, String password){
    return authRepository.register(username, email, password);
  }
}
