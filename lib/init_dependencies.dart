import 'package:get_it/get_it.dart';
import 'package:journal_local_app/features/homepage/data/data_sources/journal_local_data_source.dart';
import 'package:journal_local_app/features/homepage/data/repositories/journal_repository_impl.dart';
import 'package:journal_local_app/features/homepage/domain/repositories/journal_repository.dart';
import 'package:journal_local_app/features/homepage/domain/use_cases/delete_journal.dart';
import 'package:journal_local_app/features/homepage/domain/use_cases/save_journal.dart';
import 'package:journal_local_app/features/homepage/presentation/bloc/home_bloc.dart';
import 'package:journal_local_app/services/database_service.dart';

import 'features/homepage/domain/use_cases/get_journal.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initJournal();
  serviceLocator
      .registerLazySingleton<DatabaseService>(() => DatabaseService());
}

void _initJournal() {
  ///data source
  serviceLocator
    ..registerFactory<JournalLocalDataSource>(
      () => JournalLocalDataSourceImpl(
        serviceLocator(),
      ),
    )

    ///repository
    ..registerFactory<JournalRepository>(
      () => JournalRepositoryImpl(
        serviceLocator(),
      ),
    )

    /// use cases
    ..registerFactory(
      () => SaveJournal(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteJournal(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetJournal(
        serviceLocator(),
      ),
    )

    ///home bloc
    ..registerLazySingleton(() => HomeBloc(
          saveJournal: serviceLocator(),
          deleteJournal: serviceLocator(),
          getJournal: serviceLocator(),
        ));
}
