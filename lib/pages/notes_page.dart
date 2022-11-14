import 'package:flutter/material.dart';
import 'package:notepad/widgets/note_card_widget.dart';

import '../db/database_provider.dart';
import '../model/note.dart';
import 'add_edit_note_page.dart';
import 'note_detail_page.dart';

class NotesPage extends StatefulWidget {
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    this.notes = await DatabaseProvider.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade900,
        title: Text("Notes"),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : notes.isEmpty
                ? Text(
                    "No notes yet, add one!",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )
                : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditNotePage()),
            );
            refreshNotes();
          },
          backgroundColor: Colors.brown.shade900,
          child: Icon(
            Icons.edit_outlined,
          )),
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
