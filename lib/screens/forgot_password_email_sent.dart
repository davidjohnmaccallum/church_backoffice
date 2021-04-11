import 'package:flutter/material.dart';

class ForgotEmailSentScreen extends StatelessWidget {
  final void Function(BuildContext) onClosePressed;

  ForgotEmailSentScreen({
    Key key,
    this.onClosePressed,
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
                    child: Text("We have sent you an email with instructions to reset your password.")),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (onClosePressed == null) return;
                        onClosePressed(context);
                      },
                      child: Text("Close"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
