import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'avatar_menu.dart';
import 'header.dart';
import 'section.dart';
import 'side_nav.dart';

class Layout extends StatefulWidget {
  final onProfilePressed;
  final onLogoutPressed;

  Layout({
    Key key,
    this.onProfilePressed,
    this.onLogoutPressed,
  }) : super(key: key);

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  bool isSideNavExpanded = true;
  bool isAvatarMenuShowing = false;
  User user;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      setState(() {
        this.user = user;
      });
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print("User is signed in! $user");
      }
    });
    super.initState();
  }

  onExpandSideNav(bool expanded) {
    setState(() {
      isSideNavExpanded = !expanded;
    });
  }

  onAvatarTap() {
    setState(() {
      isAvatarMenuShowing = !isAvatarMenuShowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Column(
              verticalDirection: VerticalDirection.up,
              children: [
                Expanded(
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: Section(),
                      ),
                      Material(
                        elevation: 3,
                        child: SideNav(
                          expanded: isSideNavExpanded,
                          onExpand: onExpandSideNav,
                          selectedNavItem: "Item 2",
                          navItems: [
                            NavItem("Item 1", Icon(Icons.plus_one), () => {}),
                            NavItem("Item 2", Icon(Icons.plus_one), () => {}),
                            NavItem("Item 3", Icon(Icons.plus_one), () => {}),
                            NavItem("Item 4", Icon(Icons.plus_one), () => {}),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  elevation: 1.0,
                  child: Header(
                    user: user,
                    onAvatarTap: onAvatarTap,
                  ),
                ),
              ],
            ),
          ),
          isAvatarMenuShowing
              ? AvatarMenu(
                  onClose: onAvatarTap,
                  menuItems: [
                    AvatarMenuItem("Profile", widget.onProfilePressed),
                    AvatarMenuItem("Logout", widget.onLogoutPressed),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
