import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/note.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();
  static Database? _database;

  DatabaseProvider._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb('notes.db');
    return _database!;
  }

  Future<Database> _initDb(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  FutureOr<void> _createDb(Database db, int version) {}

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<List<Note>> readAllNotes() async {
    Note note = Note(
        id: 0,
        number: 0,
        title: "Lorem Ipsum",
        content: "dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et"
            " dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut"
            " aliquip ex ea commodo consequat.");

    return [
      note,
      note,
      note,
      note,
      note,
      note,
    ];
  }
}
