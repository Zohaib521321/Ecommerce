import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../UI_helper/Hero_animation.dart';
class Product_detail extends StatefulWidget {
  final String url;
  final String url1;
  final String productName;
  final String productPrice;
  final String phonenumber;
  final String doc;
  const Product_detail({required this.url,required this.url1,required this.doc,required this.productName,required this.productPrice,required this.phonenumber});
  @override
  State<Product_detail> createState() => _Product_detailState();
}
class _Product_detailState extends State<Product_detail> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showAlertBox());
  }
  void _showAlertBox() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      title: 'Hi',
      desc: 'You can request to us if you want update and delete item.Also give'
          ' the '
          'reason and provide specific information of what you want to update',
      dialogBackgroundColor: Colors.grey,
      btnOkOnPress:(){

      },
    )..show();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
        backgroundColor: Colors.grey,
        centerTitle: true,
        ///popup
// actions: [
//   Row(
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: [
//       PopupMenuButton(
//         icon: Icon(Icons.more_vert,size: 40,color: Colors.black87,),
//         tooltip: "More",
//         itemBuilder: (context)=>[
//           ///delete
//           PopupMenuItem(
//             value: 2
//             ,child: ListTile(
//             onTap: (){
//               Navigator.pop(context);
//               showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return Container(
//                       color: Colors.grey,
//                       child: AlertDialog(
//                         title: Text("Delete"),
//                         content: Container(
//                             child: Text("Would you want to delete this Product")
//                         ),
//                         actions: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               TextButton(
//                                 child: Text("No"),
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                               TextButton(
//                                 child: Text("Yes"),
//                                 onPressed: () {
//                                   FirebaseFirestore.instance
//                                       .collection('All_products')
//                                       .doc(widget.doc) // Use the document ID as the unique identifier
//                                       .delete().then((value){
//                                     Fluttertoast.showToast(
//                                         msg: "Product Deleted successfully",
//                                         toastLength: Toast.LENGTH_SHORT,
//                                         gravity: ToastGravity.BOTTOM,
//                                         timeInSecForIosWeb: 5,
//                                         backgroundColor: Colors.black,
//                                         textColor: Colors.white,
//                                         fontSize: 16.0
//                                     );
//                                   });
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                             ],),
//                         ],
//                       ),
//                     );
//                   });
//             },
//             leading: Icon(Icons.delete),
//             title:Text("Delete Product"),
//           ),
//           )
//         ],
//
//       )],
//   ),
// ],
      ),

      backgroundColor: Colors.grey.shade200,
body: Container(
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
        'Price: Rs.${widget.productPrice}',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
      SizedBox(
        height: 10,
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
