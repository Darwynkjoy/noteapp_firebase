import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteapp_firebase/database.dart';
import 'package:random_string/random_string.dart';
class NoteappFirebaseExample extends StatefulWidget{
  @override
  State<NoteappFirebaseExample> createState()=> _NoteappFirebaseExampleState();
}
class _NoteappFirebaseExampleState extends State<NoteappFirebaseExample>{

  TextEditingController titleControler=TextEditingController();
  TextEditingController subtitleControler=TextEditingController();
  TextEditingController categoryControler=TextEditingController();
  TextEditingController dateControler=TextEditingController();

  Stream<QuerySnapshot>? NoteStream;

  getontheload()async{
    NoteStream=await Database.getNoteappDetatils();
    setState(() {
    });
  }

  @override
  void initState(){
    super.initState();
    getontheload();
  }
  
  Widget allNoteDetails(){
    return StreamBuilder(stream: NoteStream,
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
      if(snapshot.connectionState == ConnectionState.waiting){
        return Center(child: CircularProgressIndicator());
      }
      if(snapshot.hasError){
        return Text("An Error has occured ${snapshot.error}");
      }
      if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
        return Center(child: Text("Data is not available"));
      }
      return ListView();
    }
    );
  }

  @override
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
            padding: EdgeInsets.all(5),
            height: 400,
            width: 410,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.red),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: titleControler,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Title"),
                ),
                TextField(
                  controller: subtitleControler,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Subtitle"),
                ),TextField(
                  controller: categoryControler,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Category"),
                ),TextField(
                  controller: dateControler,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Date"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: ()async{
                          String id=randomAlphaNumeric(10);
                            Map<String,dynamic> noteappInfoMap={
                              "title":titleControler.text,
                              "subtitle":subtitleControler.text,
                              "category":categoryControler.text,
                              "date":dateControler.text,
                              "id":id,
                            };
                            await Database.addNoteappDetails(noteappInfoMap,id);
                              showDialog(context: context, builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text("Note successfully added"),
                                  actions: [
                                    TextButton(onPressed: (){
                                      Navigator.pop(context);
                                    }, child: Text("OK")),
                                  ],
                                );
                              });
                        }, child: Text("Add",style: TextStyle(fontSize: 20,color: Colors.red),)),
                    ),
                    Container(
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        }, child: Text("Cancel",style: TextStyle(fontSize: 20,color: Colors.red),)),
                    ),
                  ],
                )
              ],
            ),
          );
        });
      },
      child: Text("+",style: TextStyle(fontSize: 40,color: Colors.red),),),
    );
  }
}