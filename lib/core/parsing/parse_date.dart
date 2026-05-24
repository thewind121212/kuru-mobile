/// Parses a date field that may be:
///   - already a [DateTime]
///   - an ISO 8601 [String]
///   - a protobuf `Timestamp` Map (`{seconds, nanos}`) returned by the
///     gen-barcode BE for `google.protobuf.Timestamp` fields
///
/// Returns null if the value is null, missing, or cannot be parsed.
DateTime? parseProtoDate(Object? raw) {
  if (raw == null) return null;
  if (raw is DateTime) return raw;
  if (raw is String) return DateTime.tryParse(raw);
  if (raw is Map) {
    final seconds = raw['seconds'];
    final nanos = raw['nanos'];
    if (seconds is num) {
      return DateTime.fromMillisecondsSinceEpoch(
        seconds.toInt() * 1000 + ((nanos is num) ? nanos ~/ 1000000 : 0),
        isUtc: true,
      );
    }
  }
  return null;
}

/// Same as [parseProtoDate] but throws [FormatException] when the value is
/// missing or unparseable. Use for required date fields.
DateTime parseProtoDateRequired(Object? raw, {required String field}) {
  final parsed = parseProtoDate(raw);
  if (parsed == null) {
    throw FormatException('Cannot parse date for "$field": $raw');
  }
  return parsed;
}
