import 'package:flutter/material.dart';

import 'section_header.dart';

class Section extends StatelessWidget {
  const Section({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 1.0,
          child: SectionHeader(
            actions: [
              IconButton(icon: Icon(Icons.create), onPressed: () => {}),
              IconButton(icon: Icon(Icons.update), onPressed: () => {}),
              IconButton(icon: Icon(Icons.delete), onPressed: () => {}),
            ],
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }
}
