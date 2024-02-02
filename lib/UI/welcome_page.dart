import 'package:diary/repository/database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/note.dart';
import '../utils/local_notifications.dart';
import 'new_note_page.dart';
import 'login_page.dart';
import 'note_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'note_page.dart';

class WelcomePage extends StatefulWidget {
  final String username;
  WelcomePage({required this.username});

  @override
  _WelcomePageState createState() => _WelcomePageState();

  static PageRouteBuilder getRoute({required String username}) {
    return PageRouteBuilder(pageBuilder: (_, __, ___) {
      return WelcomePage(username: username);
    });
  }
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  initState(){
    super.initState();
    listenToNotifications();
  }

  //listen to any notification clicked or not
  listenToNotifications(){
    print("listenToNotifications");
    LocalNotifications.onClickNotification.stream.listen((event) {
      Navigator.push(
          context,
          NotePage.getRoute(note: Note.toNote(event))
      );
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut()
        .then((value) => Navigator.push(context, LoginPage.getRoute()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(128, 184, 168, 194),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height/4),
          child: AppBar(
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/header.png"),
                      fit: BoxFit.fill
                  )
              ),
            ),
          ),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30),
              Text(
                "WELCOME, TOTORO!",
                style: TextStyle(fontFamily: "Inter", fontSize: 35, fontWeight: FontWeight.bold, color: Color.fromARGB(230, 232, 228, 231)),
              ),
              SizedBox(height: 20),
              _buildFunctionalitySection(context),
              SizedBox(height: 30),
              Align(alignment: Alignment.centerLeft,
                  child: FutureBuilder<Note?>(
                    future: DatabaseHelper.db.getLastNoteByUsername(widget.username),
                    builder: (BuildContext context, AsyncSnapshot<Note?> snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return _buildNoteSection(snapshot.data!);
                      }else{
                        return _buildNoteSection(Note(username: "", title: "Write your first note!", body: ""));
                      }
                    },
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildFunctionalitySection(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height/10,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ElevatedButton(onPressed: (){
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> New_note_Page(username: widget.username, onEntrySaved: _handleEntrySaved,)));
            },
              child: Text("MAKE A NOTE", style: TextStyle(fontFamily: "Inter", fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold)),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width/1.1, MediaQuery.of(context).size.height/15)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45),
                  ),
                ), backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 189, 157, 164)),
              ),),
            Align( alignment: Alignment(0.95,0), child: ElevatedButton(onPressed: (){
              showDialog(context: context, builder: (context) =>  AlertDialog(title:Text("no implementation", style: TextStyle(fontFamily: "Inter", fontSize: 18),)));
            },
              child: Align( alignment: Alignment.center,
                  child: Icon(Icons.notifications_none_outlined, color: Colors.black, size: 22,)),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.height/11, MediaQuery.of(context).size.height/11)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: BorderSide(color: Color.fromARGB(230, 232, 228, 231), width: 7),
                    borderRadius: BorderRadius.circular(90),
                  ),
                ), backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 189, 157, 164)),
              ),),
            ),],)
    );
  }

  /// Section Widget
  Widget _buildNoteSection(Note lastNote){
    return Stack(children:<Widget> [
      Column(
        children: [
          Align(alignment: Alignment.topLeft, child:
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/15),
            child: Text(
              "ENJOY TACKING NOTES",
              style: TextStyle(fontFamily: "Inter", fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),
            ),
          ),),
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20, right: MediaQuery.of(context).size.width/20),
            child:
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              height: MediaQuery.of(context).size.height/3.2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration( color: Color.fromARGB(179, 171, 146, 146),
                borderRadius: BorderRadius.circular(45),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 15),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/1.3,
                    child: Text(

                      "${lastNote?.title}\n\n${lastNote?.body}",
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: "Inter", fontSize: 16),
                    ),
                  ),
                  //SizedBox(height: 10),
                ],
              ),
            ),),
          SizedBox(height: 40),
        ],
      ),
      Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/15, top:MediaQuery.of(context).size.height/3.6), child:
          Column(children: [
            Row(children: [
              SizedBox(width: MediaQuery.of(context).size.width/1.45),
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NoteListPage(username: widget.username)));
            },
              child: Align( alignment: Alignment.center,
                  child: Icon(Icons.north_east, color: Colors.black, size: 22,)),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.height/10, MediaQuery.of(context).size.height/10)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: BorderSide(color: Color.fromARGB(230, 232, 228, 231), width: 7),
                    borderRadius: BorderRadius.circular(90),
                  ),
                ), backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 189, 157, 164)),
              ),),],),
            Row(children:[
              IconButton(onPressed: (){
                _logout();
            }, icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 30)),])
          ],
          )
      )
    ]);
  }
}