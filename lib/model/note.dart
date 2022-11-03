class NoteFields {
  static final List<String> values = [id, number, title, content];

  static const String id = '_id';
  static const String number = 'number';
  static const String title = 'title';
  static const String content = 'content';
}

class Note {
  final int? id;
  final int number;
  final String title;
  final String content;

  const Note({
    this.id,
    required this.number,
    required this.title,
    required this.content,
  });

  Note copy({
    int? id,
    int? number,
    String? title,
    String? content,
  }) =>
      Note(
        id: id ?? this.id,
        number: number ?? this.number,
        title: title ?? this.title,
        content: content ?? this.content,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        number: json[NoteFields.number] as int,
        title: json[NoteFields.title] as String,
        content: json[NoteFields.content] as String,
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.number: number,
        NoteFields.title: title,
        NoteFields.content: content,
      };
}
