import 'package:flutter/material.dart';
import 'package:notes_app/provider/notes.dart';
import 'package:notes_app/widgets/note_item.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class NotesGrid extends StatefulWidget {
  @override
  State<NotesGrid> createState() => _NotesGridState();
}

class _NotesGridState extends State<NotesGrid> {
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<Notes>(context);

    List<Note> listNote = notesProvider.notes;

    return Padding(
      padding: EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: listNote.length,
        itemBuilder: (context, index) => NoteItem(
          id: listNote[index].id,
          ctx: context,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
      ),
    );
  }
}
