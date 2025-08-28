import '../../../../shared/models/user_model.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserModel> signUp(String email, String password, String? displayName) async {
    try {
      return await remoteDataSource.signUp(email, password, displayName);
    } on Failure {
      rethrow;
    } catch (e) {
      throw const AuthFailure('Registration failed');
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      return await remoteDataSource.signIn(email, password);
    } on Failure {
      rethrow;
    } catch (e) {
      throw const AuthFailure('Login failed');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } on Failure {
      rethrow;
    } catch (e) {
      throw const AuthFailure('Sign out failed');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      return await remoteDataSource.getCurrentUser();
    } on Failure {
      rethrow;
    } catch (e) {
      throw const AuthFailure('Failed to get current user');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges => remoteDataSource.authStateChanges;
}
