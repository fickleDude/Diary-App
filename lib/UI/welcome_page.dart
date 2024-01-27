import 'package:flutter/material.dart';
import 'diary_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  TextEditingController _usernameController = TextEditingController();
  bool isDarkMode = false;


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
            decoration: BoxDecoration(
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
              style: TextStyle(fontFamily: "Inter", fontSize: 40, fontWeight: FontWeight.bold, color: Color.fromARGB(230, 232, 228, 231)),
            ),
            SizedBox(height: 20),
            _buildFunctionalitySection(context),
            SizedBox(height: 30),
            Align(alignment: Alignment.centerLeft, child: _buildNoteSection(context)),
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
          ElevatedButton(onPressed: (){},
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
          int Time_min = TimeOfDay.now().minute;
          int Time_hour = TimeOfDay.now().hour;
          int Time_day = DateTime.now().day;
          int Time_mounth = DateTime.now().month;
          int count = 0;
          var list = StringBuffer();
          List<String> reminders = [];
          for (int i = 0; i < entries.length;i++){
            List<String> entryLines = entries[i].split('\n');
            String entryTitle = entryLines[0];
            String entryContent = entryLines[1];
            String entryTimeHour = entryLines[2];
            String entryTimeMin = entryLines[3];
            String entryTimeDay = entryLines[4];
            String entryTimeMounth = entryLines[5];
            var hour = int.parse(entryTimeHour);
            var min = int.parse(entryTimeMin);
            var day = int.parse(entryTimeDay);
            var mounth = int.parse(entryTimeMounth);
            if ((hour == Time_hour && min == Time_min && day == Time_day && mounth == Time_mounth) || (mounth < Time_mounth) || (hour == Time_hour && min < Time_min && day == Time_day && mounth == Time_mounth)
                || (day < Time_day && mounth == Time_mounth) || (hour < Time_hour && min == Time_min && day == Time_day && mounth == Time_mounth)){
              count++;
              reminders.add(entryTitle);
            }
          }
          reminders.forEach((item){
            list.writeln(item);
          });
          String list_ = list.toString();
          showDialog(context: context, builder: (context) =>  AlertDialog(title:Text("Number of reminders:$count", style: TextStyle(fontFamily: "Inter", fontSize: 18),),
            content: Text("$list_",style: TextStyle(fontFamily: "Inter", fontSize: 18),),));

        },
          child: Align( alignment: Alignment.centerLeft,
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
  Widget _buildNoteSection(BuildContext context) {
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
                    "TITLE\n\nYou Must Have Seen One Of The Spirits Of The Forest, And That Means You're A Very Lucky Girl. You Can Only See The Spirits If They Want You To. Let's Go Give Them A Proper Greeting.",
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: "Inter", fontSize: 16),
                  ),
                ),
                //SizedBox(height: 10),
              ],
            ),
          ),),
          SizedBox(height: 50),
        ],
    ),
      Positioned(bottom: 30, left: MediaQuery.of(context).size.width/1.25, child:
      ElevatedButton(onPressed: (){},
        child: Align( alignment: Alignment.center,
            child: Icon(Icons.north_east, color: Colors.black, size: 35,)),
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.height/8, MediaQuery.of(context).size.height/8)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(color: Color.fromARGB(230, 232, 228, 231), width: 7),
              borderRadius: BorderRadius.circular(90),
            ),
          ), backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 189, 157, 164)),
        ),),),
      Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/15, top:MediaQuery.of(context).size.height/2.6), child:
      IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 30)))
    ]);
  }
}