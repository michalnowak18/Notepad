import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final String? title;
  final String? content;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedContent;

  const NoteFormWidget({
    Key? key,
    this.title = '',
    this.content = '',
    required this.onChangedTitle,
    required this.onChangedContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTitle(),
            SizedBox(
              height: 8,
            ),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    return TextFormField(
      maxLines: 1,
      initialValue: title,
      style: TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Title',
        hintStyle: TextStyle(color: Colors.white70),
      ),
      validator: (title) => title != null && title.isEmpty ? 'Title cannot be empty' : null,
      onChanged: onChangedTitle,
    );
  }

  Widget buildContent() {
    return TextFormField(
      maxLines: 5,
      initialValue: content,
      style: TextStyle(
        color: Colors.white60,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Type some more...',
        hintStyle: TextStyle(color: Colors.white60),
      ),
      validator: (content) => content != null && content.isEmpty ? 'Note content cannot be empty' : null,
      onChanged: onChangedContent,
    );
  }
}
