import 'package:flutter/material.dart';
import 'package:note_app/database/db.dart';
import 'package:note_app/screens/add-note.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../model/note-model.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home-screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ndb = NotesDatabase();
  final flutterTts = FlutterTts();
  bool listening = false;

  Future _speak(String text) async{
    flutterTts.setLanguage("en-US");
    flutterTts.setPitch(1);
    flutterTts.setVolume(1);
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVoice({"name": "en-us-x-sfg#male_2-local"});
    flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes",
          style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            fontSize: 25
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder(
          future: ndb.getNotes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      List<Note> notes = snapshot.data;
      if (notes.isNotEmpty) {
        return ListView.builder(
            itemBuilder: (BuildContext ctx, int index) {
              return ListTile(
                trailing: IconButton(
                  onPressed: () {
                    _speak(notes[index].title);
                    _speak(notes[index].desc);
                  },
                  icon: const Icon(Icons.hearing),
                ),
                  title: Text(notes[index].title),
                  subtitle: Text(notes[index].desc),
                  onTap: (){
                    //To Do: Add Open Note feature to update the stored note.
                  },
                  onLongPress: () {
                    showDialog(context: ctx, builder: (ctx) =>
                        AlertDialog(
                          title: const Text("Want to delete this note?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  ndb.delNote(notes[index].id).then((value){
                                    Navigator.of(context).pop();
                                    Navigator.of(context).popAndPushNamed(
                                        HomeScreen.routeName);
                                  });
                                },
                                child: const Text("Yes")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("No")),
                          ],
                        )
                    );
                  });
            },
            itemCount: notes.length,
            );
      }
      else {
        return const Center(child: Text("No notes added yet!"));
      }
    }
             else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(AddNote.routeName);
          },
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}


