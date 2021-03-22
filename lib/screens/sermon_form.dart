import 'package:church_backoffice/components/section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class SermonForm extends StatefulWidget {
  final Function(String) onClose;
  final String id;

  SermonForm({
    Key key,
    this.onClose,
    this.id,
  }) : super(key: key);

  @override
  _SermonFormState createState() => _SermonFormState();
}

class _SermonFormState extends State<SermonForm> {
  final _formKey = GlobalKey<FormState>();

  Function notEmptyValidator = (String value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  };

  @override
  Widget build(BuildContext context) {
    CollectionReference collection = FirebaseFirestore.instance.collection('sermons');
    Map<String, dynamic> record;
    String errorMessage = "";

    onSubmit() {
      // TODO: Debounce
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        collection.add(record).then((value) {
          print(value);
          if (widget.onClose != null) widget.onClose(widget.id);
        }).catchError((error) {
          setState(() {
            errorMessage = error.toString();
          });
        });
      }
    }

    return FutureBuilder<DocumentSnapshot>(
      future: widget.id != null ? collection.doc(widget.id).get() : collection.doc().get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          record = snapshot.data.data() ?? {};
          return Section(
            title: "Sermon",
            actions: [
              IconButton(icon: Icon(Icons.save), onPressed: onSubmit),
              IconButton(icon: Icon(Icons.cancel), onPressed: () => widget.onClose(widget.id)),
            ],
            content: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                    TextFormField(
                      initialValue: record['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      onSaved: (value) {
                        record['title'] = value;
                      },
                      onFieldSubmitted: (_) => onSubmit(),
                      validator: notEmptyValidator,
                    ),
                    TextFormField(
                      initialValue: record['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      onSaved: (value) {
                        record['description'] = value;
                      },
                      onFieldSubmitted: (_) => onSubmit(),
                      validator: notEmptyValidator,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                    TextFormField(
                      initialValue: record['author'],
                      decoration: InputDecoration(
                        labelText: 'Author',
                      ),
                      onSaved: (value) {
                        record['author'] = value;
                      },
                      onFieldSubmitted: (_) => onSubmit(),
                      validator: notEmptyValidator,
                    ),
                    TextFormField(
                      initialValue: formatTimestamp(record['_date']),
                      decoration: InputDecoration(
                        labelText: 'Date',
                      ),
                      onSaved: (value) {
                        DateTime dt = DateTime.parse(value);
                        record['_date'] = Timestamp.fromDate(dt);
                      },
                      onFieldSubmitted: (_) => onSubmit(),
                      validator: (value) {
                        try {
                          DateTime.parse(value);
                          return null;
                        } catch (_) {
                          return "Not a valid date";
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: record['imageUrl'],
                      decoration: InputDecoration(
                        labelText: 'Image',
                      ),
                      onSaved: (value) {
                        record['imageUrl'] = value;
                      },
                      onFieldSubmitted: (_) => onSubmit(),
                      validator: notEmptyValidator,
                    ),
                    TextFormField(
                      initialValue: record['thumbnailUrl'],
                      decoration: InputDecoration(
                        labelText: 'Thumbnail Image',
                      ),
                      onSaved: (value) {
                        record['thumbnailUrl'] = value;
                      },
                      onFieldSubmitted: (_) => onSubmit(),
                      validator: notEmptyValidator,
                    ),
                    TextFormField(
                      initialValue: record['mediaUrl'],
                      decoration: InputDecoration(
                        labelText: 'Media',
                      ),
                      onSaved: (value) {
                        record['mediaUrl'] = value;
                      },
                      onFieldSubmitted: (_) => onSubmit(),
                      validator: notEmptyValidator,
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
