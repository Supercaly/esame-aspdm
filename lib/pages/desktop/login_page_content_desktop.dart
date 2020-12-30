import 'package:aspdm_project/generated/gen_colors.g.dart';
import 'package:aspdm_project/widgets/login_form.dart';
import 'package:flutter/material.dart';

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
                          "Log In",
                          style: Theme.of(context).textTheme.headline4,
                        ),
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
                  child: Image.asset(
                    "assets/icons/ic_launcher.png",
                    width: 250.0,
                    height: 250.0,
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
