import 'package:fpdart/src/either.dart';
import 'package:journal_local_app/core/error/failure.dart';
import 'package:journal_local_app/core/use_cases/use_case.dart';
import 'package:journal_local_app/features/homepage/domain/entities/journal.dart';

import '../repositories/journal_repository.dart';

class GetJournal implements UseCase<List<Journal>, NoParams> {
  final JournalRepository journalRepository;
  GetJournal(this.journalRepository);

  @override
  Future<Either<Failure, List<Journal>>> call(NoParams params) async {
    return await journalRepository.getJournalEntries();
  }
}
