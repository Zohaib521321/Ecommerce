import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Business/Home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
class CNIC extends StatefulWidget {
  const CNIC({Key? key}) : super(key: key);
  @override
  State<CNIC> createState() => _CNICState();
}
class _CNICState extends State<CNIC> {
  final _formKey = GlobalKey<FormState>();
  final nocontroller=TextEditingController();
  final dobcontroller=TextEditingController();
  final doicontroller=TextEditingController();
  final doecontroller=TextEditingController();
  File?_image;
  File?_image1;
  Future getImage() async {
    var gallery = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (gallery!=null) {
        _image=File(gallery.path);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$_image",style: TextStyle(color: Colors.redAccent),
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
  void pickimage()async{
    getImage();
  }

  Future getImage1() async {
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
  void pickimage1()async{
    getImage1();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("CNIC INFORMATION"),
        centerTitle: true,

      ),
      backgroundColor: Colors.grey.shade200,
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Note: Your CNIC Information must be same"),
                SizedBox(height: MediaQuery.of(context).size.height*0.07,),
                ///front side
                InkWell(
                  onTap: (){
                    getImage();
                  },
                  child:_image!=null?Image.file(_image!.absolute,width: MediaQuery.of(context).size.width*0.45,
                    height: MediaQuery.of(context).size.height*0.15,):
                  Container(
                    width: MediaQuery.of(context).size.width*0.45,
                    height: MediaQuery.of(context).size.height*0.15,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(11.00)),
                    ),
                    child: Center(child: Text("Front Side of Your CNIC")),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height*0.07,),
                ///Back Side
                InkWell(
                  onTap: (){
                    getImage1();
                  },
                  child:_image1!=null?Image.file(_image1!.absolute,width: MediaQuery.of(context).size.width*0.45,
                      height: MediaQuery.of(context).size.height*0.15,): Container(
                    width: MediaQuery.of(context).size.width*0.45,
                    height: MediaQuery.of(context).size.height*0.15,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(11.00)),
                    ),
                    child: Center(child: Text("Back Side of Your CNIC")),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.07,),
                ///CNIC No
                Container(
                  width: MediaQuery.of(context).size.width*0.45,
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                    validator: MultiValidator(
                      [
                        RequiredValidator(errorText: "Field is required",),
                        PatternValidator(r'^[0-9]{5}-[0-9]{7}-[0-9]{1}', errorText: "Please enter Valid CNIC")
                      ]
                    ),
               controller: nocontroller,
                    decoration: InputDecoration(
                      hintText: "32100-0000000-0",
                      labelText: "Enter Your CNIC Number",
errorBorder:OutlineInputBorder(
  borderSide: BorderSide(
    color: Colors.red,
  ),
)
                        ,focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
    ),
    disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
    color: Colors.white,
    ),
    ),
                    )
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.07,),
               ///Date of birth
                Container(
                  width: MediaQuery.of(context).size.width*0.45,
                  child: TextFormField(
                    controller: dobcontroller,
                      validator: MultiValidator(
                        [
                          RequiredValidator(errorText: "Field is required"),
                          PatternValidator(r'^[0-9]{2}/[0-9]{2}/[0-9]{4}', errorText: "Please enter Valid Date Of Birth")
                        ]
                      ),
                      decoration: InputDecoration(
                        hintText: "DD/MM/YYYY 01/12/2021",
                        labelText: "Enter Your Date Of Birth",
                        errorBorder:OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        )
                        ,focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      )
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.07,),
                ///Date of issue
                Container(
                  width: MediaQuery.of(context).size.width*0.45,
                  child: TextFormField(
                    controller:doicontroller,
                      validator: MultiValidator(
                          [
                            RequiredValidator(errorText: "Field is required"),
                            PatternValidator(r'^[0-9]{2}/[0-9]{2}/[0-9]{4}', errorText: "Please enter Valid Date Of Issue")
                          ]
                      ),
                      decoration: InputDecoration(
                        hintText: "DD/MM/YYYY 01/12/2021",
                        labelText: "Enter Your CNIC Date of issue",
                        errorBorder:OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        )
                        ,focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      )
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.07,),
                ///Date of Expiry
                Container(
                  width: MediaQuery.of(context).size.width*0.45,
                  child: TextFormField(
                    controller: doecontroller,
                      validator: MultiValidator(
                          [
                            RequiredValidator(errorText: "Field is required"),
                            PatternValidator(r'^[0-9]{2}/[0-9]{2}/[0-9]{4}', errorText: "Please enter Valid Date Of Expiry")
                          ]
                      ),
                      decoration: InputDecoration(
                        hintText: "DD/MM/YYYY 01/12/2021",
                        labelText: "Enter Your CNIC Date Of Expiry",
                        errorBorder:OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        )
                        ,focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      )
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                ElevatedButton(onPressed: ()async{
if(_formKey.currentState!.validate()){
  if (_image!=null&&_image1!=null) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    print("Success");
    storage.Reference ref1=storage.FirebaseStorage.instance.ref("CNICFront/${DateTime.now().microsecondsSinceEpoch.toString()}");
    storage.Reference ref2=storage.FirebaseStorage.instance.ref("CNICBack/${DateTime.now().microsecondsSinceEpoch.toString()}");

    if(ref1!=null&&ref2!=null){
      // print("uid"+FirebaseAuth.instance.currentUser!.uid);
      File file = File(_image!.path);
      File file1 = File(_image1!.path);
      storage.UploadTask task1 = ref2.putFile(file1);
      await Future.value(task1);
      storage.UploadTask task = ref1.putFile(file);
      await Future.value(task);
      var url1=await ref1.getDownloadURL();
      var url2=await ref2.getDownloadURL();
      var ref=FirebaseFirestore.instance.collection("cnic");
      print("url1"+url1.toString());
      print("url2"+url2.toString());
      var auth=FirebaseAuth.instance;
      var uid;
        uid =auth.currentUser!.uid;
        ref.doc(uid).set({
          "id":uid,
          "cnicno":nocontroller.text.toString(),
          "dateofbirth":dobcontroller.text.toString(),
          "dateofissue":doicontroller.text.toString(),
          "dateofexpiry":doecontroller.text.toString(),
          "fronturl":url1.toString(),
          "backurl":url2.toString()
        });

    }

  }
  else{
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Error',
      desc: 'Make Sure You Have Provide Pics of CNIC',
      btnCancelOnPress: () {

      },

    )..show();
  }
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>Home()));
}
else{
  AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Error',
      desc: 'Make Sure You Have Enter Valid CNIC Information',
      btnCancelOnPress: () {

      },

                  )..show();
}
                },
                    style:ElevatedButton.styleFrom(
backgroundColor: Colors.grey,

                    )
                , child: Text("Submit"))
                   ],
            ),
          ),
        ),
      )
    );
  }
}
