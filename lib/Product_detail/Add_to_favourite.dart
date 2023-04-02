import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'detail.dart';
class favourite extends StatefulWidget {
  const favourite({Key? key}) : super(key: key);

  @override
  State<favourite> createState() => _favouriteState();
}
class _favouriteState extends State<favourite> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text(("Favourite_items")),
          centerTitle: true,
          backgroundColor: Colors.grey,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("favorite").where("id",isEqualTo:FirebaseAuth.instance.currentUser!.uid).orderBy("Date",descending: true).snapshots(),
                builder:(BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                  print(FirebaseAuth.instance.currentUser!.uid);
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  };
                  if (!snapshot.hasData) {
                    return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 50));
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 1));

                    },
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (itemBuilder,index){
                          final docs = snapshot.data!.docs;
                          bool isItemFavorite = false;
                          // Check if the current item is added to favorites
                          for (var doc in snapshot.data!.docs) {
                            if (doc["url"] == snapshot.data!.docs[index]["url"]) {
                              isItemFavorite = true;
                              break;
                            }
                          }
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 10.0,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>detail(
                                          url: snapshot.data!.docs[index]["url"],
                                          productName:snapshot.data!.docs[index]["name"],
                                          productPrice: snapshot.data!.docs[index]["price"]
                                      ,phonenumber: snapshot.data!.docs[index]["phonenumber"],
                                      )));
                                    },
                                    child:  Card(
                                      child: Container(
                                        padding: EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(snapshot.data!.docs[index]["url"]),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 50),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data!.docs[index]["name"],
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      PopupMenuButton(
                                                        icon: Icon(Icons.more_vert,size: 40,color: Colors.black87,),
                                                        tooltip: "More",
                                                        itemBuilder: (context)=>[
                                                          ///info
                                                          PopupMenuItem(
                                                            value: 2
                                                            ,child: ListTile(
                                                            onTap: (){
                                                              Navigator.pop(context);
                                                              Navigator.push(context, MaterialPageRoute(builder: (builder)=>detail(
                                                                  url: snapshot.data!.docs[index]["url"],
                                                                  productName:snapshot.data!.docs[index]["name"],
                                                                  productPrice: snapshot.data!.docs[index]["price"],
                                                                phonenumber: snapshot.data!.docs[index]["phonenumber"],
                                                              )));

                                                            },
                                                            leading: Icon(Icons.details),
                                                            title:Text("Detail"),
                                                          ),
                                                          ),
                                                          ///delete
                                                          PopupMenuItem(
                                                            value: 2
                                                            ,child: ListTile(
                                                            onTap: (){
                                                                Navigator.pop(context);
                                                              showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return Container(
                                                                      color: Colors.grey,
                                                                      child: AlertDialog(
                                                                        title: Text("Delete"),
                                                                        content: Container(
                                                                            child: Text("Would you want to delete this item from Favourite")
                                                                        ),
                                                                        actions: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              TextButton(
                                                                                child: Text("No"),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                              ),
                                                                              TextButton(
                                                                                child: Text("Yes"),
                                                                                onPressed: () {
                                                                                  FirebaseFirestore.instance
                                                                                      .collection('favorite')
                                                                                      .doc(snapshot.data!.docs[index].id) // Use the document ID as the unique identifier
                                                                                      .delete().then((value){
                                                                                    Fluttertoast.showToast(
                                                                                        msg: "Item deleted from favourite successfully",
                                                                                        toastLength: Toast.LENGTH_SHORT,
                                                                                        gravity: ToastGravity.BOTTOM,
                                                                                        timeInSecForIosWeb: 5,
                                                                                        backgroundColor: Colors.black,
                                                                                        textColor: Colors.white,
                                                                                        fontSize: 16.0
                                                                                    );
                                                                                  });
                                                                                  Navigator.pop(context);
                                                                                },
                                                                              ),
                                                                            ],),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  });
                                  },
                                                            leading: Icon(Icons.delete),
                                                            title:Text("Delete From Favorite"),
                                                          ),
                                                          )
                                                        ],

                                                      )],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "\$${snapshot.data!.docs[index]["price"]}",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),


                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )

                                  )));

                        }),
                  );

                } ,

              ),
            ),
          ],
        ),
      );
  }
}
