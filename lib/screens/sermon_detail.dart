import 'package:church_backoffice/components/section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SermonDetail extends StatefulWidget {
  final Function onClose;
  final Function(String) onEdit;
  final String id;

  SermonDetail({
    Key key,
    this.onClose,
    this.id,
    this.onEdit,
  }) : super(key: key);

  @override
  _SermonDetailState createState() => _SermonDetailState();
}

class _SermonDetailState extends State<SermonDetail> {
  @override
  Widget build(BuildContext context) {
    CollectionReference collection = FirebaseFirestore.instance.collection('sermons');

    return FutureBuilder<DocumentSnapshot>(
      future: collection.doc(widget.id).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          var data = snapshot.data.data();
          return Section(
            title: "Sermon",
            actions: [
              IconButton(icon: Icon(Icons.edit), onPressed: () => widget.onEdit(widget.id)),
              IconButton(icon: Icon(Icons.cancel), onPressed: widget.onClose),
            ],
            content: Column(
              children: [
                Text(data['title'] ?? ""),
                Text(data['_date'] != null ? data['_date'].toString() : ""),
                Text(data['author'] ?? ""),
                Text(data['description'] ?? ""),
                Text(data['imageUrl'] ?? ""),
                Text(data['thumbnailUrl'] ?? ""),
                Text(data['mediaUrl'] ?? ""),
              ],
            ),
          );
        }

        return Center(child: Text("Loading"));
      },
    );
  }
}
