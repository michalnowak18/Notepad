import 'package:flutter/material.dart';

import '../model/note.dart';

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({
    Key? key,
    required this.note,
    required this.index,
  }) : super(key: key);

  final Note note;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 30.0, left: 13.0, right: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NoteTitle(note.title),
            Container(
              height: 4,
            ),
            _NoteText(note.content),
          ],
        ),
      ),
    );
  }
}

class _NoteTitle extends StatelessWidget {
  final String _title;
  const _NoteTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _NoteText extends StatelessWidget {
  const _NoteText(this._text);
  final String _text;

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(color: Colors.grey.shade600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
