import 'package:flutter/material.dart';
import 'package:notepad/pages/note_card_widget.dart';

import 'note.dart';

class NoteList extends StatefulWidget {
  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NoteDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    this.notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade600,
        title: Text("Notes"),
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : notes.isEmpty
              ? Text("No notes")
              : buildNotes(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Note(ModType.ADD, 0)),
            );
          },
          child: Icon(Icons.add)),
    );
  }

  Widget buildNotes() => ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(
              note: note,
              index: index,
            ),
          );
        },
      );
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
