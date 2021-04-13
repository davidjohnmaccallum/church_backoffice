import 'package:church_backoffice/components/section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SermonsScreen extends StatelessWidget {
  final Function(String) onRowTap;
  final Function onAdd;

  const SermonsScreen({Key key, this.onRowTap, this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference collection = FirebaseFirestore.instance.collection('sermons');

    return StreamBuilder<QuerySnapshot>(
      stream: collection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ' + snapshot.error.toString()),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading'));
        }

        return Section(
          key: PageStorageKey<String>('Sermons'),
          title: "Sermons",
          actions: [
            IconButton(icon: Icon(Icons.add), onPressed: onAdd),
            IconButton(icon: Icon(Icons.edit), onPressed: () => {}),
            IconButton(icon: Icon(Icons.delete), onPressed: null),
          ],
          content: ListView(
            children: snapshot.data.docs
                .map((it) => ListTile(
                      leading: FadeInImage(
                        placeholder: AssetImage(
                          "assets/images/thumbnail_placeholder.png",
                        ),
                        image: NetworkImage(
                          it.data()['thumbnailUrl'] ?? "",
                        ),
                      ),
                      title: Text(it.data()['title'] ?? ""),
                      subtitle: Text(it.data()['author'] ?? ""),
                      trailing: Icon(Icons.play_arrow),
                      onTap: () => onRowTap(it.id),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
