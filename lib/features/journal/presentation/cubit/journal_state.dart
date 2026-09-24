class JournalState {
  final bool isLoading;
  final String text;
  final bool isSaving;

  const JournalState({
    this.isLoading = true,
    this.text = '',
    this.isSaving = false,
  });

  JournalState copyWith({
    bool? isLoading,
    String? text,
    bool? isSaving,
  }) {
    return JournalState(
      isLoading: isLoading ?? this.isLoading,
      text: text ?? this.text,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
