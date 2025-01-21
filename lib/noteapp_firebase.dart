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
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context,index){
            DocumentSnapshot Ds=snapshot.data!.docs[index];
            return Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.black,border: Border.all(width: 0.8,color: Colors.white)),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(""+(Ds["title"] ?? "N/A"),style: TextStyle(fontSize: 24,color: const Color.fromARGB(255, 251, 187, 187),fontWeight: FontWeight.bold),),
                    Text(""+(Ds["category"] ?? "N/A"),style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w700),),
                    Text(""+(Ds["subtitle"] ?? "N/A"),style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w500),),
                    Spacer(),
                    Text(""+(Ds["date"] ?? "N/A"),style: TextStyle(fontSize: 15,color: Colors.white),),
                  ],
                ),
              ),
            );
          }),
      );
    }
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Noteapp Firebase Example",style: TextStyle(fontSize: 25,color: Colors.white),),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 33, 33)
      ),

      body: Container(
        child: Column(
          children: [
            Expanded(child: allNoteDetails()),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        onPressed: (){
        showModalBottomSheet(context: context, builder: (BuildContext context){
          return Container(
            padding: EdgeInsets.all(5),
            width: 410,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: const Color.fromARGB(255, 33, 33, 33)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: titleControler,
                  style: TextStyle(fontSize: 20,color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                      fillColor: Colors.black,
                      filled: true,
                      hintText: "Title",hintStyle: TextStyle(color: Colors.white,fontSize: 20),),
                ),
                TextField(
                  controller: subtitleControler,
                  style: TextStyle(fontSize: 20,color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                      fillColor: Colors.black,
                      filled: true,
                      hintText: "Subtitle",hintStyle: TextStyle(color: Colors.white,fontSize: 20),),
                ),TextField(
                  controller: categoryControler,
                  style: TextStyle(fontSize: 20,color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                      fillColor: Colors.black,
                      filled: true,
                      hintText: "Category",hintStyle: TextStyle(color: Colors.white,fontSize: 20),),
                ),TextField(
                  controller: dateControler,
                  style: TextStyle(fontSize: 20,color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                      fillColor:  Colors.black,
                      filled: true,
                      hintText: "Date",hintStyle: TextStyle(color: Colors.white,fontSize: 20),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Colors.black,
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
                            setState(() {
                              titleControler.clear();
                              subtitleControler.clear();
                              categoryControler.clear();
                              dateControler.clear();
                              Navigator.pop(context);
                            });
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
                          backgroundColor:  Colors.black,
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
      child: Text("+",style: TextStyle(fontSize: 40,color: Colors.red,fontWeight: FontWeight.normal),),),
    );
  }
}