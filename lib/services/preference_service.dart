import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/values/user_values.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service that manages the [SharedPreferences].
class PreferenceService {
  SharedPreferences _preferences;

  PreferenceService();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Store the currently logged in [User].
  Future<void> storeSignedInUser(Maybe<User> user) async {
    if (user.isNothing()) {
      await _preferences.remove("user_id");
      await _preferences.remove("user_name");
      await _preferences.remove("user_email");
      await _preferences.remove("user_color");
    } else {
      final User value = user.getOrNull();
      await _preferences.setString("user_id", value?.id?.value?.getOrNull());
      await _preferences.setString(
        "user_name",
        value?.name?.value?.getOrNull(),
      );
      await _preferences.setString(
        "user_email",
        value?.email?.value?.getOrNull(),
      );
      await _preferences.setInt(
          "user_color", value?.profileColor?.value?.getOrNull()?.value);
    }
  }

  /// Returns an instance of [User] stored using [storeSignedInUser]
  /// during the last login.
  /// If there's no user stored `null` will be returned instead.
  Maybe<User> getLastSignedInUser() {
    final colorValue = _preferences.getInt("user_color");
    final id = UniqueId(_preferences.getString("user_id"));
    if (id.value.isLeft()) return Maybe<User>.nothing();
    return Maybe.just(User(
      id: id,
      name: UserName(_preferences.getString("user_name")),
      email: EmailAddress(_preferences.getString("user_email")),
      profileColor: colorValue != null ? ProfileColor(Color(colorValue)) : null,
    ));
  }
}
