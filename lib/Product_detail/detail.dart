import 'package:url_launcher/url_launcher.dart';
import 'contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/UI_helper/Hero_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'Add_to_cart.dart';
class detail extends StatefulWidget {
  final String url;
  final String productName;
  final String productPrice;
  final String phonenumber;
 detail({required this.url,required this.productName,required this.productPrice,required this.phonenumber});

  @override
  State<detail> createState() => _detailState();
}
class _detailState extends State<detail> {
  int _badgeCount = 0;
final _placeOrderController=RoundedLoadingButtonController();
final _addCartController=RoundedLoadingButtonController();
final contact=RoundedLoadingButtonController();
  bool _isAddToCartLoading = false;
  bool _isPlaceOrderLoading = false;
  bool _isAddToContactLoading = false;

  String buildWhatsAppMessage() {
    String message = 'Hi, I am interested in the product:\n';
    message += 'Product Name: ${widget.productName}\n';
    message += 'Product Image: ${widget.url}\n';
    message += 'Product Price: ${widget.productPrice}\n\n';
    message += 'Please let me know more about it.';
    return Uri.encodeFull(message);
  }
  void launchWhatsApp() async {
    String phoneNumber = 'https://wa.me/${widget.phonenumber}?text=${buildWhatsAppMessage()}';
    if (await canLaunchUrl(Uri.parse(phoneNumber))){
      launchUrl(Uri.parse(phoneNumber),mode:
      LaunchMode.externalNonBrowserApplication);
     // launch(phoneNumber);
     print(phoneNumber);
   } else {
     showDialog(context: context,
         builder: (BuildContext context) {
           return AlertDialog(
             title: Text('Seller has no WhatsApp number'),
             content: Text('Unfortunately, the seller does not have a WhatsApp account.'),
             actions: [
               ElevatedButton(
                 child: Text('OK'),
                 onPressed: () {
                   Navigator.of(context).pop();
                 },
               ),
             ],
           );
         });
   }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
centerTitle: true,
        backgroundColor: Colors.purple,
          actions: [
      Stack(
      children: [
      IconButton(
      onPressed: () {
        Navigator.push(
         context,
         PageRouteBuilder(
           transitionDuration: Duration(milliseconds: 600),
           pageBuilder: (_, __, ___) =>   CartScreen(url: widget.url, productName: widget.productName, productPrice: widget.productPrice,
             phonenumber: widget.phonenumber,
           ),
           transitionsBuilder: (_, animation, __, child){
             return RotationTransition(
               alignment: Alignment.topLeft,
               turns: animation,
               child: child,
             );
           },
         ),
       );
    },
      icon: Icon(Icons.shopping_cart),
    ),
    _badgeCount > 0
    ? Positioned(
    right: 0,
    child: Container(
    padding: EdgeInsets.all(2),
    decoration: BoxDecoration(
    color: Colors.red,
    borderRadius: BorderRadius.circular(10),
    ),
    constraints: BoxConstraints(
    minWidth: 20,
    minHeight: 20,
    ),
    child: Text(
    '$_badgeCount',
    style: TextStyle(
    color: Colors.white,
    fontSize: 12,
    ),
    textAlign: TextAlign.center,
    ),
    ),
    )
        : Container(),
    ],
      ),
    ]),
      body:Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>animation(url: widget.url,
                    productName: widget.productName)));
              },
              child: Hero(
                tag: "background",
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.url),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              widget.productName,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Price:      Rs.${widget.productPrice}',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(
              height: 10,
            ),
            RoundedLoadingButton(
              child: Text(
                'Add to Cart',
                style: TextStyle(color: Colors.white),
              ),
              controller: _addCartController,
              resetDuration: Duration(seconds: 3),
              resetAfterDuration: true,
              width: 200,
              height: 50,
              color: Colors.blue,
              successColor: Colors.blue,
              borderRadius: 10,
              elevation: 3,
              onPressed: _isAddToCartLoading
                  ? null
                  : () async {
                setState(() {
                  _isAddToCartLoading = true;
                });
                FirebaseFirestore.instance.collection("Cart").add({
                  "id": FirebaseAuth.instance.currentUser!.uid,
                  "Productname": widget.productName,
                  "productprice": widget.productPrice,
                  "url": widget.url,
                  "quantity": 1,
                }).then((value) {
                  Fluttertoast.showToast(
                      msg: "Added to Cart Successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 5,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }).whenComplete(() {
                  setState(() {
                    _isAddToCartLoading = false;
                    _badgeCount++;
                  });
                  _addCartController.success();
                });
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            SizedBox(
              height: 10,
            ),
            RoundedLoadingButton(
              child: Text(
                'Contact with seller',
                style: TextStyle(color: Colors.white),
              ),
              controller: contact,
              resetDuration: Duration(seconds: 3),
              resetAfterDuration: true,
              width: 200,
              height: 50,
              color: Colors.blue,
              successColor: Colors.blue,
              borderRadius: 10,
              elevation: 3,
              onPressed: _isAddToContactLoading
                  ? null
                  : () async {
                setState(() {
                  _isAddToContactLoading = true;
                });
             Navigator.push(context, MaterialPageRoute(builder: (builder)=>contact_seller(url: widget.url,
               productName: widget.productName,
                productPrice: widget.productPrice,
               phonenumber: widget.phonenumber,)));
                  setState(() {
                    _isAddToContactLoading = false;
                  });
                  contact.success();

              },
            ),
            // RoundedLoadingButton(
            //   child: Text(
            //     'Place Order',
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   resetDuration: Duration(seconds: 3),
            //   resetAfterDuration: true,
            //   controller: _placeOrderController,
            //   width: MediaQuery.of(context).size.width * 0.5,
            //   height: 50,
            //   color: Colors.blue,
            //   successColor: Colors.blue,
            //   borderRadius: 10,
            //   elevation: 3,
            //   onPressed: _isPlaceOrderLoading
            //       ? null
            //       : () async {
            //     setState(() {
            //       _isPlaceOrderLoading = true;
            //     });
            //
            //     // Simulate a 3-second delay before navigating to the new page
            //     await Future.delayed(Duration(seconds: 3));
            //
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (builder) => stripe(
            //           productPrice: widget.productPrice,
            //           productName: widget.productName,
            //         ),
            //       ),
            //     ).whenComplete(() {
            //       setState(() {
            //         _isPlaceOrderLoading = false;
            //       });
            //     });
            //   },
            // ),

          ],
        ),
      ),
    );
  }
}
