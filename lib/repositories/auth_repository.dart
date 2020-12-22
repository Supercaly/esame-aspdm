import 'package:aspdm_project/model/user.dart';
import 'package:aspdm_project/services/data_source.dart';
import 'package:aspdm_project/services/preference_service.dart';

import '../locator.dart';

class AuthRepository {
  DataSource _dataSource = locator<DataSource>();
  PreferenceService _preferenceService = locator<PreferenceService>();

  User get lastSignedInUser => _preferenceService.getLastSignedInUser();

  Future<User> login(String email, String password) async {
    final user = await _dataSource.authenticate(email, password);
    if (user == null) throw Exception("Invalid user!");

    _preferenceService.storeSignedInUser(user);
    return user;
  }

  Future<void> logout() {
    return _preferenceService.storeSignedInUser(null);
  }
}
