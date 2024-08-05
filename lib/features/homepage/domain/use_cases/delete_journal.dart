import 'package:fpdart/src/either.dart';
import 'package:journal_local_app/core/error/failure.dart';
import 'package:journal_local_app/core/use_cases/use_case.dart';

import '../repositories/journal_repository.dart';

class DeleteJournal implements UseCase<void, DeleteJournalParams> {
  final JournalRepository journalRepository;
  DeleteJournal(this.journalRepository);
  @override
  Future<Either<Failure, void>> call(DeleteJournalParams params) async {
    await journalRepository.deleteJournalEntry(title: params.title);
    return const Right(null);
  }
}

class DeleteJournalParams {
  final String title;

  DeleteJournalParams({
    required this.title,
  });
}
