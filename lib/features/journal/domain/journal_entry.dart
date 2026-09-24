/// A free-text reflection tied to a specific calendar day.
///
/// Hand-written as a plain immutable class (rather than @freezed) so this
/// feature doesn't depend on running build_runner code generation.
class JournalEntry {
  final String id;
  final DateTime date;
  final String text;
  final DateTime updatedAt;

  const JournalEntry({
    required this.id,
    required this.date,
    required this.text,
    required this.updatedAt,
  });

  JournalEntry copyWith({
    String? id,
    DateTime? date,
    String? text,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      text: text ?? this.text,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'text': text,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      text: json['text'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JournalEntry &&
            other.id == id &&
            other.date == date &&
            other.text == text &&
            other.updatedAt == updatedAt);
  }

  @override
  int get hashCode => Object.hash(id, date, text, updatedAt);
}
