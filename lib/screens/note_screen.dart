import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:diary/common/appbar.dart';
import 'package:diary/common/text_field.dart';
import 'package:diary/models/note_list_model.dart';
import 'package:diary/models/note_model.dart';
import 'package:provider/provider.dart';

import '../common/helpers.dart';

//StatefulWidget - mutable, update their content or appearance in response to user interaction
//contains CustomAppBar, FloatingButton and Form
class NoteForm extends StatefulWidget {
  final NoteModel? note;
  const NoteForm({super.key, required this.note});

  @override
  State<StatefulWidget> createState() => _NoteFormState();

}

// Create a corresponding State class.
// This class holds data related to the form.
class _NoteFormState extends State<NoteForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _bodyController.text = widget.note!.body;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: const CustomAppBar(height: 60,),
      body: Stack(
        children: [
          // getCover("assets/background/note.png"),
          _drawForm(),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _SetReminderButton(onPressed: _setReminderToNote),
          const SizedBox(width: 8,),
          widget.note == null
          ? _AddButton(onPressed: _addNote)
          : _UpdateButton(onPressed: _updateNote)
        ],
      ),
    );
  }

  //UI
  Widget _drawForm(){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTextField(
            controller: _titleController,
            hintText: widget.note == null ? "TITLE" : _titleController.text,
            keyboardType: TextInputType.text,
            isFilled: false,
            onValidate: (title){
              if (title == null || title.isEmpty) {
                return 'Please enter note title';
              }
              return null;
            },
          ),
          CustomTextField(
            controller: _bodyController,
            hintText: widget.note == null ? "NOTE" : _bodyController.text,
            keyboardType: TextInputType.text,
            isFilled: false,
            onValidate: (body){
              if (body == null || body.isEmpty) {
                return 'Please fill the note';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  //LOGIC
  void _addNote(){
    if (_formKey.currentState!.validate()){ //validation
      var noteList = context.read<NoteListModel>(); //provider pattern
      noteList.add(NoteModel(username: "username",
          title: _titleController.text,
          body: _bodyController.text)
      );
      context.go('/note_list');
    }
  }

  void _updateNote(){
    if (_formKey.currentState!.validate()){
      var noteList = context.read<NoteListModel>();//provider pattern
      noteList.update(widget.note!, NoteModel(username: "username",
          title: _titleController.text,
          body: _bodyController.text)
      );
      context.go('/note_list');
    }
  }

  void _setReminderToNote(){
    //add implementation
  }
}

//helper class for note form
class _AddButton extends StatelessWidget{

  final void Function()? onPressed;

  const _AddButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      heroTag: null,
      backgroundColor: backgroundPink,
      shape: const CircleBorder(),
      onPressed: onPressed,
      child: const Icon(Icons.add, color: Colors.black),);
  }

}

//helper class for note form
class _UpdateButton extends StatelessWidget{

  final void Function()? onPressed;

  const _UpdateButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      heroTag: null,
      backgroundColor: backgroundPink,
      shape: const CircleBorder(),
      onPressed: onPressed,
      child: const Icon(Icons.update, color: Colors.black),);
  }

}

//helper class for note form
class _SetReminderButton extends StatelessWidget{

  final void Function()? onPressed;

  const _SetReminderButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      heroTag: null, //used for smooth animation
      backgroundColor: backgroundPink,
      shape: const CircleBorder(),
      onPressed: onPressed,
      child: const Icon(Icons.notification_add_rounded, color: Colors.black),);
  }

}


