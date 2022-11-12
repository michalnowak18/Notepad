import 'package:flutter/material.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({Key? key, required this.noteId}) : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Work in progress"),
      ),
    );
  }
}
