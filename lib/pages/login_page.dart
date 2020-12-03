import 'package:aspdm_project/generated/gen_colors.g.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool _obscurePassword;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _obscurePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EasyColors.primary,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(25.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Placeholder(fallbackHeight: 128.0),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(horizontal: 82.0),
                    child: Text("Log In"),
                    onPressed: () {
                      locator<LogService>().info(
                          "Email: ${_emailController.text} Password: ${_passwordController.text}");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
