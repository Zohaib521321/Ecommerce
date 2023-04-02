import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart'as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
class stripe extends StatefulWidget {
  final String productPrice;
  final String productName;
 stripe({required this.productPrice,required this.productName});
  @override
  State<stripe> createState() => _stripeState();
}
class _stripeState extends State<stripe> {
  final _formKey = GlobalKey<FormState>();
  final emailcontroller=TextEditingController();
  final phonecontroller=TextEditingController();
  final postallcontroller=TextEditingController();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  Future<void> intpayment(
      {required String email, required double amount})async{
    try{
      var gpay=PaymentSheetGooglePay(merchantCountryCode: "USA",
      currencyCode: "USD",
        testEnv: true
      );
      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      String formattedDate = formatter.format(now);
      final response= await http.post(Uri.parse("https://api.stripe.com/v1/payment_intents")
          ,body:{
            "receipt_email": email,
            "amount": amount.toInt().toString(),
            "currency": "usd",
          },
          headers: {
            'Authorization': 'Bearer ' + 'sk_test_51LqlRXEwNZ69LkbQxUePyeNoYwzjLsXUR3oQNwMLNoQgcgI3NyQMLiChIIlLPDBv5ke9X3iRu0jM4AYrivWEgFRm00omFccB17',
            'Content-Type': 'application/x-www-form-urlencoded'
          }
      );
      var jsonresponse=jsonDecode(response.body);
      print(jsonresponse.toString());
      print(jsonresponse["client_secret"]);
      print("id="+jsonresponse["id"]);
      print("amount="+jsonresponse["amount"].toString());
    await  Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        merchantDisplayName: 'Zohaib',
googlePay: gpay,
paymentIntentClientSecret: jsonresponse['client_secret'],
        style: ThemeMode.dark,
customFlow: true,
      )).then((value) async{
        await Stripe.instance.presentPaymentSheet().then((value) {
          FirebaseFirestore.instance.collection("Payment").add({
            "id":FirebaseAuth.instance.currentUser!.uid,
            "Client_secret":jsonresponse["client_secret"],
            "Client_id":jsonresponse["id"],
            "amount":jsonresponse["amount"].toString(),
            "Date_time":formattedDate,
            "Product_name":widget.productName
          });
        });
        print("payment successfull");
        Fluttertoast.showToast(
            msg: "payment successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      });

    }
    catch(e){
      if (e is StripeException) {
        print(e);
        Fluttertoast.showToast(
            msg: "Stripe error $e",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      print(e);
      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Place Order'),
      centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 25,),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextFormField(
                    controller: emailcontroller,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Field is required"),
                      EmailValidator(errorText: "Enter valid email"),

                    ]),
                    decoration: InputDecoration(
                        hintText: "Enter email"
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextFormField(
                    controller: phonecontroller,
                    keyboardType: TextInputType.number,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Field is required"),
                      PatternValidator("03", errorText: "Please enter valid Phone number"),
                      MaxLengthValidator(11, errorText: "Please enter valid Phone number")
                    ]),
                    decoration: InputDecoration(
                        hintText: "Enter Phone number"
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    child: TextFormField(
                      controller: postallcontroller,
                      keyboardType: TextInputType.number,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Field is required"),
                       MaxLengthValidator(5, errorText: "Enter valid postal code"),
                      ]),
                      decoration: InputDecoration(
                          hintText: "Enter Postal Code",
                        border: OutlineInputBorder(
                        )
                      ),
                    ),
                  ),
                ),
                RoundedLoadingButton(
                  child: Text("Pay ${widget.productPrice}\$"),
                  controller: _btnController,
                 resetDuration: Duration(seconds: 6),
                  resetAfterDuration: true,
                  onPressed:()async{
                    Timer(Duration(seconds: 5), () {
                      _btnController.success();
                    });
                    if (_formKey.currentState!.validate()) {
                   await   intpayment(email: emailcontroller.text.toString(), amount: double.parse(widget.productPrice)).then((value){
                        FirebaseFirestore.instance.collection("order_detail").add({
                          "Email":emailcontroller.text.toString(),
                          "Phone":phonecontroller.text.toString(),
                          "Postal":postallcontroller.text.toString(),
                          "id":FirebaseAuth.instance.currentUser!.uid
                        });
                      });
                    }
                    else{
                      showDialog(context: context, builder: (builder){
                        return AlertDialog(
                          content: Text("Make sure you enter valid email , Phone number or postal code..."),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: Text("Cancel"))
                          ],
                        );
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
        // child: ElevatedButton(
        //   onPressed: () {
        //     intpayment(email: "Khanzohaib3231@gmail.com", amount: double.parse(widget.productPrice));
        //     },
        //   child: Text("Pay ${widget.productPrice}\$"),
        // ),
      ),

    );
  }
}
// Future RequiredFields(BuildContext context) async{
//   showModalBottomSheet(
//     elevation: 5,
//     enableDrag: true,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(20),
//         topRight: Radius.circular(20),
//       ),
//     ),
//     context: context,
//     builder: (BuildContext context) {
//       return Container(
//         height: 500,
//         child: Column(
//           children: [
//             Text("Place Order",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
//             TextFormField(
//               validator: MultiValidator([
//                 RequiredValidator(errorText: "Field is required"),
//                   EmailValidator(errorText: "Enter valid email"),
//
//               ]),
//               decoration: InputDecoration(
//                 hintText: "Enter email"
//               ),
//             ),
//             TextFormField(
//               keyboardType: TextInputType.number,
//               validator: MultiValidator([
//                 RequiredValidator(errorText: "Field is required"),
//                PatternValidator("r'^03\d{9}", errorText: "Please enter valid Phone number")
//
//               ]),
//               decoration: InputDecoration(
//                   hintText: "Enter Phone number"
//               ),
//             ),
//
//           ],
//         ),
//       );
//     },
//   );
// }
