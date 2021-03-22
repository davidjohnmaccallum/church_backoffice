import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(t) {
  if (t == null) return null;
  if (t is! Timestamp) return t.toString();
  DateTime dt = (t as Timestamp).toDate();
  return DateFormat.yMMMd().format(dt);
}
