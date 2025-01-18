import 'package:flutter/material.dart';
class NoteappFirebaseExample extends StatefulWidget{
  @override
  State<NoteappFirebaseExample> createState()=> _NoteappFirebaseExampleState();
}
class _NoteappFirebaseExampleState extends State<NoteappFirebaseExample>{
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Noteapp Firebase Example"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        showModalBottomSheet(context: context, builder: (BuildContext context){
          return Container(
            height: 400,
            width: 410,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.red),
          );
        });
      }),
    );
  }
}