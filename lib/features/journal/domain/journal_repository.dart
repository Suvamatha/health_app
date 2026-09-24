import 'journal_entry.dart';

abstract class JournalRepository {
  Future<JournalEntry?> getEntryForDate(DateTime date);
  Future<void> saveEntry(JournalEntry entry);
  Future<void> deleteEntryForDate(DateTime date);
  Future<List<JournalEntry>> getAllEntries();
}
