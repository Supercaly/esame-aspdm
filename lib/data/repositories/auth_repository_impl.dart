import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/repositories/auth_repository.dart';
import 'package:aspdm_project/data/datasources/remote_data_source.dart';
import 'package:aspdm_project/services/preference_service.dart';

import '../../locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  RemoteDataSource _dataSource = locator<RemoteDataSource>();
  PreferenceService _preferenceService = locator<PreferenceService>();

  @override
  User get lastSignedInUser => _preferenceService.getLastSignedInUser();

  @override
  Future<User> login(String email, String password) async {
    final user = await _dataSource.authenticate(email, password);
    if (user == null) throw Exception("Invalid user!");

    _preferenceService.storeSignedInUser(user);
    return user;
  }

  @override
  Future<void> logout() {
    return _preferenceService.storeSignedInUser(null);
  }
}
