/// Utility for parsing and formatting date strings from the API.
class DateFormatter {
  DateFormatter._();

  /// Tries to parse a raw date string into a [DateTime].
  /// Returns null if parsing fails.
  static DateTime? tryParse(String raw) {
    if (raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  /// Formats a raw date string as "dd/MM/yyyy".
  /// Falls back to the original string if parsing fails.
  static String formatDate(String raw) {
    final dt = tryParse(raw);
    if (dt == null) return raw;
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }

  /// Formats a raw date string as "HH:mm".
  /// Falls back to the original string if parsing fails.
  static String formatTime(String raw) {
    final dt = tryParse(raw);
    if (dt == null) return raw;
    return '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  /// Formats a raw date string as "dd/MM/yyyy  ·  HH:mm".
  /// Falls back to the original string if parsing fails.
  static String formatDateAndTime(String raw) {
    final dt = tryParse(raw);
    if (dt == null) return raw;
    return '${formatDate(raw)}  ·  ${formatTime(raw)}';
  }
}
