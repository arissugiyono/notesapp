import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/provider/notes.dart';
import 'package:provider/provider.dart';

class addOrDetailScreen extends StatefulWidget {
  static const routeName = '/addOrDetailScreen';

  @override
  State<addOrDetailScreen> createState() => _addOrDetailScreenState();
}

class _addOrDetailScreenState extends State<addOrDetailScreen> {
  Note _note = Note(
    id: '',
    title: '',
    note: '',
  );

  final _formkey = GlobalKey<FormState>();

  bool _init = true;
  bool _isLoading = false;

  void submitNote() async {
    if (_formkey.currentState != null) {
      _formkey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final now = DateTime.now();
      _note = _note.copyWith(updatedAt: now, createdAt: now);
      final notesProvider = Provider.of<Notes>(context, listen: false);
      if (_note.id == null) {
        await notesProvider.addNote(_note);
      } else {
        await notesProvider.updateNote(_note);
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text('error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('Tutup'))
            ],
          );
        },
      );
    }

    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      String? id = ModalRoute.of(context)!.settings.arguments as String?;
      if (id != null) {
        _note = Provider.of<Notes>(context).getNote(id);
      }

      _init = false;
    }

    super.didChangeDependencies();
  }

  String _convertDate(DateTime dateTime) {
    int diff = DateTime.now().difference(dateTime).inDays;
    if (diff > 0) return DateFormat('dd-MM-yyy').format(dateTime);

    return DateFormat('hh: mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: submitNote,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      'Simpan',
                      style: TextStyle(color: Colors.white),
                    ))
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _note.title,
                      decoration: InputDecoration(
                          hintText: 'judul', border: InputBorder.none),
                      onSaved: (value) {
                        _note = _note.copyWith(title: value);
                      },
                    ),
                    TextFormField(
                      initialValue: _note.note,
                      decoration: InputDecoration(
                          hintText: 'tulis catatan di sini',
                          border: InputBorder.none),
                      onSaved: (value) {
                        _note = _note.copyWith(note: value);
                      },
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_note.updatedAt != null)
            Positioned(
              bottom: 10,
              right: 10,
              child: _note.updatedAt != null
                  ? Text('terakhir diubah  ${_convertDate(_note.updatedAt!)}')
                  : Container(),
            )
        ],
      ),
    );
  }
}
