import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final Function onAvatarTap;
  final User user;

  const Header({
    Key key,
    this.onAvatarTap,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.circle),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Church Backoffice",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: onAvatarTap,
                child: CircleAvatar(
                  foregroundImage: AssetImage("assets/images/avatar.jpg"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
