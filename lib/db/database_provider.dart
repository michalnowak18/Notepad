import 'dart:async';

import 'package:notepad/utils/note_encrypter.dart';
import 'package:notepad/utils/password_secure_storage.dart';
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

  Future _createDb(Database db, int version) async {
    await db.execute('CREATE TABLE $notesTableName ('
        '${NoteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${NoteFields.title} TEXT NOT NULL,'
        '${NoteFields.content} TEXT NOT NULL'
        ')');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final noteEncrypter = NoteEncrypter(await PasswordSecureStorage.getSecretKey());
    final encryptedNote = noteEncrypter.encrypt(note);
    final id = await db.insert(notesTableName, encryptedNote.toJson());
    return note.copy(id: id);
  }

  Future<Note> read(int noteId) async {
    final db = await instance.database;
    final result = await db.query(
      notesTableName,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [noteId],
    );

    if (result.isEmpty) {
      throw Exception('Note ID: $noteId not found');
    }
    final noteEncrypter = NoteEncrypter(await PasswordSecureStorage.getSecretKey());
    Note encryptedNote = Note.fromJson(result.first);
    return noteEncrypter.decrypt(encryptedNote);
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    final noteEncrypter = NoteEncrypter(await PasswordSecureStorage.getSecretKey());
    final encryptedNote = noteEncrypter.encrypt(note);

    return db.update(
      notesTableName,
      encryptedNote.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final result = await db.query(notesTableName);
    final noteEncrypter = NoteEncrypter(await PasswordSecureStorage.getSecretKey());
    List<Note> encryptedNotes = result.map((json) => Note.fromJson(json)).toList();

    return encryptedNotes.map((note) => noteEncrypter.decrypt(note)).toList();
  }

  Future<int> deleteAll() async {
    final db = await instance.database;
    return db.delete(notesTableName);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
