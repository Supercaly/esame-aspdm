import 'package:aspdm_project/domain/values/email_address.dart';
import 'package:aspdm_project/domain/values/password.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/presentation/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import '../../locator.dart';

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
    final focusScope = FocusScope.of(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(FeatherIcons.mail),
              filled: true,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => EmailAddress(value).value.fold(
                  (left) => "Invalid email!",
                  (right) => null,
                ),
            onEditingComplete: () => focusScope.nextFocus(),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 8.0),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePwd,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(FeatherIcons.lock),
              suffixIcon: IconButton(
                  icon: Icon(
                      _obscurePwd ? FeatherIcons.eyeOff : FeatherIcons.eye),
                  onPressed: () => setState(() => _obscurePwd = !_obscurePwd)),
              filled: true,
            ),
            validator: (value) => Password(value).value.fold(
                  (left) => "Password can't be empty!",
                  (right) => null,
                ),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (value) => focusScope.unfocus(),
          ),
          SizedBox(height: 8.0),
          RaisedButton(
            padding: const EdgeInsets.symmetric(horizontal: 82.0),
            child: Text("Log In"),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                locator<LogService>().debug(
                    "Trying logging in with Email: ${_emailController.text} "
                    "and Password: ${_passwordController.text}");
                (await context.read<AuthState>().login(
                        EmailAddress(_emailController.text),
                        Password(_passwordController.text)))
                    .fold(
                  (e) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error logging in!")),
                  ),
                  (_) {},
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
