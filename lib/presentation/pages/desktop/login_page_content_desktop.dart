import 'package:tasky/presentation/generated/gen_colors.g.dart';
import 'package:tasky/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../theme.dart';

class LoginPageContentDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Theme(
              data: Theme.of(context).brightness == Brightness.light
                  ? lightThemeDesktop
                  : darkThemeDesktop,
              child: Card(
                margin: const EdgeInsets.all(32.0),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    width: 400.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'login_btn',
                          style: Theme.of(context).textTheme.headline4,
                        ).tr(),
                        SizedBox(height: 24.0),
                        LoginForm(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: EasyColors.secondary,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(180.0),
                      border: Border.all(
                        color: Color(0xFFE5E5E5),
                        width: 3,
                      ),
                    ),
                    child: Image.asset(
                      "assets/icons/ic_launcher.png",
                      width: 250.0,
                      height: 250.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
