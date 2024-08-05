import 'package:fpdart/src/either.dart';
import 'package:journal_local_app/core/error/failure.dart';
import 'package:journal_local_app/core/use_cases/use_case.dart';
import 'package:journal_local_app/features/homepage/domain/entities/journal.dart';

import '../repositories/journal_repository.dart';

class SaveJournal implements UseCase<Journal, SaveJournalParams> {
  final JournalRepository journalRepository;
  SaveJournal(this.journalRepository);
  @override
  Future<Either<Failure, Journal>> call(SaveJournalParams params) async {
    return await journalRepository.saveJournal(
      title: params.title,
      body: params.body,
      imageUrl: params.imageUrl,
      date: params.date,
    );
  }
}

class SaveJournalParams {
  final String title;
  final String body;
  final String imageUrl;
  final String date;

  SaveJournalParams({
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.date,
  });
}
