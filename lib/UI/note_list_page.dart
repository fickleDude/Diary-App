import 'package:diary/repository/database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/note.dart';
import '../utils/constants.dart';
import 'create_entry_page.dart';
import 'login_page.dart';

class NoteListPage extends StatefulWidget {
  final String username;

  NoteListPage({required this.username});

  @override
  _NoteListPageState createState() => _NoteListPageState();

}

class _NoteListPageState extends State<NoteListPage> {

  late double screenHeight;
  late double screenWidth;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut()
      .then((value) => Navigator.push(context, LoginPage.getRoute()));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('MOMENTO MORI', style: getTextStyle(24),),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.black,),
                  onPressed: () async{
                    _logout();
                  },
                ),
              ],
              backgroundColor: backgroundPurple,
            ),
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/background/notes_list.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Container(
                    padding: EdgeInsets.all(20),
                    width: screenWidth,
                    height: screenHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,//vertical in row
                            children: [
                              checkRemindersButton(),
                              addNoteButton(),
                            ],
                          ),
                        ),
                        drawNotesList()
                      ],
                    ),
                  ),
                ),
              ],
            ),
        )
    );
  }

  Widget drawNotesList() {
    return Expanded(
      child: FutureBuilder<List<Note>?>(
        future: DatabaseHelper.db.getNotesByUsername(widget.username),
        builder: (BuildContext context, AsyncSnapshot<List<Note>?> snapshot) {
          //LOADING
          if(snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
          //ERROR
          else if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          //SUCCESS
          else if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                Note item = snapshot.data![index];
                return drawNote(item, screenHeight / 4, screenWidth);
              },
            );
          }else{
            return const Center(child: Text("no data found"));
          }
        },
      )
    );
  }

  Widget drawNote(Note note, double noteHeight, double noteWidth){
    return InkWell(
      onTap: () {
        Navigator.push(context, New_note_Page.getRoute(widget.username, note));
      },
      child: Container(
          margin: EdgeInsets.only(top: 16, bottom: 16),
          width: noteWidth,
          height: noteHeight,
          padding: EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color:  note.isPinned ? backgroundPurple : backgroundPink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // title
              Container(
                width: noteWidth,
                height: noteHeight / 4,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: SizedBox(
                  child:
                    Text(
                      note.title,
                      textAlign: TextAlign.center,
                      style: getTextStyle(16),
                    ),
                ),
              ),
              //note
              Container(
                padding: EdgeInsets.only(top: 8, left: 10),
                child: SizedBox(
                  width: noteWidth,
                  height: noteHeight / 4,
                  child: Text(
                    note.body.length > 100 ? note.body.replaceRange(100, note.body.length, '...') : note.body,
                    style: getTextStyle(14),
                  ),
                ),
              ),
              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  deleteButton(note),
                  pinButton(note)
                ],
              )
            ],
          )

      ),
    );
  }

  Widget deleteButton(Note note){
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: primaryColor,
        child: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.black,
          ),
          onPressed: (){
            DatabaseHelper.db.deleteNote(note);
            setState(() {});
            showDialog(context: context,
                builder: (context) => AlertDialog(title: Text("Note deleted!")));
          },
        ),
      ),
    );
  }

  Widget pinButton(Note note){
    return CircleAvatar(
      radius: 25,
      backgroundColor: primaryColor,
      child: IconButton(
        icon: Icon(
          Icons.push_pin,
          color: Colors.black,
        ),
        onPressed: (){
          DatabaseHelper.db.pinOrUnpin(note);
          setState(() {});
        },
      ),
    );
  }

  Widget addNoteButton(){
    return CircleAvatar(
      radius: (screenHeight - 16*3) / 27,
      backgroundColor: backgroundPink,
      child: IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () async {
          Navigator.push(context, New_note_Page.getRoute(widget.username, null));
        },
      ),
    );
  }

  Widget checkRemindersButton(){
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: backgroundPink,
        foregroundColor: backgroundPink,
        fixedSize: Size(
            (screenWidth - 16 * 2) / 1.5,
            (screenHeight - 16 * 3) / 14.0),
        elevation: 4,
      ),
      onPressed: () async {
        showDialog(context: context, builder: (context) =>  AlertDialog(title:Text("no implementation", style: TextStyle(fontFamily: "Inter", fontSize: 18),),));
      },
      icon: const Icon(Icons.remove_red_eye, color: Colors.black,),
      label: const Text('CHECK REMINDERS', style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        height: 0,
        letterSpacing: 0.30,
      ),),
    );
  }



}