import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class TimestampDateTimeConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampDateTimeConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is Timestamp) return json.toDate();
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    if (json is String) return DateTime.tryParse(json);
    throw ArgumentError('Unsupported timestamp type: ${json.runtimeType}');
  }

  @override
  Object? toJson(DateTime? object) {
    return object == null ? null : Timestamp.fromDate(object);
  }
}
