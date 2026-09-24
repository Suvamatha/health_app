/// How rested the user felt -- kept as a simple, low-friction rating
/// rather than asking for precise sleep-stage data.
enum SleepQuality {
  poor,
  fair,
  good,
  great;

  String get label {
    switch (this) {
      case SleepQuality.poor:
        return 'Poor';
      case SleepQuality.fair:
        return 'Fair';
      case SleepQuality.good:
        return 'Good';
      case SleepQuality.great:
        return 'Great';
    }
  }
}

/// A single day's sleep log.
///
/// Hand-written as a plain immutable class (rather than @freezed) so this
/// feature doesn't depend on running build_runner code generation.
class SleepEntry {
  final String id;
  final DateTime loggedAt;
  final double hours;
  final SleepQuality quality;

  const SleepEntry({
    required this.id,
    required this.loggedAt,
    required this.hours,
    required this.quality,
  });

  SleepEntry copyWith({
    String? id,
    DateTime? loggedAt,
    double? hours,
    SleepQuality? quality,
  }) {
    return SleepEntry(
      id: id ?? this.id,
      loggedAt: loggedAt ?? this.loggedAt,
      hours: hours ?? this.hours,
      quality: quality ?? this.quality,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'loggedAt': loggedAt.toIso8601String(),
        'hours': hours,
        'quality': quality.name,
      };

  factory SleepEntry.fromJson(Map<String, dynamic> json) {
    return SleepEntry(
      id: json['id'] as String,
      loggedAt: DateTime.parse(json['loggedAt'] as String),
      hours: (json['hours'] as num).toDouble(),
      quality: SleepQuality.values.firstWhere(
        (q) => q.name == json['quality'],
        orElse: () => SleepQuality.fair,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SleepEntry &&
            other.id == id &&
            other.loggedAt == loggedAt &&
            other.hours == hours &&
            other.quality == quality);
  }

  @override
  int get hashCode => Object.hash(id, loggedAt, hours, quality);
}
