import 'package:flutter/material.dart';

import 'section_header.dart';

class Section extends StatelessWidget {
  final List<Widget> actions;
  final Widget content;
  final String title;

  const Section({
    Key key,
    this.actions,
    this.content,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 1.0,
          child: SectionHeader(
            title: title,
            actions: actions ?? [],
          ),
        ),
        Expanded(
          child: content ?? Container(),
        ),
      ],
    );
  }
}
