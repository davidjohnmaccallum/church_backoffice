import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPasswordForm extends StatefulWidget {
  final void Function(String, BuildContext) onSendEmailPressed;
  final String errorMessage;

  ForgotPasswordForm({
    Key key,
    this.onSendEmailPressed,
    this.errorMessage,
  }) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  String _email;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Container(
              width: 300,
              child: Column(
                children: [
                  widget.errorMessage != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.errorMessage,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        if (!EmailValidator.validate(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        _email = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email address",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            if (widget.onSendEmailPressed == null) return;
                            widget.onSendEmailPressed(_email, context);
                          }
                        },
                        child: Text("Send password reset email"),
                      ),
                    ),
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
