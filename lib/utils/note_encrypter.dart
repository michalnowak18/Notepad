import 'package:encrypt/encrypt.dart';

import '../model/note.dart';

class NoteEncrypter {
  late final Key key;
  final IV iv = IV.fromLength(16);
  late final Encrypter encrypter;

  NoteEncrypter(this.key) {
    encrypter = Encrypter(AES(key, padding: null));
  }

  Note encrypt(Note note) {
    return Note(
      id: note.id,
      title: encrypter.encrypt(note.title, iv: iv).base64,
      content: encrypter.encrypt(note.content, iv: iv).base64,
    );
  }

  Note decrypt(Note note) {
    return Note(
      id: note.id,
      title: encrypter.decrypt64(note.title, iv: iv),
      content: encrypter.decrypt64(note.content, iv: iv),
    );
  }
}
