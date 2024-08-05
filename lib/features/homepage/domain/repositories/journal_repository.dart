import 'package:fpdart/fpdart.dart';
import 'package:journal_local_app/features/homepage/domain/entities/journal.dart';

import '../../../../core/error/failure.dart';

abstract interface class JournalRepository {
  Future<Either<Failure, Journal>> saveJournal({
    required String title,
    required String body,
    required String imageUrl,
    required String date,
  });

  Future<Either<Failure, List<Journal>>> getJournalEntries();

  Future<Either<Failure, void>> deleteJournalEntry({required String title});
}
