import 'package:journal_local_app/features/homepage/domain/entities/journal.dart';

class JournalModel extends Journal {
  JournalModel({
    required super.title,
    required super.body,
    required super.date,
    required super.imageUrl,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'body': body,
      'date': date,
      'imageUrl': imageUrl,
    };
  }

  factory JournalModel.fromMap(Map<String, dynamic> map) {
    return JournalModel(
      title: map['title'] as String,
      body: map['body'] as String,
      date: map['date'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }
}
