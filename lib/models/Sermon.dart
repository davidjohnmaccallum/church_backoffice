import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils.dart';

class Sermon {
  String id;
  DateTime date;
  String title;
  String author;
  String description;
  String imageUrl;
  String mediaUrl;
  String thumbnailUrl;

  static Stream<QuerySnapshot> stream() {
    CollectionReference collection = FirebaseFirestore.instance.collection('sermons');
    return collection.snapshots();
  }

  static Function map = (QueryDocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data();
    Sermon result = new Sermon();
    result.id = doc.id;
    result.date = parseTimestamp(data['_date']);
    result.title = data['title'];
    result.author = data['author'];
    result.description = data['description'];
    result.imageUrl = data['imageUrl'];
    result.mediaUrl = data['mediaUrl'];
    result.thumbnailUrl = data['thumbnailUrl'];
    return result;
  };
}
