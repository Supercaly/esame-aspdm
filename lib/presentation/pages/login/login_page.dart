import 'package:tasky/presentation/pages/login/widgets/login_page_content_desktop.dart';
import 'package:tasky/presentation/pages/login/widgets/login_page_content_mobile.dart';
import 'package:tasky/application/states/auth_state.dart';
import 'package:tasky/presentation/widgets/responsive.dart';
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
