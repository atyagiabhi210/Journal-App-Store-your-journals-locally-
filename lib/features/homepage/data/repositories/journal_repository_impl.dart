import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/journal.dart';
import '../../domain/repositories/journal_repository.dart';
import '../data_sources/journal_local_data_source.dart';
import '../models/journal_model.dart';

class JournalRepositoryImpl implements JournalRepository {
  final JournalLocalDataSource journalLocalDataSource;

  JournalRepositoryImpl(this.journalLocalDataSource);

  @override
  Future<Either<Failure, Journal>> saveJournal({
    required String title,
    required String body,
    required String imageUrl,
    required String date,
  }) async {
    try {
      JournalModel journalModel = JournalModel(
        title: title,
        body: body,
        date: date,
        imageUrl: imageUrl,
      );
      await journalLocalDataSource.saveJournal(journalModel);
      return Right(Journal(
        title: title,
        body: body,
        date: date,
        imageUrl: imageUrl,
      ));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteJournalEntry({required String title}) async {
    try {
      await journalLocalDataSource.deleteJournal(title);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Journal>>> getJournalEntries() async {
    try {
      final res = await journalLocalDataSource.getJournalEntries();
      return Right(res);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
