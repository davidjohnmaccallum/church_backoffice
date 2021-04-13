import 'package:church_backoffice/components/section.dart';
import 'package:church_backoffice/models/Sermon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class SermonsScreen extends StatelessWidget {
  final Function(String) onRowTap;
  final Function onAdd;

  const SermonsScreen({Key key, this.onRowTap, this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Sermon.stream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> query) {
        if (query.hasError) {
          return Center(
            child: Text('Error: ' + query.error.toString()),
          );
        }

        if (query.connectionState == ConnectionState.waiting) {
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
            children: query.data.docs
                .map(Sermon.map)
                .map((data) => ListTile(
                      leading: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: data.thumbnailUrl ?? '',
                      ),
                      title: Text(data.title ?? ''),
                      subtitle: Text(data.author ?? ''),
                      trailing: Icon(Icons.play_arrow),
                      onTap: () => onRowTap(data.id),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
