import 'package:church_backoffice/components/section.dart';
import 'package:church_backoffice/models/Sermon.dart';
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
    return FutureBuilder<Sermon>(
      future: Sermon.get(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Sermon sermon = snapshot.data;
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
                        sermon.imageUrl ?? "",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        sermon.title ?? "Title not set",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(formatDateTime(sermon.date) ?? "Date not set"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(sermon.author != null ? "By ${sermon.author}" : "Author not set"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(sermon.description ?? "Description not set"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: makeLinkText("Main image", sermon.imageUrl) ?? Text("Main image not set"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: makeLinkText("Thumbnail image", sermon.thumbnailUrl) ?? Text("Thumbnail image not set"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: makeLinkText("Media", sermon.mediaUrl) ?? Text("Media not set"),
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
