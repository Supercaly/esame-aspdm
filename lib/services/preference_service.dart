import 'package:aspdm_project/domain/entities/user.dart';
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
    await _preferences.setString("user_id", user?.id);
    await _preferences.setString("user_name", user?.name);
    await _preferences.setString("user_email", user?.email);
    await _preferences.setInt("user_color", user?.profileColor?.value);
  }

  /// Returns an instance of [User] stored using [storeSignedInUser]
  /// during the last login.
  /// If there's no user stored `null` will be returned instead.
  User getLastSignedInUser() {
    final id = _preferences.getString("user_id");
    if (id == null) return null;
    final colorValue = _preferences.getInt("user_color");
    return User(
      id,
      _preferences.getString("user_name"),
      _preferences.getString("user_email"),
      colorValue != null ? Color(colorValue) : null,
    );
  }
}
