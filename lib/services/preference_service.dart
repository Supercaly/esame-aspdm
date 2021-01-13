import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/domain/values/user_values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service that manages the [SharedPreferences].
class PreferenceService {
  SharedPreferences _preferences;

  PreferenceService();

  @visibleForTesting
  PreferenceService.private(this._preferences);

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Store the currently logged in [User].
  Future<void> storeSignedInUser(User user) async {
    await _preferences.setString("user_id", user?.id?.value?.getOrNull());
    await _preferences.setString("user_name", user?.name?.value?.getOrNull());
    await _preferences.setString("user_email", user?.email?.value?.getOrNull());
    await _preferences.setInt("user_color", user?.profileColor?.value);
  }

  /// Returns an instance of [User] stored using [storeSignedInUser]
  /// during the last login.
  /// If there's no user stored `null` will be returned instead.
  User getLastSignedInUser() {
    try {
      final colorValue = _preferences.getInt("user_color");
      return User(
        UniqueId(_preferences.getString("user_id")),
        UserName(_preferences.getString("user_name")),
        EmailAddress(_preferences.getString("user_email")),
        colorValue != null ? Color(colorValue) : null,
      );
    } catch (e) {
      return null;
    }
  }
}
