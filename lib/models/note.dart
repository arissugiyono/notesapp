import 'package:flutter/cupertino.dart';
import 'package:notes_app/database/database_helper.dart';

class Note {
  final String id;
  final String title;
  final String note;
  final DateTime updatedAt;
  final DateTime createdAt;
  bool isPinned;

  Note(
      {@required this.id,
      @required this.title,
      @required this.note,
      @required this.updatedAt,
      @required this.createdAt,
      this.isPinned = false});

  Note.formDb(Map<String, dynamic> data)
      : id = data[dataBaseHelper.TABLE_NOTES_ID],
        title = data[dataBaseHelper.TABLE_NOTES_TITLE],
        note = data[dataBaseHelper.TABLE_NOTES_NOTE],
        isPinned = data[dataBaseHelper.TABLE_NOTES_ISPINNED] == 1,
        updatedAt = DateTime.parse(data[dataBaseHelper.TABLE_NOTES_UPDATEDAT]),
        createdAt = DateTime.parse(data[dataBaseHelper.TABLE_NOTES_CREATEDAT]);
  Map<String, dynamic> toDb() {
    return {
      dataBaseHelper.TABLE_NOTES_ID: id,
      dataBaseHelper.TABLE_NOTES_TITLE: title,
      dataBaseHelper.TABLE_NOTES_NOTE: note,
      dataBaseHelper.TABLE_NOTES_ISPINNED: isPinned ? 1 : 0,
      dataBaseHelper.TABLE_NOTES_UPDATEDAT: updatedAt.toIso8601String(),
      dataBaseHelper.TABLE_NOTES_CREATEDAT: createdAt.toIso8601String(),
    };
  }

  Note copyWith(
      {String id,
      String title,
      String note,
      DateTime updatedAt,
      DateTime createdAt,
      bool ispinned}) {
    return Note(
      id: id == null ? this.id : id,
      title: title == null ? this.title : title,
      note: note == null ? this.note : note,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt,
      createdAt: createdAt == null ? this.createdAt : createdAt,
      isPinned: isPinned == null ? this.isPinned : isPinned,
    );
  }
}
