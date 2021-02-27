import 'package:flutter/material.dart';

class AvatarMenuItem {
  AvatarMenuItem(this.text, this.onPressed);
  final String text;
  final Function() onPressed;
}

class AvatarMenu extends StatelessWidget {
  final Function onClose;
  final List<AvatarMenuItem> menuItems;

  const AvatarMenu({
    Key key,
    this.onClose,
    this.menuItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned(
          top: 60,
          right: 10,
          child: Container(
            color: Colors.white,
            width: 150,
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...menuItems.map((it) => buildAvatarMenuButton(it)).toList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  InkWell buildAvatarMenuButton(AvatarMenuItem menuItem) {
    return InkWell(
      onTap: menuItem.onPressed,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            menuItem.text,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
