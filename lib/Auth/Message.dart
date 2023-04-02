import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import '../Message/Home_message.dart';
class message extends StatefulWidget {
  const message({Key? key}) : super(key: key);
  @override
  State<message> createState() => _messageState();
}

class _messageState extends State<message> {
  var collection=FirebaseFirestore.instance.collection("user3");
  bool isSearchBarExpanded = false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      actions: [
       Expanded(
         child: Align(
           alignment: Alignment.centerRight,
           child: SearchBarAnimation(textEditingController: TextEditingController(),
                isOriginalAnimation: true,
                enableKeyboardFocus: true,
                onExpansionComplete: () {
                  debugPrint(
                      'Expansion');
                  setState(() {
                    isSearchBarExpanded = true;
                  });
                },
                onCollapseComplete: () {
                  debugPrint(
                      'Collapse');
                  setState(() {
                    isSearchBarExpanded = false;
                  });
                },

                onPressButton: (isSearchBarOpens) {
                  debugPrint(
                      'Pressed');
                },
                trailingWidget:Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.black,
                ),
                secondaryButtonWidget: Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.black,
                ),
                buttonWidget: Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.black,
                ),),
         ),
       ),

      ],
    ),
      backgroundColor: Colors.grey.shade300,
      floatingActionButton: IconButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (builder)=>home_message()));
        },


        icon: Icon(Icons.add_circle,size: 50,color: Colors.grey,),
      ),
      body: Container(),
    );
  }
}

