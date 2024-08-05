import 'dart:developer';

import 'package:journal_local_app/features/homepage/data/models/journal_model.dart';
import 'package:journal_local_app/services/database_service.dart';

import '../../domain/entities/journal.dart';

abstract interface class JournalLocalDataSource {
  Future<void> saveJournal(JournalModel journal);
  Future<void> deleteJournal(String title);
  Future<List<Journal>> getJournalEntries();
}

class JournalLocalDataSourceImpl implements JournalLocalDataSource {
  final DatabaseService databaseService;
  JournalLocalDataSourceImpl(this.databaseService);

  @override
  Future<void> saveJournal(JournalModel journal) async {
    try {
      await databaseService.addJournalEntry(journal: journal);
      log('Journal saved successfully');
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteJournal(String title) async {
    await databaseService.deleteJournal(title);
  }

  @override
  Future<List<Journal>> getJournalEntries() async {
    try {
      final res = await databaseService.getJournalEntries();
      return res;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
