import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:journal_local_app/features/homepage/data/models/journal_model.dart';

import '../features/homepage/domain/entities/journal.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  factory DatabaseService() {
    return instance;
  }

  DatabaseService._constructor();

  final String tableName = "journal_entries";
  final String journalIdColumnName = 'id';
  final String journalTitleColumnName = 'title';
  final String journalBodyColumnName = 'body';
  final String journalDateTimeColumnName = 'date';
  final String journalImageColumnName = 'imageUrl';

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "journal.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $tableName (
            $journalIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
            $journalTitleColumnName TEXT,
            $journalBodyColumnName TEXT,
            $journalImageColumnName TEXT,
            $journalDateTimeColumnName TEXT
          )
          ''');
      },
    );
    return database;
  }

  Future<Journal> addJournalEntry({required JournalModel journal}) async {
    final db = await database;
    await db.insert(tableName, journal.toMap());
    return journal;
  }

  Future<List<JournalModel>> getJournalEntries() async {
    final db = await database;
    final data = await db.query(tableName);
    if (data.isEmpty) {
      return [];
    }
    List<JournalModel> journalEntries =
        data.map((e) => JournalModel.fromMap(e)).toList();

    print(data);
    return journalEntries;
  }

  Future<void> deleteJournal(String title) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  Future<void> deleteAllDataFromTable(String tableName) async {
    final db = await database; // Make sure you get a reference to your database
    await db.delete(
      tableName,
      // Use `where: null` to delete all rows
      where: null,
    );
  }
}
