import 'package:flutter/material.dart';
import 'package:notepad/inherited_widgets/note_inherited_widget.dart';
import 'package:notepad/view/note_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NoteInheritedWidget(
      const MaterialApp(
        title: 'Flutter Demo',
        home: NoteList(),
      ),
    );
  }
}
