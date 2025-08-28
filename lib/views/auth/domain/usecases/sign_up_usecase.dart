import 'package:equatable/equatable.dart';
import '../../../../shared/models/user_model.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<UserModel> call(SignUpParams params) async {
    return await repository.signUp(
      params.email,
      params.password,
      params.displayName,
    );
  }
}

class SignUpParams extends Equatable {
  final String email;
  final String password;
  final String? displayName;

  const SignUpParams({
    required this.email,
    required this.password,
    this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}
