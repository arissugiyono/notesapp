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
    return openDatabase(join(dpPath, 'notes.db'), version: 1,
        onCreate: (newDb, version) {
      newDb.execute('''CREATE TABLE $TABLE_NOTES (
$TABLE_NOTES_ID TEXT PRIMARY KEY,
$TABLE_NOTES_TITLE TEXT,
$TABLE_NOTES_NOTE TEXT,
$TABLE_NOTES_ISPINNED INTEGER,
$TABLE_NOTES_UPDATEDAT TEXT,
$TABLE_NOTES_CREATEDAT TEXT,
      )''');
    });
  }

  Future<List<Note>> GetAllNote() async {
    final db = await dataBaseHelper.Init();
    final results = await db.query(
      'notes',
    );

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
      batch.insert('notes', note.toDb());
    });

    await batch.commit();
  }
}
