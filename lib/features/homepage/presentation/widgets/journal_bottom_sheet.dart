import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:journal_local_app/core/theme/app_palette.dart';

import '../../../../core/utils/pick_image.dart';
import '../../data/models/journal_model.dart';
import '../bloc/home_bloc.dart';

class JournalBottomSheet extends StatefulWidget {
  const JournalBottomSheet({super.key});

  @override
  State<StatefulWidget> createState() {
    return _JournalBottomSheetState();
  }
}

class _JournalBottomSheetState extends State<JournalBottomSheet> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  String? imageBase64Encoding;
  String journalDate = DateFormat('EEE, d MMM').format(
    DateTime.now(),
  );
  File? image;
  final formKey = GlobalKey<FormState>();
  void selectImage() async {
    log('Select image invoked');
    final pickedImage = await pickImage();

    log('Image picked');
    if (pickedImage != null) {
      try {
        final imageBytes = await File(pickedImage.path).readAsBytes();
        final base64String = base64.encode(imageBytes);
        log('Image successfully encoded to Base64');
        setState(() {
          image = pickedImage;
          imageBase64Encoding = base64String;
        });
      } catch (e) {
        log('Error encoding image: $e');
        setState(() {
          image = null;
          imageBase64Encoding = null;
        });
      }
    } else {
      log('No image picked');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(
                journalDate,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    log('Attach file');
                    selectImage();
                  },
                  icon: const Icon(
                    Icons.attach_file,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    /*  DatabaseService.instance
                        .deleteAllDataFromTable('journal_entries');
                */
                    if (formKey.currentState!.validate() &&
                        imageBase64Encoding != null &&
                        image != null) {
                      context.read<HomeBloc>().add(
                            HomeJournalEntryAdded(
                              JournalModel(
                                title: titleController.text.trim(),
                                body: bodyController.text.trim(),
                                imageUrl: imageBase64Encoding ?? '',
                                date: journalDate,
                              ),
                            ),
                          );
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    }

                    /* log('Saving journal entry');
                    if (formKey.currentState!.validate() &&
                        imageBase64Encoding != null &&
                        image != null) {
                      await JournalLocalDataSourceImpl(
                        DatabaseService(),
                      ).saveJournal(
                        JournalModel(
                          title: titleController.text.trim(),
                          body: bodyController.text.trim(),
                          imageUrl: imageBase64Encoding ?? '',
                          date: journalDate,
                        ),
                      );
                      log('Journal entry saved');
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    }*/
                  },
                  child: const Text('Done'),
                ),
              ],
              automaticallyImplyLeading: false,
              backgroundColor: AppPalette.transparentColor,
            ),
            image != null
                ? GestureDetector(
                    onTap: selectImage,
                    child: SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            TextFormField(
              maxLines: 1,
              controller: titleController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Title cannot be empty';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextFormField(
              maxLines: 5,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Body cannot be empty';
                }
                return null;
              },
              controller: bodyController,
              decoration: const InputDecoration(
                hintText: 'Body',
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
