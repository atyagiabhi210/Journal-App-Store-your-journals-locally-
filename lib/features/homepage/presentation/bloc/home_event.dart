part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}


final class HomeJournalEntryAdded extends HomeEvent {
  final Journal journal;

  HomeJournalEntryAdded(this.journal);
}

final class HomeJournalEntryDeleted extends HomeEvent {
  final String title;

  HomeJournalEntryDeleted(this.title);
}

final class HomeJournalEntriesRequested extends HomeEvent {}