import 'package:app_settings/app_settings.dart';
import 'package:tasky/locator.dart';
import 'package:tasky/presentation/routes.dart';
import 'package:tasky/services/app_info_service.dart';
import 'package:tasky/services/log_service.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:tasky/application/states/auth_state.dart';
import 'package:tasky/presentation/widgets/responsive.dart';
import 'package:tasky/presentation/pages/settings/widgets/settings_widget.dart';
import 'package:tasky/presentation/pages/settings/widgets/user_info_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

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
            if (!kIsWeb)
              SettingsGroup.single(
                title: 'settings_notifications_title'.tr(),
                item: SettingsGroupItem(
                  text: 'settings_notifications_msg'.tr(),
                  icon: Icon(FeatherIcons.bell),
                  onTap: () async {
                    if (!kIsWeb) {
                      await AppSettings.openNotificationSettings();
                    }
                  },
                ),
              ),
            SettingsGroup.single(
              title: "settings_archive_title".tr(),
              item: SettingsGroupItem(
                text: 'settings_archive_msg'.tr(),
                icon: Icon(FeatherIcons.archive),
                onTap: () {
                  locator<NavigationService>().navigateTo(Routes.archive);
                },
              ),
            ),
            SettingsGroup(
              title: 'settings_about_title'.tr(),
              children: [
                SettingsGroupItem(
                  text: 'settings_about_msg'.tr(),
                  icon: Image.asset(
                    "assets/icons/ic_launcher.png",
                    width: 24,
                    height: 24,
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('about_title').tr(),
                      content: Text('about_msg').tr(),
                      actions: [
                        TextButton(
                          onPressed: () => locator<NavigationService>().pop(),
                          child: Text('got_it_btn').tr(),
                        ),
                      ],
                    ),
                  ),
                ),
                SettingsGroupItem(
                  text: 'settings_open_source'.tr(),
                  icon: Icon(Icons.adb_outlined),
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationVersion: appInfo.version,
                      applicationLegalese: 'copyright_msg'.tr(),
                    );
                  },
                ),
                SettingsGroupItem(
                  text: 'settings_version_msg'.tr(namedArgs: {
                    "version": appInfo.version,
                    "build": appInfo.buildNumber
                  }),
                  onLongPress: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('easter_egg_msg').tr(),
                      ),
                    );
                  },
                ),
                SettingsGroupItem(text: 'made_in_italy_msg'.tr()),
              ],
            ),
            SettingsGroup.single(
              title: 'settings_account_title'.tr(),
              item: SettingsGroupItem(
                text: 'settings_logout'.tr(),
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
