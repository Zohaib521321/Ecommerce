import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
class chatroom extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String id;
  const chatroom({Key? key, required this.name, required this.imageUrl,required this.id})
      : super(key: key);
  @override
  State<chatroom> createState() => _chatroomState();
}
class _chatroomState extends State<chatroom> {
  final messagecontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.imageUrl),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              widget.name,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder(
                  stream:FirebaseFirestore.instance.collection("messages") .where("senderid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .where("recieverid", isEqualTo: widget.id).orderBy("Date",descending: false).snapshots(),
                  builder: (builder,AsyncSnapshot<QuerySnapshot>snapshot){
                    if(!snapshot.hasData){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (itemBuilder, index) {
                          final message = snapshot.data!.docs[index]["message"];
                          final senderId = snapshot.data!.docs[index]["senderid"];
                          final currentUser = FirebaseAuth.instance.currentUser;
                          final isMe = senderId == currentUser!.uid;
                          final alignment = isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
                          final messageTextStyle = isMe ? TextStyle(color: Colors.white) : TextStyle(color: Colors.black);
                          final messageColor = isMe ? Colors.blue : Colors.grey.shade300;
                          return Row(
                            mainAxisAlignment: alignment,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: messageColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: isMe ? Radius.circular(20) : Radius.circular(0),
                                    topRight: isMe ? Radius.circular(0) : Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  message,
                                  style: messageTextStyle,
                                ),
                              ),
                            ],
                          );
                        });
                  }),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: messagecontroller,
                        decoration: InputDecoration(
                          hintText: 'Type a message.....',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: ()async {
                      print("ID=="+widget.id);
                      if (messagecontroller.text.isNotEmpty) {
                        FirebaseFirestore.instance.collection("messages").add({
                          "senderid":FirebaseAuth.instance.currentUser!.uid,
                          "recieverid":widget.id,
                          "Date":DateTime.now(),
                          "message":messagecontroller.text.toString(),
                        }).whenComplete(() {

                          Fluttertoast.showToast(msg: "Send message to ${widget.name}........."
                              ,
                              backgroundColor: Colors.grey,
                              timeInSecForIosWeb: 1
                          );
                        });
                        messagecontroller.clear();
                      }
                      else{
                        Fluttertoast.showToast(msg: "Please Enter text to send message to ${widget.name}"
                            ,
                            backgroundColor: Colors.red
                        );
                      }

                    },
                    icon: Icon(Icons.send),
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
