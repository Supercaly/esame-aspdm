import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../locator.dart';

/// Widget that displays a login form and handles all the login logic.
/// This widget will show a text field of email a password and
/// a login button. The password field has the ability to show the
/// password or hide it with black dots.
class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  static const String _emailRegex =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool _obscurePwd;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _obscurePwd = true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.email),
              filled: true,
            ),
            keyboardType: TextInputType.emailAddress,
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
            obscureText: _obscurePwd,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                  icon: Icon(
                      _obscurePwd ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePwd = !_obscurePwd)),
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
                if (!await context
                    .read<AuthState>()
                    .login(_emailController.text, _passwordController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error logging in!")));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
