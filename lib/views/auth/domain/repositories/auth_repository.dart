import '../../../../shared/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signUp(String email, String password, String? displayName);
  Future<UserModel> signIn(String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}
