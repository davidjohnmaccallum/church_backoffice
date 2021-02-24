import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  Layout({Key key}) : super(key: key);

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  bool sideNavExpanded = true;

  onExpandSideNav(bool expanded) {
    setState(() {
      sideNavExpanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(),
            Expanded(
              child: Row(
                children: [
                  SideNav(
                    expanded: sideNavExpanded,
                    onExpand: onExpandSideNav,
                    selectedNavItem: "Item 2",
                    navItems: [
                      NavItem("Item 1", Icon(Icons.plus_one), () => {}),
                      NavItem("Item 2", Icon(Icons.plus_one), () => {}),
                      NavItem("Item 3", Icon(Icons.plus_one), () => {}),
                      NavItem("Item 4", Icon(Icons.plus_one), () => {}),
                    ],
                  ),
                  Expanded(
                    child: Section(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  const Section({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          actions: [
            IconButton(icon: Icon(Icons.create), onPressed: () => {}),
            IconButton(icon: Icon(Icons.update), onPressed: () => {}),
            IconButton(icon: Icon(Icons.delete), onPressed: () => {}),
          ],
        ),
        Expanded(
          child: Container(color: Colors.green),
        ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final List<Widget> actions;

  const SectionHeader({
    Key key,
    this.actions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: SizedBox(
        height: 40,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Text("Section Title",
                  style: TextStyle(
                    fontSize: 20,
                  )),
              Spacer(),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}

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
    return SizedBox(
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
            onPressed: () => onExpand != null && onExpand(expanded),
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

class Header extends StatelessWidget {
  const Header({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
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
            ],
          ),
        ),
      ),
    );
  }
}
