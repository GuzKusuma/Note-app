// ignore_for_file: avoid_print

import 'package:note_app_sqlite/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static late Database _database;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  ///Method membuat objek database

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  static const String _tableName = 'notes';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, 'note_db.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $_tableName (
               id INTEGER PRIMARY KEY,
               title TEXT, description TEXT
             )''',
        );
      },
      version: 1,
    );
    return db;
  }

  /// Metode Menambahkan data
  Future<void> insertNote(Note note) async {
    final Database db = await database;
    await db.insert(_tableName, note.toMap());
    print("Data Saved");
  }

  /// Metode untuk menampilkan seluruh note yang disimpan di database

  Future<List<Note>> getNote() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);

    return results.map((res) => Note.fromMap(res)).toList();
  }

//Metode mengambil data dengan id tertentu
  Future<Note> getNotebyId(int id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.map((res) => Note.fromMap(res)).first;
  }

  //Metode untuk memperbarui data
  Future<void> updateNote(Note note) async {
    final Database db = await database;

    await db.update(
      _tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  //Metode menghapus data
  Future<void> deleteNote(int id) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
