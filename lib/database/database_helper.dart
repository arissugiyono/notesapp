import 'package:notes_app/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class dataBaseHelper {
  static const TABLE_NOTES = 'notes';
  static const TABLE_NOTES_ID = 'id';
  static const TABLE_NOTES_NOTE = 'note';
  static const TABLE_NOTES_TITLE = 'title';
  static const TABLE_NOTES_ISPINNED = 'iSPinned';
  static const TABLE_NOTES_UPDATEDAT = 'updated_at';
  static const TABLE_NOTES_CREATEDAT = 'created_at';

  static Future<Database> Init() async {
    final dpPath = await getDatabasesPath();
    return openDatabase(
      join(dpPath, 'notes.db'),
      version: 3,
      onCreate: (newDb, version) {
        newDb.execute(''' 
        CREATE TABLE $TABLE_NOTES( 
          $TABLE_NOTES_ID TEXT PRIMARY KEY,
          $TABLE_NOTES_TITLE TEXT,
          $TABLE_NOTES_NOTE TEXT,
          $TABLE_NOTES_ISPINNED INTEGER,
          $TABLE_NOTES_UPDATEDAT TEXT,
          $TABLE_NOTES_CREATEDAT TEXT
        )
          ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion == 1 && newVersion == 2) {
          db.execute('''
CREATE TABLE test_upgrade (
  id TEXT PRIMARY KEY,
  title TEXT
)
''');
        }
        if (oldVersion == 2 && newVersion == 3) {
          db.execute('''
ALTER TABLE $TABLE_NOTES
ADD COLUMN test_column_baru INTEGER DEFAULT 0

''');
        }
      },
    );
  }

  Future<List<Note>> GetAllNote() async {
    final db = await dataBaseHelper.Init();
    final results = await db.query('notes');

    List<Note> listNote = [];
    results.forEach((data) {
      listNote.add(Note.formDb(data));
    });

    return listNote;
  }

  Future<void> insertAllNote(List<Note> listNote) async {
    final db = await dataBaseHelper.Init();
    Batch batch = db.batch();

    listNote.forEach((note) {
      batch.insert('notes', note.toDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });

    await batch.commit();
  }

  Future<void> updateNote(Note note) async {
    final db = await dataBaseHelper.Init();
    await db.update(TABLE_NOTES, note.toDb(),
        where: '$TABLE_NOTES_ID = ?', whereArgs: [note.id]);
  }

  Future<void> toggleIsPinned(
      String id, bool isPinned, DateTime updatedAt) async {
    final db = await dataBaseHelper.Init();
    await db.update(
      TABLE_NOTES,
      {
        TABLE_NOTES_ISPINNED: isPinned ? 1 : 0,
        TABLE_NOTES_UPDATEDAT: updatedAt.toIso8601String()
      },
      where: '$TABLE_NOTES_ID = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleleteNote(String id) async {
    final db = await dataBaseHelper.Init();
    await db.delete(TABLE_NOTES, where: '$TABLE_NOTES_ID = ?', whereArgs: [id]);
  }

  Future<void> insertNote(Note note) async {
    final db = await dataBaseHelper.Init();
    await db.insert(TABLE_NOTES, note.toDb());
  }
}
