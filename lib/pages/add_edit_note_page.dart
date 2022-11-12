import 'package:flutter/material.dart';
import 'package:notepad/db/database_provider.dart';

import '../model/note.dart';
import '../widgets/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String content;

  @override
  void initState() {
    super.initState();

    title = widget.note?.title ?? '';
    content = widget.note?.content ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [saveButton()],
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          title: title,
          content: content,
          onChangedTitle: (title) => setState(() => this.title = title),
          onChangedContent: (content) => setState(() => this.content = content),
        ),
      ),
    );
  }

  Widget saveButton() {
    final isValid = title.isNotEmpty && content.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      child: ElevatedButton(
        child: Text("Save"),
        onPressed: addOrUpdateNote,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isValid ? null : Colors.grey.shade700,
        ),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(title: title, content: content);
    await DatabaseProvider.instance.update(note);
  }

  Future addNote() async {
    await DatabaseProvider.instance.create(
      Note(title: title, content: content),
    );
  }
}
