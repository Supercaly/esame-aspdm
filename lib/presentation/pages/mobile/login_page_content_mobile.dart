import 'package:aspdm_project/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';

class LoginPageContentMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) => ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth,
              maxHeight: constraints.maxHeight,
            ),
            child: Card(
              margin: const EdgeInsets.all(25.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/icons/ic_launcher.png",
                      width: 100.0,
                      height: 100.0,
                    ),
                    SizedBox(height: 16.0),
                    LoginForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
