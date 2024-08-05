import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_local_app/core/theme/app_palette.dart';
import 'package:journal_local_app/features/homepage/presentation/widgets/journal_bottom_sheet.dart';
import 'package:journal_local_app/services/database_service.dart';

import '../bloc/home_bloc.dart';
import '../widgets/journal_card.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
    //  context.read<HomeBloc>().add(HomeJournalEntriesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () {
            showBottomSheet(
              context: context,
              builder: (context) => const JournalBottomSheet(),
            );
          },
          child: const Icon(
            Icons.add,
            color: AppPalette.appOrange,
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Journal',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is HomeInitial) {
            return const Center(
              child: Text('No journal entries yet'),
            );
          }
          if (state is HomeLoaded) {
            return ListView.builder(
                itemCount: state.journalEntries.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: JournalCard(journal: state.journalEntries[index]),
                  );
                });
          }
          return Column(
            children: [
              const SizedBox(height: 16),
              _jounralList(),
            ],
          );
        },
      ),
    );
  }

  Widget _jounralList() {
    return FutureBuilder(
        future: DatabaseService().getJournalEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred'),
            );
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No journal entries yet'),
            );
          }

          return ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: JournalCard(journal: snapshot.data![index]),
                );
              },
              itemCount: snapshot.data!.length);
        });
  }
}
