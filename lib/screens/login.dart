import 'package:church_backoffice/screens/register.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final onLoginPressed;
  final onForgotPressed;
  final onRegisterPressed;
  final onGoogleAuthPressed;
  final onFacebookAuthPressed;

  const LoginScreen({
    Key key,
    this.onLoginPressed,
    this.onForgotPressed,
    this.onRegisterPressed,
    this.onGoogleAuthPressed,
    this.onFacebookAuthPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Container(
            width: 300,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email address",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        if (onLoginPressed == null) return;
                        onLoginPressed(context);
                      },
                      child: Text("Login"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        if (onForgotPressed == null) return;
                        onForgotPressed(context);
                      },
                      child: Text("I forgot my password"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Don't have an account?"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (onRegisterPressed == null) return;
                        onRegisterPressed(context);
                      },
                      child: Text("Register"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Or log in using"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: onGoogleAuthPressed,
                        child: Text("Google"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: onFacebookAuthPressed,
                        child: Text("Facebook"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
