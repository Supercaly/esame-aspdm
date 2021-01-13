import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/presentation/routes.dart';
import 'package:aspdm_project/services/app_info_service.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:aspdm_project/presentation/states/auth_state.dart';
import 'package:aspdm_project/presentation/widgets/responsive.dart';
import 'package:aspdm_project/presentation/widgets/settings_widget.dart';
import 'package:aspdm_project/presentation/widgets/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    locator<LogService>().logBuild("SettingsPage");
    final appInfo = locator<AppInfoService>();
    return Center(
      child: Container(
        width: Responsive.isLarge(context) ? 500 : double.maxFinite,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: [
            UserInfoCard(),
            SettingsGroup.single(
              title: "notifications",
              item: SettingsGroupItem(
                text: "Show system settings",
                icon: Icon(FeatherIcons.bell),
                onTap: null,
              ),
            ),
            SettingsGroup.single(
              title: "archive",
              item: SettingsGroupItem(
                text: "Show archived tasks",
                icon: Icon(FeatherIcons.archive),
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
                  icon: Icon(FeatherIcons.bookmark),
                ),
                SettingsGroupItem(
                  text: "Open Source",
                  icon: Icon(Icons.adb_outlined),
                  onTap: () {
                    showLicensePage(
                        context: context,
                        applicationVersion: appInfo.version,
                        applicationLegalese: "©2020 Lorenzo Calisti");
                  },
                ),
                SettingsGroupItem(
                  text: "Version ${appInfo.version}(${appInfo.buildNumber})",
                  onLongPress: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("This is not an Easter Egg!"),
                      ),
                    );
                  },
                ),
                SettingsGroupItem(
                  text: "Made with ❤ from Italy.",
                ),
              ],
            ),
            SettingsGroup.single(
              title: "account",
              item: SettingsGroupItem(
                text: "Sign Out",
                icon: Icon(FeatherIcons.logOut, color: Colors.red),
                textColor: Colors.red,
                onTap: () async {
                  await context.read<AuthState>().logout();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
