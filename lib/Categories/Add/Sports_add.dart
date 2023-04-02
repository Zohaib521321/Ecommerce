import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
class sports extends StatefulWidget {
  const sports({Key? key}) : super(key: key);

  @override
  State<sports> createState() => _sportsState();
}

class _sportsState extends State<sports> {
  File?_image;
  File?_image1;
  final namecontroller=TextEditingController();
  final pricecontroller=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final contact=RoundedLoadingButtonController();
  bool _isAddToContactLoading = false;
  final nocontroller=TextEditingController();
  final postallcontroller=TextEditingController();
  String? _selectedItem;
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
      desc: 'Please enter All information correctly And provide whatsapp number So that buyer can Contact with yoyu',
      dialogBackgroundColor: Colors.grey,
      btnOkOnPress: () {

      },
    )..show();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sports and Outdoors"),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/Sport.jpg"),
          ),
        ],
      ),

      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/Sport.jpg"),
                ),
                SizedBox(height: 15,),
                Text("Select City",style: TextStyle(fontSize: 18),),
                DropdownButton<String>(
                  value: _selectedItem,
                  onChanged: (value) {
                    setState(() {
                      _selectedItem = value;
                    });
                  },
                  items: [    "Abbottabad",    "Ahmedpur East",    "Alipur",    "Arifwala",    "Attock",    "Badin",    "Bahawalnagar",    "Bahawalpur",    "Bannu",    "Battagram",    "Bhakkar",    "Bhalwal",    "Bhera",    "Chakwal",    "Chaman",    "Charsadda",    "Chichawatni",    "Chiniot",    "Chishtian",    "Chitral",    "Dadu",    "Daska",    "Depalpur",    "Dera Ghazi Khan",    "Dera Ismail Khan",    "Faisalabad",    "Fateh Jang",    "Ghotki",    "Gilgit",    "Gojra",    "Gujranwala",    "Gujrat",    "Hafizabad",    "Haripur",    "Havelian",    "Hyderabad",    "Islamabad",    "Jacobabad",    "Jaranwala",    "Jehanian",    "Jhang",    "Jhelum",    "Jiwani",    "Jhang Sadr",    "Kabirwala",    "Kahror Pakka",    "Kalat",    "Kamalia",    "Kamoke",    "Karachi",    "Karak",    "Kasur",    "Khairpur",    "Khanewal",    "Khanpur",    "Kharian",    "Khushab",    "Kohat",    "Kot Addu",    "Kotri",    "Kunri",    "Lahore",    "Larkana",    "Layyah",    "Liaquat Pur",    "Lodhran",    "Mailsi",    "Mardan",    "Mastung",    "Mian Channu",    "Mianwali",    "Mingora",    "Mirpur Khas",    "Multan",    "Muridke",    "Muzaffargarh",    "Nankana Sahib",    "Narowal",    "Nawabshah"  ].map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.6,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          color: Colors.grey,
                        ),
                        child: Text(
                          item,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  dropdownColor: Colors.white,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.teal,
                    size: 30,
                  ),
                  elevation: 10,
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 18,
                  ),
                )
                ,
                SizedBox(height: 20),
                Container(
                  width: 300,
                  child: TextFormField(
                    controller: namecontroller,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Field is required"),

                    ]),
                    decoration: InputDecoration(
                      label: Text("Product name"),

                    ),

                  ),


                ),
                SizedBox(height: 5,),
                Container(
                  width: 300,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: pricecontroller,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Field is required"),
                    ]),
                    decoration: InputDecoration(
                        label: Text("Product Price In PKR"),
                        hintText: "0000"
                    ),
                  ),
                ),
                SizedBox(height: 19,),
                Container(
                  width: 300,
                  child: TextFormField(
                    controller: nocontroller,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Field is required"),
                      PatternValidator(r'^03[0-5]{1}[0-9{1}[0-9]{7}',errorText: "Please enter valid Phone number"),]),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        label: Text("Phone number"),
                        hintText: "03000000000"
                    ),
                  ),
                ),
                SizedBox(height: 19,),
                Container(
                  width: 300,
                  child: TextFormField(
                    controller: postallcontroller,
                    keyboardType: TextInputType.number,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Field is required"),
                      MaxLengthValidator(5, errorText: "Enter valid postal code"),
                    ]),
                    decoration: InputDecoration(
                      labelText: "Enter Postal Code",
                      hintText: "123456",

                    ),
                  ),
                ),

                Center(
                  child:   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _image!=null?Image.file(_image!.absolute,width: 100,height: 100,) : Icon(Icons.image,size: 100,color: Colors.blue.shade300,),
                      ElevatedButton(onPressed: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Pick image From"),
                                content: Container(
                                  width: 250,
                                  height: 150,
                                  child: Column(
                                    children: [
                                      ElevatedButton(onPressed: ()async{
                                        final gallery=await ImagePicker().pickImage(source: ImageSource.gallery);
                                        Navigator.pop(context);
                                        setState(() {
                                          if ( gallery!=null) {
                                            _image=File(gallery.path);
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text(" $_image",style: TextStyle(color: Colors.redAccent),
                                              ),duration: Duration(seconds: 4),
                                            ));
                                          }
                                          else{
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text("No image selected",style: TextStyle(color: Colors.redAccent),
                                              ),duration: Duration(seconds: 7),
                                            ));
                                          }
                                        });

                                      }, child: Text("Pick From gallery")),

                                      ElevatedButton(onPressed: ()async{
                                        final camera=await ImagePicker().pickImage(source: ImageSource.camera);
                                        Navigator.pop(context);
                                        setState(() {
                                          if ( camera!=null) {
                                            _image=File(camera.path);
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text("image selected Successfully",style: TextStyle(color: Colors.redAccent),
                                              ),duration: Duration(seconds: 6),
                                            ));
                                          }
                                          else{
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text("No image selected",style: TextStyle(color: Colors.redAccent),
                                              ),duration: Duration(seconds: 7),
                                            ));
                                          }
                                        });


                                      }, child: Text("Pick From Camera")),

                                      ElevatedButton(onPressed: (){

                                        Navigator.pop(context);

                                      }, child: Text("Cancel")),



                                    ],

                                  ),

                                ),

                              );
                            });

                      }, child: Text("Pick Image"))

                    ],

                  ),
                ),
                SizedBox(height: 30,),
                Center(
                  child:   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _image1!=null?Image.file(_image1!.absolute,width: 100,height: 100,) : Icon(Icons.image,size: 100,color: Colors.blue.shade300,),
                      ElevatedButton(onPressed: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Pick image From"),
                                content: Container(
                                  width: 250,
                                  height: 150,
                                  child: Column(
                                    children: [
                                      ElevatedButton(onPressed: ()async{
                                        final gallery=await ImagePicker().pickImage(source: ImageSource.gallery);
                                        Navigator.pop(context);
                                        setState(() {
                                          if ( gallery!=null) {
                                            _image1=File(gallery.path);
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text(" $_image1",style: TextStyle(color: Colors.redAccent),
                                              ),duration: Duration(seconds: 4),
                                            ));
                                          }
                                          else{
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text("No image selected",style: TextStyle(color: Colors.redAccent),
                                              ),duration: Duration(seconds: 7),
                                            ));
                                          }
                                        });

                                      }, child: Text("Pick From gallery")),

                                      ElevatedButton(onPressed: ()async{
                                        final camera=await ImagePicker().pickImage(source: ImageSource.camera);
                                        Navigator.pop(context);
                                        setState(() {
                                          if ( camera!=null) {
                                            _image1=File(camera.path);
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text("image selected Successfully",style: TextStyle(color: Colors.redAccent),
                                              ),duration: Duration(seconds: 6),
                                            ));
                                          }
                                          else{
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text("No image selected",style: TextStyle(color: Colors.redAccent),
                                              ),duration: Duration(seconds: 7),
                                            ));
                                          }
                                        });


                                      }, child: Text("Pick From Camera")),

                                      ElevatedButton(onPressed: (){

                                        Navigator.pop(context);

                                      }, child: Text("Cancel")),



                                    ],

                                  ),

                                ),

                              );
                            });

                      }, child: Text("Pick Image"))

                    ],

                  ),
                ),
                SizedBox(height: 30,),
                SizedBox(height: 30,),
                RoundedLoadingButton(
                  child: Text(
                    'Add Product',
                    style: TextStyle(color: Colors.white),
                  ),
                  controller: contact,
                  resetDuration: Duration(seconds: 5),
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
                    if(_formKey.currentState!.validate()) {
                      if (_image != null&&_image1!=null){
                        if(_selectedItem!=null){
                          storage.Reference reference = storage.FirebaseStorage
                              .instance.ref("sport/${DateTime
                              .now()
                              .microsecondsSinceEpoch
                              .toString()}");
                          storage.UploadTask task = reference.putFile(
                              _image!.absolute);
                          storage.UploadTask task1= reference.putFile(
                              _image1!.absolute);
                          await Future.value(task);
                          await Future.value(task1);
                          var geturl;
                          var geturl1;
                          geturl = await reference.getDownloadURL();
                          geturl1 = await reference.getDownloadURL();
                          final ref = FirebaseFirestore.instance.collection(
                              "Add_product");
                          FirebaseFirestore.instance.collection("All_products").add({
                            "id": FirebaseAuth.instance.currentUser!.uid,
                            "product_name": namecontroller.text.toString(),
                            "product_price": pricecontroller.text.toString(),
                            "phonenumber": nocontroller.text.toString(),
                            "url": geturl.toString(),
                            "url1":geturl1.toString(),
                            "postalcode": postallcontroller.text.toString(),
                            "city":_selectedItem
                          });
                          ref.doc("product8").collection("Add_product").add({
                            "id": FirebaseAuth.instance.currentUser!.uid,
                            "product_name": namecontroller.text.toString(),
                            "product_price": pricecontroller.text.toString(),
                            "phonenumber": nocontroller.text.toString(),
                            "url": geturl.toString(),
                            "url1":geturl1.toString(),
                            "postalcode": postallcontroller.text.toString(),
                            "city":_selectedItem
                          }).
                          then((value) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: 'Success',
                              desc: 'Product Added Successfully',
                              btnOkOnPress: () {
                                Navigator.pop(context);
                              },
                            )..show();
                          }).catchError((e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("${e.message}",
                                style: TextStyle(color: Colors.redAccent),
                              ), duration: Duration(seconds: 5),
                            ));
                          }).then((value) {
                            nocontroller.clear();
                            pricecontroller.clear();
                            namecontroller.clear();
                          });
                        }
                        else{
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'Please Select your City',
                            btnCancelOnPress: () {

                            },

                          )..show();
                        }
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'Make Sure You Have Provide Pics of Product',
                          btnCancelOnPress: () {

                          },

                        )..show();

                      }
                    }
                    else{
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'Make Sure You Have Enter Valid Information',
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
                // ElevatedButton(onPressed: ()async{
                //   if(_formKey.currentState!.validate()) {
                //     if (_image != null&&_image1!=null){
                //       if(_selectedItem!=null){
                //         storage.Reference reference = storage.FirebaseStorage
                //             .instance.ref("Sport/${DateTime
                //             .now()
                //             .microsecondsSinceEpoch
                //             .toString()}");
                //         storage.UploadTask task = reference.putFile(
                //             _image!.absolute);
                //         storage.UploadTask task1= reference.putFile(
                //             _image1!.absolute);
                //         await Future.value(task);
                //         await Future.value(task1);
                //         var geturl;
                //         var geturl1;
                //         geturl = await reference.getDownloadURL();
                //         geturl1 = await reference.getDownloadURL();
                //         final ref = FirebaseFirestore.instance.collection(
                //             "Add_product");
                //         FirebaseFirestore.instance.collection("All_products").add({
                //           "id": FirebaseAuth.instance.currentUser!.uid,
                //           "product_name": namecontroller.text.toString(),
                //           "product_price": pricecontroller.text.toString()
                //           ,
                //           "phonenumber": nocontroller.text.toString(),
                //           "url": geturl.toString(),
                //           "url1":geturl1.toString(),
                //           "postalcode": postallcontroller.text.toString(),
                //           "city":_selectedItem
                //         });
                //         ref.doc("product8").collection("Add_product").add({
                //           "id": FirebaseAuth.instance.currentUser!.uid,
                //           "product_name": namecontroller.text.toString(),
                //           "product_price": pricecontroller.text.toString(),
                //           "phonenumber": nocontroller.text.toString(),
                //           "url": geturl.toString(),
                //           "url1":geturl1.toString(),
                //           "postalcode": postallcontroller.text.toString(),
                //           "city":_selectedItem
                //         }).
                //         then((value) {
                //           AwesomeDialog(
                //             context: context,
                //             dialogType: DialogType.success,
                //             animType: AnimType.rightSlide,
                //             title: 'Success',
                //             desc: 'Product Added Successfully',
                //             btnOkOnPress: () {
                //               Navigator.pop(context);
                //             },
                //           )..show();
                //         }).catchError((e) {
                //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //             content: Text("${e.message}",
                //               style: TextStyle(color: Colors.redAccent),
                //             ), duration: Duration(seconds: 5),
                //           ));
                //         }).then((value) {
                //           nocontroller.clear();
                //           pricecontroller.clear();
                //           namecontroller.clear();
                //         });
                //       }
                //       else{
                //         AwesomeDialog(
                //           context: context,
                //           dialogType: DialogType.error,
                //           animType: AnimType.rightSlide,
                //           title: 'Error',
                //           desc: 'Please Select your City',
                //           btnCancelOnPress: () {
                //
                //           },
                //
                //         )..show();
                //       }
                //     } else {
                //       AwesomeDialog(
                //         context: context,
                //         dialogType: DialogType.error,
                //         animType: AnimType.rightSlide,
                //         title: 'Error',
                //         desc: 'Make Sure You Have Provide Pics of Product',
                //         btnCancelOnPress: () {
                //
                //         },
                //
                //       )..show();
                //
                //     }
                //   }
                //   else{
                //     AwesomeDialog(
                //       context: context,
                //       dialogType: DialogType.error,
                //       animType: AnimType.rightSlide,
                //       title: 'Error',
                //       desc: 'Make Sure You Have Enter Valid Information',
                //       btnCancelOnPress: () {
                //
                //       },
                //
                //     )..show();
                //   }
                //
                // }, child: Text("Add Product",style: TextStyle(backgroundColor: Colors.blue,color: Colors.black),))

              ],
            ),
          ),
        ),
      ),

    );
  }
}
