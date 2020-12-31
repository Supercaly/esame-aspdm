import '../entities/user.dart';

abstract class AuthRepository {
  User get lastSignedInUser;

  Future<User> login(String email, String password);

  Future<void> logout();
}
