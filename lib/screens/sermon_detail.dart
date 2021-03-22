import 'package:church_backoffice/components/section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils.dart';

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
  Widget makeLinkText(String text, String link) {
    // return link != null ? Text("$text $link") : null;

    return RichText(
      text: new TextSpan(
        children: [
          new TextSpan(
            text: text + " ",
            style: new TextStyle(color: Colors.black),
          ),
          new TextSpan(
            text: link,
            style: new TextStyle(color: Colors.blue),
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                launch(link);
              },
          ),
        ],
      ),
    );
  }

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
            content: SingleChildScrollView(
              child: Container(
                width: 600,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInImage(
                      placeholder: AssetImage(
                        "assets/images/image_placeholder.png",
                      ),
                      image: NetworkImage(
                        data['imageUrl'] ?? "",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data['title'] ?? "Title not set",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(formatTimestamp(data['_date']) ?? "Date not set"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(data['author'] != null ? "By ${data['author']}" : "Author not set"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(data['description'] ?? "Description not set"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: makeLinkText("Main image", data['imageUrl']) ?? Text("Main image not set"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: makeLinkText("Thumbnail image", data['thumbnailUrl']) ?? Text("Thumbnail image not set"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: makeLinkText("Media", data['mediaUrl']) ?? Text("Media not set"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Center(child: Text("Loading"));
      },
    );
  }
}
