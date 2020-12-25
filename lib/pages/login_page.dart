import 'package:aspdm_project/pages/desktop/login_page_content_desktop.dart';
import 'package:aspdm_project/pages/mobile/login_page_content_mobile.dart';
import 'package:aspdm_project/states/auth_state.dart';
import 'package:aspdm_project/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<AuthState, bool>(
        selector: (_, state) => state.isLoading,
        builder: (context, loading, _) => LoadingOverlay(
          isLoading: loading,
          color: Colors.black45,
          child: Responsive(
            small: LoginPageContentMobile(),
            large: LoginPageContentDesktop(),
          ),
        ),
      ),
    );
  }
}
