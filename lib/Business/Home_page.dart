import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Business/product_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import '../Product_detail/detail.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
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
      title: 'Advise',
      desc: 'Always be honest in your business\n Thanks!',
      dialogBackgroundColor: Colors.grey,
      btnOkOnPress: () {
      },
    )..show();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seller Homepage"),
        backgroundColor: Colors.grey,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("All_products").where("id",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                print(FirebaseAuth.instance.currentUser!.uid);
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
                                    child:Product_detail(
                                      url: snapshot.data!.docs[index]["url"],
                                      productName: snapshot.data!.docs[index]["product_name"],
                                      productPrice: snapshot.data!.docs[index]["product_price"],
                                      phonenumber:snapshot.data!.docs[index]["phonenumber"],
                                      url1:snapshot.data!.docs[index]["url1"],
                                      doc:snapshot.data!.docs[index].id,
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
            SizedBox(height: MediaQuery.of(context).size.height*.07,),
            Text("Your Products",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: MediaQuery.of(context).size.height*.1,),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("All_products")
                    .where("id",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
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
                                  child:Product_detail(
                                    url: snapshot.data!.docs[index]["url"],
                                    productName: snapshot.data!.docs[index]["product_name"],
                                    productPrice: snapshot.data!.docs[index]["product_price"],
                                    phonenumber:snapshot.data!.docs[index]["phonenumber"],
                                    url1:snapshot.data!.docs[index]["url1"],
                                    doc:snapshot.data!.docs[index].id,
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
                                    children: [
                                      Text(
                                        "Rs "+snapshot.data!.docs[index]["product_price"],
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
