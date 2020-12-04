import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/routes.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:aspdm_project/states/auth_state.dart';
import 'package:aspdm_project/widgets/settings_widget.dart';
import 'package:aspdm_project/widgets/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: [
        UserInfoCard(),
        SettingsGroup.single(
          title: "notifications",
          item: SettingsGroupItem(
            text: "Show system settings",
            icon: Icon(Icons.notifications),
            onTap: null,
          ),
        ),
        SettingsGroup.single(
          title: "archive",
          item: SettingsGroupItem(
            text: "Show archived tasks",
            icon: Icon(Icons.archive),
            onTap: () {
              locator<NavigationService>().navigateTo(Routes.archive);
            },
          ),
        ),
        SettingsGroup(
          title: "about",
          children: [
            SettingsGroupItem(
              text: "About this app",
              icon: Icon(Icons.bookmark),
            ),
            SettingsGroupItem(
              text: "Version 0.0.1(1)",
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("This is not an Easter Egg!"),
                  ),
                );
              },
            ),
            SettingsGroupItem(
              text: "Made with <3 from Italy.",
            ),
          ],
        ),
        SettingsGroup.single(
          title: "account",
          item: SettingsGroupItem(
            text: "Sign Out",
            icon: Icon(Icons.exit_to_app, color: Colors.red),
            textColor: Colors.red,
            onTap: () async {
              await context.read<AuthState>().logout();
            },
          ),
        )
      ],
    );
  }
}
