import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

class CreateEntryPage extends StatefulWidget {
  final String username;
  final void Function(String title, String content, String time_hour, String time_min) onEntrySaved;
  final String? initialTitle;
  final String? initialContent;
  // Add this line

  const CreateEntryPage({
    Key? key,
    required this.username,
    required this.onEntrySaved,
    this.initialTitle,
    this.initialContent,

    // Add this line
  }) : super(key: key);

  @override
  _CreateEntryPageState createState() => _CreateEntryPageState();
}

class _CreateEntryPageState extends State<CreateEntryPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    if (widget.initialTitle != null) {
      titleController.text = widget.initialTitle!;
    }
    if (widget.initialContent != null) {
      contentController.text = widget.initialContent!;
    }

  }

  Future<void> _saveEntry(TimeOfDay time) async {
    //get stored file
    String fileName = 'diary_entries_${widget.username}.txt';
    final file = await _localFile(fileName);
    print(time);
    //retrieve data from text fields
    String entryTitle = titleController.text;
    String entryContent = contentController.text;
    // write new content to file
    await file.writeAsString('$entryTitle\n$entryContent\n${time.hour}\n${time.minute}\nfalse\n\n', mode: FileMode.append);

    // Pass entry data back to the previous screen
    widget.onEntrySaved(entryTitle, entryContent, time.hour.toString(), time.minute.toString());
    Navigator.pop(context);
  }

  //to get stored file
  Future<File> _localFile(String fileName) async {
    final path = await getApplicationDocumentsDirectory();
    return File('${path.path}/$fileName');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Entry'),
        actions: [
          IconButton(
            onPressed: () => _saveEntry(selectedTime),
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.note),
              title: Text('Title'),
              subtitle: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter your diary entry title...',
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text('Content'),
              subtitle: TextField(
                controller: contentController,
                decoration: InputDecoration(
                  hintText: 'Enter your diary entry content...',
                ),
                maxLines: null,
              ),
            ),
            ListTile(
                leading: Icon(Icons.timer),
                title: Text('Reminder'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ Text(""), Text("${selectedTime.hour}:${selectedTime.minute}", style: TextStyle(fontSize: 20),),Text(""), SizedBox( width: 80, height: 25, child: ElevatedButton(
                    child: const Text("Choose"),
                    onPressed: () async {
                      TimeOfDay? time = await showTimePicker(context: context, initialTime: selectedTime);
                      if (time != null){
                        setState(() {
                          selectedTime = time;
                          print("${selectedTime.hour}:${selectedTime.minute}");
                        });
                      }
                    },
                  ),)],
                )
            ),
          ],
        ),
      ),
    );
  }
}