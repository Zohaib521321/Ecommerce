import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'chatroom.dart';
class home_message extends StatefulWidget {
  const home_message({Key? key}) : super(key: key);

  @override
  State<home_message> createState() => _home_messageState();
}

class _home_messageState extends State<home_message> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection("user3").where("id",isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                if (!snapshot.hasData) {
                  return Text("Loading please wait...........");
                }
                else{
                  return Expanded(child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:  NetworkImage(snapshot.data!.docs[index]["imageurl"].toString()),
                          ),
                          title: Text(snapshot.data!.docs[index]["name"].toString()),
                          subtitle: Text(snapshot.data!.docs[index]["email"].toString()),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (builder)=>
                                chatroom(
                                  name:snapshot.data!.docs[index]["name"] ,
                                  imageUrl: snapshot.data!.docs[index]["imageurl"],
                                  id:snapshot.data!.docs[index]["id"],
                                )
                            ));
                          },
                        );
                      }));
                }
              }),

        ],
      ),
    );
  }
}
