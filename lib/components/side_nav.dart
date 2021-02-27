import 'package:flutter/material.dart';

class NavItem {
  NavItem(this.text, this.icon, this.onPressed);
  final String text;
  final Icon icon;
  final Function() onPressed;
}

class SideNav extends StatelessWidget {
  final bool expanded;
  final Function onExpand;
  final List<NavItem> navItems;
  final String selectedNavItem;

  const SideNav({
    Key key,
    this.expanded = true,
    this.onExpand,
    this.navItems = const [],
    this.selectedNavItem = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: expanded ? 200 : 40,
      child: Column(
        children: [
          ...navItems
              .map((it) => buildNavItemWidget(
                    navItem: it,
                    selected: it.text == selectedNavItem,
                  ))
              .toList(),
          Spacer(),
          IconButton(
            icon: Icon(expanded ? Icons.chevron_left : Icons.chevron_right),
            onPressed: () {
              if (onExpand != null) onExpand(expanded);
            },
          ),
        ],
      ),
    );
  }

  Widget buildNavItemWidget({NavItem navItem, bool selected = false}) => GestureDetector(
        onTap: navItem.onPressed,
        child: Container(
          color: selected ? Colors.blue[100] : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                navItem.icon,
                expanded
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(navItem.text,
                            style: TextStyle(
                              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 20,
                            )),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      );
}
