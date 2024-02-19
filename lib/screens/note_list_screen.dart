import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:diary/common/appbar.dart';
import 'package:diary/common/helpers.dart';
import 'package:diary/common/icon_button.dart';
import 'package:diary/models/note_list_model.dart';
import 'package:diary/models/note_model.dart';
import 'package:provider/provider.dart';


//UI
//contains CustomAppBar, FloatingButton and ListView
class NoteList extends StatelessWidget {
  NoteList({super.key});

  late double screenWidth;
  late double screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(height: 60,),
      //consumer causes ui redraw
      body: Stack(
        children: [
          getCover("assets/background/notes_list.jpg"),
          Consumer<NoteListModel>(
              builder: (context, noteList, child) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,//only as much vertical space as needed to display items
                  itemCount: noteList.noteList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _NoteItem(index: index,height: screenHeight / 16,width: screenWidth);
                  },
                );
              }
          ),
        ],
      ),

        //creates items on-demand
      floatingActionButton: FloatingActionButton.large(
        heroTag: null,
        backgroundColor: backgroundPink,
        shape: const CircleBorder(),
        onPressed: ()=>context.goNamed('note', extra: null),//parse extra object parameter 
        child: const Icon(Icons.add, color: Colors.black),)
      );
  }
}

//class to draw single note
class _NoteItem extends StatelessWidget {
  final int index;
  final double width;
  final double height;

  const _NoteItem({required this.index,required this.height,required this.width});


  @override
  Widget build(BuildContext context) {
    //don't cause a ui rebuild
    var note = Provider.of<NoteListModel>(context, listen: false).getByIndex(index);//provider pattern

    return InkWell(
      onTap: () => context.goNamed('note', extra: note),//parse extra object parameter
      child: Card(
        margin: const EdgeInsets.all(16),
        color: note.isPinned ? backgroundPurple : backgroundPink,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              drawTitle(note.title),
              drawNote(note.body),
              Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              _DeleteButton(item: note,),
              _PinButton(item: note,),
              const SizedBox(width: 8,)
              ],
            ),
              const SizedBox(height: 8,)
          ]
        )
      ),
    );
  }

  Widget drawNote(String body){
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 10),
      child: SizedBox(
        width: width,
        height: height,
        child: Text(
          body.length > 100 ? body.replaceRange(100, body.length, '...') : body,
          style: getTextStyle(14),
        ),
      ),
    );
  }

  Widget drawTitle(String title){
    return Container(
      width: width,
      height: height,
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
          title,
          textAlign: TextAlign.center,
          style: getTextStyle(16),
        ),
      ),
    );
  }

}

//LOGIC
//helper class for single note widget
class _DeleteButton extends StatelessWidget {
  final NoteModel item;

  const _DeleteButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(icon: const Icon(Icons.delete,color: Colors.black,),
        onPressed: (){
          var noteList = context.read<NoteListModel>();//provider pattern
          noteList.remove(item);
        });
  }
}

//helper class for single note widget
class _PinButton extends StatelessWidget {
  final NoteModel item;

  const _PinButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(icon: const Icon(Icons.push_pin,color: Colors.black,),
        onPressed: (){
          var noteList = context.read<NoteListModel>();//provider pattern
          noteList.pinOrUnpin(item);
        });
  }
}