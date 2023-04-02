import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class user_data extends StatefulWidget {
  const user_data({Key? key}) : super(key: key);

  @override
  State<user_data> createState() => _user_dataState();
}

class _user_dataState extends State<user_data> {

  var collection=FirebaseFirestore.instance.collection("user3");
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("user3").snapshots(),
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
  );
}));
}
          }),

        ],
      ),
    );
  }
}
