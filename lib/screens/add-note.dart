import 'package:flutter/material.dart';
import 'package:note_app/database/db.dart';
import 'package:note_app/model/note-model.dart';
import 'package:note_app/screens/home-screen.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class AddNote extends StatefulWidget {
  static const routeName = "/add-note";
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();

  final noteDb = NotesDatabase();

  final SpeechToText _speechToText = SpeechToText();
  final SpeechToText speech = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void descListening() async{
    await speech.listen(onResult: onDescResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void descStop() async{
    await speech.stop();
    setState((){});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _title.text = result.recognizedWords;
    });
  }

  void onDescResult(SpeechRecognitionResult result){
    setState((){
      _desc.text = result.recognizedWords;
    });
  }

    @override
    void dispose() {
      // TODO: implement dispose
      _title.dispose();
      _desc.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Add note", style:
          TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.orange,)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                child: TextFormField(
                  controller: _title,
                  decoration: InputDecoration(
                      hintText: "Title",
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        onPressed: () {
                          _speechToText.isNotListening? _startListening() : _stopListening() ;
                        },
                        icon: Icon(_speechToText.isNotListening? Icons.mic_off : Icons.mic),
                      )
                  ),
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Cannot have empty title";
                    }
                  },
                ),
              ),
              Container(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                child: TextFormField(
                  controller: _desc,
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText: "Start writing here",
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                          onPressed: () {
                            speech.isNotListening ? descListening() : descStop();
                          },
                          icon: Icon(speech.isListening? Icons.mic : Icons.mic_off),
                    ),
                  ),
                  style: const TextStyle(fontSize: 20),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Cannot have empty description";
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_title.text.isNotEmpty && _desc.text.isNotEmpty) {
              setState(() {
                noteDb.addNote(
                    Note(
                        title: _title.text,
                        desc: _desc.text,
                        id: DateTime
                            .now()
                            .millisecond)
                ).then((value) => Navigator.of(context).popAndPushNamed(HomeScreen.routeName));
              });
            }
          },
          child: const Icon(Icons.save, color: Colors.white,),
        ),
      );
    }
  }




