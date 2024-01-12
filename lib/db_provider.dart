import 'package:flutter/foundation.dart';
import 'package:note_app_sqlite/database_helper.dart';
import 'package:note_app_sqlite/note.dart';

///Provider untuk perubahan state CRUD
class DbProvider extends ChangeNotifier {
  List<Note> _notes = [];
  late DatabaseHelper _dbHelper;

  List<Note> get notes => _notes;

  DbProvider() {
    _dbHelper = DatabaseHelper();
    _getAllNotes();
  }

  ///Ambil semua data dari note database
  void _getAllNotes() async {
    _notes = await _dbHelper.getNote();
    notifyListeners();
  }

  ///menambahkan data note
  Future<void> addNote(Note note) async {
    await _dbHelper.insertNote(note);
    _getAllNotes();
  }

  ///mengambil data dari Id
  Future<Note> getNotebyId(int id) async {
    return await _dbHelper.getNotebyId(id);
  }

  ///Memperbarui Data
  void updateNote(Note note) async {
    await _dbHelper.updateNote(note);
    _getAllNotes();
  }

  ///Menghapus Data
  void deleteNote(int id) async {
    await _dbHelper.deleteNote(id);
    _getAllNotes();
  }
}
