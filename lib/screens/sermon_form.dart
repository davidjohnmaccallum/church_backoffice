import 'package:church_backoffice/components/section.dart';
import 'package:church_backoffice/models/Sermon.dart';
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
    Sermon sermon;
    String errorMessage = "";

    onSubmit() {
      // TODO: Debounce
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        sermon.save().then((_) {
          if (widget.onClose != null) widget.onClose(widget.id);
        }).catchError((error) {
          setState(() {
            errorMessage = error.toString();
          });
        });
      }
    }

    return FutureBuilder<Sermon>(
      future: widget.id != null ? Sermon.get(widget.id) : Sermon(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          sermon = snapshot.data;
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
                      initialValue: sermon.title,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      onSaved: (value) {
                        sermon.title = value;
                      },
                      onFieldSubmitted: (_) => onSubmit(),
                      validator: notEmptyValidator,
                    ),
                    TextFormField(
                      initialValue: sermon.description,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      onSaved: (value) {
                        sermon.description = value;
                      },
                      onFieldSubmitted: (_) => onSubmit(),
                      validator: notEmptyValidator,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                    TextFormField(
                      initialValue: sermon.author,
                      decoration: InputDecoration(
                        labelText: 'Author',
                      ),
                      onSaved: (value) {
                        sermon.author = value;
                      },
                      onFieldSubmitted: (_) => onSubmit(),
                      validator: notEmptyValidator,
                    ),
                    TextFormField(
                      initialValue: formatDateTime(sermon.date),
                      decoration: InputDecoration(
                        labelText: 'Date',
                      ),
                      onSaved: (value) {
                        sermon.date = DateTime.parse(value);
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
                      initialValue: sermon.imageUrl,
                      decoration: InputDecoration(
                        labelText: 'Image',
                      ),
                      onSaved: (value) {
                        sermon.imageUrl = value;
                      },
                      onFieldSubmitted: (_) => onSubmit(),
                      validator: notEmptyValidator,
                    ),
                    TextFormField(
                      initialValue: sermon.thumbnailUrl,
                      decoration: InputDecoration(
                        labelText: 'Thumbnail Image',
                      ),
                      onSaved: (value) {
                        sermon.thumbnailUrl = value;
                      },
                      onFieldSubmitted: (_) => onSubmit(),
                      validator: notEmptyValidator,
                    ),
                    TextFormField(
                      initialValue: sermon.mediaUrl,
                      decoration: InputDecoration(
                        labelText: 'Media',
                      ),
                      onSaved: (value) {
                        sermon.mediaUrl = value;
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
