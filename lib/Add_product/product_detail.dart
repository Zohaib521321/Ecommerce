import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
class product_detail extends StatefulWidget {
  const product_detail({Key? key}) : super(key: key);
  @override
  State<product_detail> createState() => _product_detailState();
}
class _product_detailState extends State<product_detail> {
File?_image1;
  final namecontroller=TextEditingController();
  final pricecontroller=TextEditingController();
  final nocontroller=TextEditingController();

  Future getImage() async {
    var gallery = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (gallery!=null) {
        _image1=File(gallery.path);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$_image1",style: TextStyle(color: Colors.redAccent),
          ),duration: Duration(seconds: 5),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please pick image to further process",style: TextStyle(color: Colors.redAccent),
          ),duration: Duration(seconds: 5),
        ));
      }
    });
  }

  void geturl()async{
    final reference=FirebaseFirestore.instance.collection("Add_product");
    await getImage();
    final storage.Reference ref =
    storage.FirebaseStorage.instance.ref('/images'+id);
    final storage.UploadTask uploadTask = ref.putFile(_image1!.absolute);
    await Future.value(uploadTask);
    final  downurl=await ref.getDownloadURL();
    reference.doc(id.toString()).update(
      {
        "url":downurl.toString(),
      }
    ).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Updated successfully",style: TextStyle(color: Colors.redAccent),
        ),duration: Duration(seconds: 5),
      ));
    }).catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${e.message}",style: TextStyle(color: Colors.redAccent),
        ),duration: Duration(seconds: 5),
      ));
    });

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Add_product").snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
if (!snapshot.hasData) {
  return Text("Loading please wait....");
}
else
  {
    return Expanded(
      child: ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context,index){
return Card(

  elevation: 2,
  shadowColor: Colors.redAccent,
  borderOnForeground: true,
  child:
  Column(
  children:[
    SizedBox(height: 29,),
      Container(height: 400,
   child: Stack(
     alignment: Alignment.topCenter,
     children: [

       _image1!=null?Image.file(_image1!.absolute):  Image.network(snapshot.data!.docs[index]["url"],fit: BoxFit.cover,),
          InkWell(
              onTap: (){
geturl();
              },
              child: Icon(Icons.edit,color: Colors.red,size: 50,)),
     ],
   ),),

Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [Text("Item Price:"+snapshot.data!.docs[index]["product_price"]),
      Text("Product name:"+snapshot.data!.docs[index]["product_name"])
  ],


),
      SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(onPressed: (){
  showDialog(
  context: context,
  builder: (BuildContext context) {
  return AlertDialog(

title: Text("Update"),
  content: Column(
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




    ],

  ),
    actions: [
      ElevatedButton(onPressed: (){
        Navigator.pop(context);
      }, child: Text("Cancel")),
      ElevatedButton(onPressed: ()async{

FirebaseFirestore.instance.collection("Add_product").doc(id).update({"product_name":namecontroller.text.toString(),"product_price":pricecontroller.text.toString(),"phonenumber":nocontroller.text.toString()}).
then((value){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Updated",style: TextStyle(color: Colors.redAccent),
    ),duration: Duration(seconds: 5),
  ));
}).catchError((e){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("${e.message}",style: TextStyle(color: Colors.redAccent),
    ),duration: Duration(seconds: 5),
  ));
}).then((value) {
  Navigator.pop(context);
});

      }, child: Text("update"))
    ],
  );
  });
          }, child: Text("Edit")),
          ElevatedButton(onPressed: (){
            FirebaseFirestore.instance.collection("Add_product").doc(snapshot.data!.docs[index]["id"]).delete();
          }, child: Text("Delete"))
        ],
      )
  ]
  )


);


      }),
    );
  }
            },
          )
        ],
      ),
    );
  }
}
