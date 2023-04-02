import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Product_detail/Add_to_favourite.dart';
import 'package:ecommerce/Product_detail/detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
class CartScreen extends StatefulWidget {
  final String url;
  final String productName;
  final String productPrice;
  final String phonenumber;
  CartScreen({required this.url,required this.productName,required this.productPrice,required this.phonenumber});
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<String> _cart = [];
  int _quantity=1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Cart"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body:
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Cart").where("id",isEqualTo:FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder:(BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){

          if (!snapshot.hasData) {
            return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 100));
          }
         return RefreshIndicator(
           onRefresh: () async {
             await Future.delayed(Duration(seconds: 1));
             setState(() {});
           },

           child: ListView.builder(
               itemCount: snapshot.data!.docs.length,
               itemBuilder: (itemBuilder,index){
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
    Navigator.push(context, MaterialPageRoute(builder: (builder)=>detail(url: widget.url,
        productName:widget.productName,
        productPrice: widget.productPrice,
      phonenumber: widget.phonenumber,
    )));
  },
  onLongPress: (){
    showDialog(
        context: context,
        builder: (BuildContext context){
            return Container(
              color: Colors.grey,
              child: AlertDialog(
                title: Text("Delete"),
                content: Container(
                    child: Text("Would you want to delete this item from Cart")
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
                              .collection('Cart')
                              .doc(snapshot.data!.docs[index].id) // Use the document ID as the unique identifier
                              .delete().then((value) {
                            Fluttertoast.showToast(
                                msg: "Item deleted successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.grey,
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
  child:   Card(
    child: Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(

  snapshot.data!.docs[index]["url"]

                  ),

                  fit: BoxFit.cover,

                ),

              ),

            ),

            SizedBox(width: 16),

            Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(

                  snapshot.data!.docs[index]["Productname"],

                  style: TextStyle(

                    fontWeight: FontWeight.bold,

                    fontSize: 16,

                  ),

                ),

                SizedBox(height: 8),

                Row(

                  children: [

                    Text(



               "${int.parse(snapshot.data!.docs[index]["productprice"].toString())*snapshot.data!.docs[index]["quantity"]}",

                      style: TextStyle(

                        fontWeight: FontWeight.bold,

                        fontSize: 16,

                      ),

                    ),

                    SizedBox(width: 16),

                    IconButton(

                      icon: Icon(Icons.remove),

                      onPressed: ()async{

                        setState(() {

                          if (_quantity>1) {

                                _quantity--;

                          }

                        });

                        await FirebaseFirestore.instance

                            .collection('Cart')

                            .doc(snapshot.data!.docs[index].id) // Use the document ID as the unique identifier

                            .update({'quantity': _quantity});

                      },

                    ),

                    SizedBox(width: 8),

                    Text(

                      "${snapshot.data!.docs[index]["quantity"]}",

                      style: TextStyle(

                        fontWeight: FontWeight.bold,

                        fontSize: 16,

                      ),

                    ),

                    SizedBox(width: 8),

                    IconButton(

                      icon: Icon(Icons.add),

                      onPressed: ()async{

                        setState(() {
                          _quantity++;
                        });

                        await FirebaseFirestore.instance

                            .collection('Cart')

                            .doc(snapshot.data!.docs[index].id) // Use the document ID as the unique identifier

                            .update({'quantity': _quantity});

                      },

                    ),

                  ],

                ),

              ],

            ),

        ],

      ),

    ),

  ),
)));

               }),
         );

        } ,

      ),
    );
  }
}
// void delete(BuildContext context) {
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Delete"),
//           content: Container(
//             child: Text("Would you want to delete this item from Cart")
//           ),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton(
//                   child: Text("No"),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 TextButton(
//                   child: Text("Yes"),
//                   onPressed: () {
//                     FirebaseFirestore.instance
//                         .collection('Cart')
//                         .doc(snapshot.data!.docs[index].id) // Use the document ID as the unique identifier
//                         .delete();
//
//                   },
//                 ),
//               ],),
//
//           ],
//         );
//       });
// }
