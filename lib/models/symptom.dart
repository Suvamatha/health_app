enum Symptom {
  cramps,
  headache,
  fatigue,
  bloating,
  moodSwings,
  backache;

  String get label{
    switch (this) {
      case Symptom.cramps:
        return 'Cramps';
      case Symptom.headache:
        return 'Headache';
      case Symptom.fatigue:
        return 'Fatigue';
      case Symptom.bloating:
        return 'Bloating';
      case Symptom.backache:
        return 'Backache';
      case Symptom.moodSwings:
       return 'Mood swings';
    }
  }
}