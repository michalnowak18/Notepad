import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Note extends StatefulWidget {
  final ModType modType;
  final int index;
  Note(this.modType, this.index);

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _textEditingController = TextEditingController();

  List<Map<String, String>> get _notes => NoteInheritedWidget.of(context).notes;
  set _notes(List<Map<String, String>> list) => NoteInheritedWidget.of(context).notes;

  @override
  void didChangeDependencies() {
    if (widget.modType == ModType.EDIT) {
      _titleEditingController.text = _notes[widget.index]['title']!;
      _textEditingController.text = _notes[widget.index]['text']!;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade600,
        title: Text(widget.modType == ModType.ADD ? 'Add note' : 'Edit note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _titleEditingController,
              decoration: InputDecoration(hintText: 'Note title'),
            ),
            Container(
              height: 8,
            ),
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(hintText: 'Note text'),
            ),
            Container(
              height: 24,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
              _NoteButton(
                ButtonType.SAVE,
                widget.modType == ModType.ADD
                    ? () {
                        setState(() {
                          _notes.add(
                            {
                              'title': _titleEditingController.text,
                              'text': _textEditingController.text,
                            },
                          );
                        });
                        Navigator.pop(context);
                      }
                    : () {
                        setState(() {
                          _notes[widget.index] = {
                            'title': _titleEditingController.text,
                            'text': _textEditingController.text,
                          };
                        });
                        Navigator.pop(context);
                      },
              ),
              _NoteButton(ButtonType.DISCARD, () {
                Navigator.pop(context);
              }),
              _NoteButton(ButtonType.DELETE, () {
                _notes.removeAt(widget.index);
                Navigator.pop(context);
              })
            ]),
          ],
        ),
      ),
    );
  }
}

class _NoteButton extends StatelessWidget {
  late String _text;
  late IconData _icon;
  late VoidCallback _onPressed;
  late bool _isEnabled = true;

  _NoteButton(ButtonType buttonType, VoidCallback onPressed) {
    switch (buttonType) {
      case ButtonType.SAVE:
        _text = 'Save';
        _icon = CupertinoIcons.check_mark_circled_solid;
        _onPressed = onPressed;
        break;
      case ButtonType.DISCARD:
        _text = 'Discard';
        _icon = CupertinoIcons.delete_left_fill;
        _onPressed = onPressed;
        break;
      case ButtonType.DELETE:
        _text = 'Delete';
        _icon = CupertinoIcons.delete_solid;
        _onPressed = onPressed;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: Colors.orange.shade600,
      onPressed: _onPressed,
      borderRadius: BorderRadius.circular(15),
      padding: EdgeInsets.symmetric(horizontal: 14),
      minSize: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(_text),
          Container(
            width: 6,
          ),
          Icon(
            _icon,
            size: 24,
          ),
        ],
      ),
    );
  }
}

enum ButtonType {
  SAVE,
  DISCARD,
  DELETE,
}

enum ModType {
  ADD,
  EDIT,
}
