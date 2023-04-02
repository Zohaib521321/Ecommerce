import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class add_product extends StatefulWidget {
  const add_product({Key? key}) : super(key: key);

  @override
  State<add_product> createState() => _add_productState();
}

class _add_productState extends State<add_product> {
  File?_image;
  final namecontroller=TextEditingController();
  final pricecontroller=TextEditingController();
  final nocontroller=TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
appBar: AppBar(
  title: Text("Add Product"),
centerTitle: true,
),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
   children: [
     Container(
         width: 300,
         child: TextFormField(
           controller: namecontroller,
decoration: InputDecoration(
  label: Text("Product name"),

),

         ),


     ),
     SizedBox(height: 5,),
     Container(
       width: 300,
       child: TextFormField(
         controller: pricecontroller,
         maxLength: 4,
         decoration: InputDecoration(
           label: Text("Product Price"),

         ),

       ),


     ),
     SizedBox(height: 19,),
     Container(
       width: 300,

       child: TextFormField(
         controller: nocontroller,
       maxLength: 12,
         keyboardType: TextInputType.number,
         decoration: InputDecoration(
           label: Text("Phone number"),

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
     ElevatedButton(onPressed: ()async{
if (_image!=null) {
  storage.Reference reference=storage.FirebaseStorage.instance.ref("Products/${DateTime.now().microsecondsSinceEpoch.toString()}");
  storage.UploadTask task=reference.putFile(_image!.absolute);
  await Future.value(task);
  var geturl;
  geturl=await reference.getDownloadURL();
  final ref=FirebaseFirestore.instance.collection("Add_product");
  ref.doc("product1").collection("Fashion").add({"id":FirebaseAuth.instance.currentUser!.uid,"product_name":namecontroller.text.toString(),"product_price":pricecontroller.text.toString(),"phonenumber":nocontroller.text.toString(),"url":geturl.toString()}).
    then((value){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Product added",style: TextStyle(color: Colors.redAccent),
        ),duration: Duration(seconds: 5),
      ));
    }).catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${e.message}",style: TextStyle(color: Colors.redAccent),
        ),duration: Duration(seconds: 5),
      ));
    });
    nocontroller.clear();
    pricecontroller.clear();
    namecontroller.clear();


} else {
  Text("Image is missing");
}
     }, child: Text("Add Product",style: TextStyle(backgroundColor: Colors.blue,color: Colors.black),))

   ],
        ),
      ),

    );
  }
}
