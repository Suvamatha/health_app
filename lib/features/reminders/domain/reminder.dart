/// What a reminder is nudging the user about, beyond the built-in daily
/// hydration reminder.
enum ReminderType {
  medication,
  periodPrep,
  moodCheckIn,
  custom;

  String get label {
    switch (this) {
      case ReminderType.medication:
        return 'Meds / vitamins';
      case ReminderType.periodPrep:
        return 'Period prep';
      case ReminderType.moodCheckIn:
        return 'Mood check-in';
      case ReminderType.custom:
        return 'Custom';
    }
  }
}

/// A user-defined gentle reminder, scheduled through the local
/// notification system.
///
/// Hand-written as a plain immutable class (rather than @freezed) so this
/// feature doesn't depend on running build_runner code generation.
class Reminder {
  final String id;
  final int notificationId;
  final String label;
  final ReminderType type;
  final int hour;
  final int minute;
  final bool isEnabled;

  const Reminder({
    required this.id,
    required this.notificationId,
    required this.label,
    required this.type,
    required this.hour,
    required this.minute,
    required this.isEnabled,
  });

  Reminder copyWith({
    String? id,
    int? notificationId,
    String? label,
    ReminderType? type,
    int? hour,
    int? minute,
    bool? isEnabled,
  }) {
    return Reminder(
      id: id ?? this.id,
      notificationId: notificationId ?? this.notificationId,
      label: label ?? this.label,
      type: type ?? this.type,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'notificationId': notificationId,
        'label': label,
        'type': type.name,
        'hour': hour,
        'minute': minute,
        'isEnabled': isEnabled,
      };

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String,
      notificationId: json['notificationId'] as int,
      label: json['label'] as String,
      type: ReminderType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => ReminderType.custom,
      ),
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      isEnabled: json['isEnabled'] as bool,
    );
  }
}
