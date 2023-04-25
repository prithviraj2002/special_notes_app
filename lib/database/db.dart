import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:sqflite/sqflite.dart';

import '../model/note-model.dart';

class NotesDatabase{
  Future<Database> getDb() async{
    WidgetsFlutterBinding.ensureInitialized();
    final path = await getDatabasesPath();

    final database = openDatabase(
      join(path, 'notes_database.db'),
      onCreate:(db, version){
          return db.execute(
            "CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, desc TEXT)"
          );
      },
      version: 1
    );

    return database;
  }

  Future<void> addNote(Note note) async{
    final db = await getDb();
    await db.insert(
      'notes',
      note.toMap(),
    );
  }

  Future<void> delNote(int id) async{
    final db = await getDb();
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateNote(Note note) async{
    final db = await getDb();
    await db.update('notes', note.toMap(), whereArgs: [note.id]);
  }

  Future<List<Note>> getNotes() async{
      final db = await getDb();

      final List<Map<String, dynamic>> notes = await db.query('notes');
      return List.generate(notes.length, (index) {
        return Note(title: notes[index]['title'], desc: notes[index]['desc'], id: notes[index]['id']);
      });
  }

}