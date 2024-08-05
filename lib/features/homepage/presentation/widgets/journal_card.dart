import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_local_app/core/theme/app_palette.dart';
import 'package:journal_local_app/features/homepage/domain/entities/journal.dart';
import 'package:journal_local_app/features/homepage/presentation/bloc/home_bloc.dart';

import '../../../../services/database_service.dart';

class JournalCard extends StatelessWidget {
  final Journal journal;

  const JournalCard({
    super.key,
    required this.journal,
  });

  Image? getCardImage() {
    if (journal.imageUrl.isEmpty) {
      return null;
    }
    try {
      final decodedBytes = base64Decode(journal.imageUrl);
      log('Image successfully decoded from Base64');
      return Image.memory(
        decodedBytes,
        fit: BoxFit.cover,
      );
    } catch (e) {
      log('Invalid image data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardImage = getCardImage();

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [
          AppPalette.gradient1,
          AppPalette.gradient2,
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cardImage != null)
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: cardImage,
            )
          else
            const Icon(Icons.image),
          const SizedBox(
            height: 8,
          ),
          Text(
            journal.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Divider(),
          Text(
            journal.body.length > 50
                ? '${journal.body.substring(0, 50)}...'
                : journal.body,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                journal.date,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              IconButton(
                onPressed: () async {
                  log('Delete journal');
                  context.read<HomeBloc>().add(
                        HomeJournalEntryDeleted(journal.title),
                      );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> deleteJournalEntry(String title) async {
    final databaseService = DatabaseService();
    await databaseService.deleteJournal(title);
  }
}
