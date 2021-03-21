import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'avatar_menu.dart';
import 'header.dart';
import 'side_nav.dart';

class Layout extends StatefulWidget {
  final onProfilePressed;
  final onLogoutPressed;
  final List<NavItem> sideNavItems;
  final Widget content;
  final String selectedSideNavItem;

  Layout({
    Key key,
    this.onProfilePressed,
    this.onLogoutPressed,
    this.sideNavItems,
    this.content,
    this.selectedSideNavItem,
  }) : super(key: key);

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  bool isSideNavExpanded = true;
  bool isAvatarMenuShowing = false;
  User user;
  SharedPreferences prefs;

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

    SharedPreferences.getInstance().then((prefs) {
      this.prefs = prefs;
      setState(() {
        isSideNavExpanded = prefs.getBool("side_nav_expanded") ?? true;
      });
    });

    super.initState();
  }

  onExpandSideNav(bool expanded) {
    setState(() {
      isSideNavExpanded = !expanded;
    });
    if (prefs != null) {
      prefs.setBool("side_nav_expanded", !expanded);
    }
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
                        child: widget.content ?? Container(),
                      ),
                      Material(
                        elevation: 3,
                        child: SideNav(
                          expanded: isSideNavExpanded,
                          onExpand: onExpandSideNav,
                          selectedNavItem: widget.selectedSideNavItem,
                          navItems: widget.sideNavItems ?? [],
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
