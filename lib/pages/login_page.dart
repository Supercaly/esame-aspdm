import 'package:aspdm_project/generated/gen_colors.g.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const String _emailRegex =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  GlobalKey<FormState> _formKey = GlobalKey();
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
              key: _formKey,
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
                    validator: (value) {
                      if (!RegExp(_emailRegex).hasMatch(value))
                        return "Invalid email!";
                      else
                        return null;
                    },
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
                    validator: (value) {
                      if (value.isEmpty)
                        return "Password can't be empty!";
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 8.0),
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(horizontal: 82.0),
                    child: Text("Log In"),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        locator<LogService>().info(
                            "Email: ${_emailController.text} Password: ${_passwordController.text}");
                        if (!await context.read<AuthState>().login(
                            _emailController.text, _passwordController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error logging in!")));
                        }
                      }
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
