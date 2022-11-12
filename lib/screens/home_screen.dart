import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/provider/notes.dart';
import 'package:notes_app/screens/add_or_detail_screen.dart';
import 'package:notes_app/widgets/notes_grid.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notes"),
        ),
        body: FutureBuilder(
          future: Provider.of<Notes>(context, listen: false).getAndSetNotes(),
          builder: (context, notessnapshot) {
            if (notessnapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (notessnapshot.hasError) {
              return Center(
                child: Text(
                  notessnapshot.error.toString(),
                ),
              );
            }
            return NotesGrid();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(addOrDetailScreen.routeName);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.cyan,
        ));
  }
}
