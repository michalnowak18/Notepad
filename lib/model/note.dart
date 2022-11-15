const String notesTableName = 'notes';

class NoteFields {
  static final List<String> values = [id, title, content];

  static const String id = '_id';
  static const String title = 'title';
  static const String content = 'content';
}

class Note {
  final int? id;
  final String title;
  final String content;

  const Note({
    this.id,
    required this.title,
    required this.content,
  });

  Note copy({
    int? id,
    String? title,
    String? content,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
      );

  static Note fromJson(Map<String, Object?> json) {
    Note note = Note(
      id: json[NoteFields.id] as int?,
      title: json[NoteFields.title] as String,
      content: json[NoteFields.content] as String,
    );
    return note;
  }

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.content: content,
      };
}
