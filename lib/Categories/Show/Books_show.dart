import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import '../../Product_detail/detail.dart';
class books_show extends StatefulWidget {
  const books_show({Key? key}) : super(key: key);

  @override
  State<books_show> createState() => _books_showState();
}

class _books_showState extends State<books_show> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Books"),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*.01,
            ),
            ///Image slider
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Add_product").doc("product4").collection("Add_product").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.red,
                      size: 100,
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xffDA4453), Color(0xff89216B)],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CarouselSlider.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (itemBuilder, index, real) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
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

                              },
                              child: Image.network(
                                snapshot.data!.docs[index]["url"],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.3,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.easeIn,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 15,),
            ///Books
            Text("Books and Media",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 15,),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Add_product").doc("product4").collection("Add_product").snapshots(),
                builder:(BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                  if (!snapshot.hasData) {
                    return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 10));
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
                                    children:[
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
      ),
    );
  }
}
