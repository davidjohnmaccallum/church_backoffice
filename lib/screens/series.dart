import 'package:church_backoffice/components/section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SeriesScreen extends StatelessWidget {
  const SeriesScreen({Key key}) : super(key: key);

  void onRowTap(id, context) {}

  @override
  Widget build(BuildContext context) {
    CollectionReference collection = FirebaseFirestore.instance.collection('series');

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
          title: "Series",
          actions: [
            IconButton(icon: Icon(Icons.create), onPressed: () => {}),
            IconButton(icon: Icon(Icons.update), onPressed: () => {}),
            IconButton(icon: Icon(Icons.delete), onPressed: () => {}),
          ],
          content: ListView(
            children: snapshot.data.docs
                .map((it) => ListTile(
                      leading: FadeInImage(
                        placeholder: AssetImage(
                          "assets/images/thumbnail_placeholder.png",
                        ),
                        image: NetworkImage(
                          it.data()['thumbnailUrl'],
                        ),
                      ),
                      title: Text(it.data()['title']),
                      subtitle: Text(it.data()['author']),
                      trailing: Icon(Icons.play_arrow),
                      onTap: () => onRowTap(it.id, context),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
