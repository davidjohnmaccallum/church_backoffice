import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final List<Widget> actions;

  const SectionHeader({
    Key key,
    this.actions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
