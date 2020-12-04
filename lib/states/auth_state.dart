import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/model/user.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:flutter/foundation.dart';

class AuthState extends ChangeNotifier {
  User _currentUser;

  AuthState() : _currentUser = null;

  User get currentUser => _currentUser;

  Future<bool> login(String email, String password) async{
    try {
      final newUser = User(id: "mock_id", name: "Mock User", email: email);
      if (_currentUser != newUser) {
        _currentUser = newUser;
        notifyListeners();
      }
      return true;
    } catch (e) {
      locator<LogService>().error("AuthState.login:", e);
      return false;
    }
  }

  Future<void> logout() async{
    locator<LogService>().info("Sign Out user!");
    _currentUser = null;
    notifyListeners();
  }
}
