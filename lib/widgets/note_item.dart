import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/presentations/customicons_icons.dart';
import 'package:notes_app/provider/notes.dart';
import 'package:notes_app/screens/add_or_detail_screen.dart';
import 'package:provider/provider.dart';

class NoteItem extends StatefulWidget {
  final String id;
  final BuildContext ctx;

  NoteItem({
    @required this.id,
    @required this.ctx,
  });

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<Notes>(context, listen: false);
    Note note = notesProvider.getNote(widget.id);

    return Dismissible(
      key: Key(note.id),
      onDismissed: ((direction) {
        {
          notesProvider.deleteNote(note.id).catchError((onError) {
            print('terjadi kesalahan');
            ScaffoldMessenger.of(widget.ctx).clearSnackBars();
            ScaffoldMessenger.of(widget.ctx)
                .showSnackBar(SnackBar(content: Text(onError.toString())));
          });
        }
      }),
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(addOrDetailScreen.routeName, arguments: note.id),
        child: GridTile(
          header: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    notesProvider.toogleisPinned(note.id).catchError((onError) {
                      ScaffoldMessenger.of(widget.ctx).clearSnackBars();
                      ScaffoldMessenger.of(widget.ctx).showSnackBar(
                          SnackBar(content: Text(onError.toString())));
                    });
                  },
                  icon: Icon(note.isPinned
                      ? Customicons.pin
                      : Customicons.pin_outline))),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[900]),
            child: Text(note.note),
            padding: EdgeInsets.all(12),
          ),
          footer: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12)),
            child: GridTileBar(
              title: Text(note.title),
              backgroundColor: Colors.cyan,
            ),
          ),
        ),
      ),
    );
  }
}
