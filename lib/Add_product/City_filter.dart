import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';

import '../Product_detail/detail.dart';
class city_filter extends StatefulWidget {
  final String cityname;
  const city_filter({required this.cityname});

  @override
  State<city_filter> createState() => _city_filterState();
}

class _city_filterState extends State<city_filter> {
  int aclick=0;
  int pclick=0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showAlertBox());
  }
  void _showAlertBox() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.topSlide,
      title: '${widget.cityname}',
      desc: 'If there is no Product in ${widget.cityname} Then it show empty screen ',
      dialogBackgroundColor: Colors.grey,
      btnCancelOnPress: () {

      },
    )..show();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(widget.cityname),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [

          SizedBox(height: MediaQuery.of(context).size.height*.1,),
          StreamBuilder(
              stream:  FirebaseFirestore.instance.collection("All_products").where("city",isEqualTo: widget.cityname).snapshots(),
              builder:(BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
    print(snapshot.hasData);

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 0.7),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (itemBuilder,index){
                      return Container(
                        height: 500,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),

                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, PageTransition(
                                duration: Duration(milliseconds: 600)
                                ,type: PageTransitionType.rightToLeft,
                                child:detail(
                                  url: snapshot.data!.docs[index]["url"],
                                  productName: snapshot.data!.docs[index]["product_name"],
                                  productPrice: snapshot.data!.docs[index]["product_price"],
                                  phonenumber:snapshot.data!.docs[index]["phonenumber"],
                                )));
                            setState(() {
                              pclick++;
                            });
                            FirebaseFirestore.instance
                                .collection('pclick')
                                .where('imageurl', isEqualTo: snapshot.data!.docs[index]['url'])
                                .get()
                                .then((querySnapshot) {
                              if (querySnapshot.docs.isNotEmpty){
                                // If a document with the same imageurl exists, update its pclick field
                                String docId = querySnapshot.docs.first.id;
                                int currentPclick = int.parse(querySnapshot.docs.first['pclick'].toString());
                                int updatedPclick = currentPclick + 1;
                                FirebaseFirestore.instance
                                    .collection('pclick')
                                    .doc(docId)
                                    .update({'pclick': updatedPclick.toString()});
                              } else {
                                // If no document with the same imageurl exists, add a new document
                                FirebaseFirestore.instance
                                    .collection('pclick')
                                    .add({
                                  'imageurl': snapshot.data!.docs[index]['url'],
                                  'pclick': '1',
                                  "uid": snapshot.data!.docs[index]['id'],
                                  "name":snapshot.data!.docs[index]["product_name"],
                                });
                              }
                            });



                          },
                          child: Card(
                            elevation:5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Image.network(snapshot.data!.docs[index]["url"],width: MediaQuery.of(context).size.width*.49,height:MediaQuery.of(context).size.height*.17 ,),
                                ),
                                SizedBox(height: 7,),
                                Text(
                                  snapshot.data!.docs[index]["product_name"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Rs "+snapshot.data!.docs[index]["product_price"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(onPressed: () async{
                                      final favoriteItems = await FirebaseFirestore.instance.collection("favorite").where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
                                      for (var doc in favoriteItems.docs) {
                                        if (doc["url"] == snapshot.data!.docs[index]["url"]) {
                                          Fluttertoast.showToast(
                                              msg: "Item already added to favorites",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 5,
                                              backgroundColor: Colors.redAccent,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                          return;
                                        }
                                      }
                                      FirebaseFirestore.instance.collection("favorite").add({
                                        "Date": DateTime.now(),
                                        "url": snapshot.data!.docs[index]["url"],
                                        "price": snapshot.data!.docs[index]["product_price"],
                                        "name": snapshot.data!.docs[index]["product_name"],
                                        "id": FirebaseAuth.instance.currentUser!.uid,
                                        "phonenumber":snapshot.data!.docs[index]["phonenumber"],
                                        "isFavorite": true,
                                      }).then((value) {
                                        Fluttertoast.showToast(
                                            msg: "Item added to favourite successfully",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 5,
                                            backgroundColor: Colors.black87,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      });
                                      setState(() {
                                       // Update the flag
                                        aclick++;
                                      });
                                      FirebaseFirestore.instance
                                          .collection('aclick')
                                          .where('imageurl', isEqualTo: snapshot.data!.docs[index]['url'])
                                          .get()
                                          .then((querySnapshot) {
                                        if (querySnapshot.docs.isNotEmpty) {
                                          // If a document with the same imageurl exists, update its pclick field
                                          String docId = querySnapshot.docs.first.id;
                                          int currentPclick = int.parse(querySnapshot.docs.first['aclick'].toString());
                                          int updatedPclick = currentPclick + 1;
                                          FirebaseFirestore.instance
                                              .collection('aclick')
                                              .doc(docId)
                                              .update({'aclick': updatedPclick.toString()});
                                        } else {
                                          // If no document with the same imageurl exists, add a new document
                                          FirebaseFirestore.instance
                                              .collection('aclick')
                                              .add({
                                            'imageurl': snapshot.data!.docs[index]['url'],
                                            'aclick': '1',
                                          });
                                        }
                                      });

                                    },
                                      icon: Icon(Icons.add_circle, color: Colors.redAccent),
                                    )                  ],
                                ),
                              ],
                            ),
                          ),
                        ),


                      );
                    },
                  ),
                );
              }
          ),
        ],
      ),
    );
  }
}
