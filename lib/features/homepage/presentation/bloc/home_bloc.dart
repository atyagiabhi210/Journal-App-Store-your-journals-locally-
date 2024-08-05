import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_local_app/features/homepage/domain/entities/journal.dart';
import 'package:journal_local_app/features/homepage/domain/use_cases/get_journal.dart';
import 'package:journal_local_app/features/homepage/domain/use_cases/save_journal.dart';

import '../../../../core/use_cases/use_case.dart';
import '../../domain/use_cases/delete_journal.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SaveJournal _saveJournal;
  final DeleteJournal _deleteJournal;
  final GetJournal _getJournal;

  HomeBloc({
    required SaveJournal saveJournal,
    required DeleteJournal deleteJournal,
    required GetJournal getJournal,
  })  : _saveJournal = saveJournal,
        _deleteJournal = deleteJournal,
        _getJournal = getJournal,
        super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      await _mapEventToState(event, emit);
    });
  }

  Future<void> _mapEventToState(
      HomeEvent event, Emitter<HomeState> emit) async {
    if (event is HomeJournalEntryAdded) {
      await _onJournalEntryAdded(event, emit);
    } else if (event is HomeJournalEntryDeleted) {
      await _onJournalEntryDeleted(event, emit);
    } else if (event is HomeJournalEntriesRequested) {
      await _onJournalEntriesRequested(event, emit);
    }
  }

  Future<void> _onJournalEntryAdded(
    HomeJournalEntryAdded event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final eitherResult = await _saveJournal(
        SaveJournalParams(
          title: event.journal.title,
          body: event.journal.body,
          imageUrl: event.journal.imageUrl,
          date: event.journal.date,
        ),
      );

      await eitherResult.fold(
        (failure) async {
          emit(HomeError(failure.toString()));
        },
        (success) async {
          final journalEntries = await _getJournal(NoParams());
          await journalEntries.fold(
            (failure) async {
              emit(HomeError(failure.toString()));
            },
            (entries) async {
              emit(HomeLoaded(entries));
            },
          );
        },
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onJournalEntryDeleted(
    HomeJournalEntryDeleted event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final eitherResult =
          await _deleteJournal(DeleteJournalParams(title: event.title));

      await eitherResult.fold(
        (failure) async {
          emit(HomeError(failure.toString()));
        },
        (success) async {
          final journalEntries = await _getJournal(NoParams());
          await journalEntries.fold(
            (failure) async {
              emit(HomeError(failure.toString()));
            },
            (entries) async {
              if (entries.isEmpty) {
                emit(HomeInitial());
              }
              emit(HomeLoaded(entries));
            },
          );
        },
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onJournalEntriesRequested(
    HomeJournalEntriesRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final journalEntries = await _getJournal(NoParams());
      await journalEntries.fold(
        (failure) async {
          emit(HomeError(failure.toString()));
        },
        (entries) async {
          emit(HomeLoaded(entries));
        },
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
