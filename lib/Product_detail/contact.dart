import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';
class contact_seller extends StatefulWidget {
  final String url;
  final String productName;
  final String productPrice;
  final String phonenumber;
  const contact_seller({required this.url,required this.productName,required this.productPrice,required this.phonenumber});
  @override
  State<contact_seller> createState() => _contact_sellerState();
}
class _contact_sellerState extends State<contact_seller> {
  final _formKey = GlobalKey<FormState>();
  final emailcontroller=TextEditingController();
  final phonecontroller=TextEditingController();
  final postallcontroller=TextEditingController();
  final namecontroller=TextEditingController();
  final contact=RoundedLoadingButtonController();
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
        title: Text("Contact With Seller"),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*.07,),
                Container(
                  width: MediaQuery.of(context).size.width*.7,
                  child: TextFormField(
                    controller: namecontroller,
                    keyboardType: TextInputType.name,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Field is required"),
                    ]),
                    decoration: InputDecoration(
                      labelText: "Enter Your Name",
                      hintText: "Abc..",

                    ),

                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*.05,),
                Container(
                  width: MediaQuery.of(context).size.width*.7,
                  child: TextFormField(
                    controller: emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Field Is Required"),
              EmailValidator(errorText: "Enter Valid Email")
                    ]),
                    decoration: InputDecoration(
                      labelText: "Enter Email",
                      hintText: "abcd123@gmail.com",
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*.05,),
                Container(
                  width: MediaQuery.of(context).size.width*.7,
                  child: TextFormField(
                    controller: phonecontroller,
                      keyboardType: TextInputType.number,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Field is required"),
                        PatternValidator(r'^03[0-5]{1}[0-9{1}[0-9]{7}',errorText: "Please enter valid Phone number"),
                      ]),
                      decoration: InputDecoration(
                        labelText: "Enter Whatsapp Number ",
                        hintText: "03121314123",
                      ),

                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*.05,),
                Container(
                  width: MediaQuery.of(context).size.width*.7,
                  child: TextFormField(
                    controller: postallcontroller,
                    keyboardType: TextInputType.number,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Field is required"),
                      MaxLengthValidator(5, errorText: "Enter valid postal code"),
                    ]),
                    decoration: InputDecoration(
                      labelText: "Enter Postal Code",
                      hintText: "12345",
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*.07,),
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
if (_formKey.currentState!.validate()) {
  launchWhatsApp();
  FirebaseFirestore.instance.collection("buyer_information").add({
    "name":namecontroller.text.toString(),
    "email":emailcontroller.text.toString(),
    "phonenumber":phonecontroller.text.toString(),
    "PostalCode":postallcontroller.text.toString(),
    "Date":DateTime.now(),
  });
  namecontroller.clear();
  emailcontroller.clear();
  phonecontroller.clear();
  postallcontroller.clear();
}
else{
  AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.topSlide,
    title: 'OOP\'S',
    desc: 'Make Sure You have enter Valid information',
    dialogBackgroundColor: Colors.grey,
    btnCancelOnPress: () {
      },
  )..show();
}
                    setState(() {
                      _isAddToContactLoading = false;
                    });
                    contact.success();

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
