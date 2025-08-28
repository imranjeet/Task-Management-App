import 'package:equatable/equatable.dart';
import '../../../../shared/models/user_model.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<UserModel> call(SignInParams params) async {
    return await repository.signIn(
      params.email,
      params.password,
    );
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
