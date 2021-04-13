import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

DateTime parseTimestamp(t) {
  if (t == null) return null;
  if (t is! Timestamp) return null;
  return t.toDate();
}

String formatTimestamp(t) {
  DateTime dt = parseTimestamp(t);
  if (dt == null) return null;
  return DateFormat.yMMMd().format(dt);
}
