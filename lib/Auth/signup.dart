import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import 'package:rounded_loading_button/rounded_loading_button.dart';
final id=DateTime.now().microsecondsSinceEpoch.toString();
class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
 var passcontroller=TextEditingController();
 var namecontroller=TextEditingController();
 var lastcontroller=TextEditingController();
 var emailcontroller=TextEditingController();
 var phonecontroller=TextEditingController();
 var geturl;
 final contact=RoundedLoadingButtonController();
 bool _isAddToContactLoading = false;
 final contact1=RoundedLoadingButtonController();
 bool _isAddToContactLoading1 = false;
 final _formKey = GlobalKey<FormState>();
 File?_image;
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
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 24,),
Padding(
  padding: const EdgeInsets.all(12.0),
  child:   Align(
    alignment: Alignment.topRight,
    child: InkWell(
        onTap: (){
getImage();
        },
     child: _image!=null?Image.file(_image!.absolute,width: 120,height: 150,): Container(

            width: 120,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
child: Center(child: Text("Add your photo")),
        ),
    ),
  ),
),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      controller: namecontroller,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Field is required"),
                      ]),
                      decoration: InputDecoration(
                        hintText: "Abc...",
                          labelText: "Enter First name",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(

                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 19,),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      controller: lastcontroller,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Field is required"),
                      ]),
                      decoration: InputDecoration(
                          hintText: "Abc...",
                          labelText: "Enter Last name",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 19,),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailcontroller,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Field is required"),
                        EmailValidator(errorText: "Enter Valid Email")
                      ]),
                      decoration: InputDecoration(
                          hintText: "abc123@gmail.com",
                          labelText: "Enter email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 19,),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      controller: passcontroller,
                      obscureText: true,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Field Is Required"),
                        MinLengthValidator(6, errorText: "The Password Must be greater than 6 character")
                      ]),
                      decoration: InputDecoration(
                          hintText: "Password",
                          labelText: "Enter Password",
                          prefixIcon: Icon(Icons.password),
                          border: OutlineInputBorder(
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 19,),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      controller: phonecontroller,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Field is required"),
                        PatternValidator(r'^03[0-5]{1}[0-9{1}[0-9]{7}',errorText: "Please enter valid Phone number"),
                      ]),
                      decoration: InputDecoration(
                          hintText: "03112334451",
                          labelText: "Phone Number",
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 19,),
                RoundedLoadingButton(
                  child: Text(
                    'Signup',
                    style: TextStyle(color: Colors.white),
                  ),
                  controller: contact,
                  resetDuration: Duration(seconds: 7),
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
                      if (_image!=null) {
                        storage.Reference ref1=storage.FirebaseStorage.instance.ref("profile/${DateTime.now().microsecondsSinceEpoch.toString()}");
                        if(ref1!=null){
                          // print("uid"+FirebaseAuth.instance.currentUser!.uid);
                          File file = File(_image!.path);
                          storage.UploadTask task = ref1.putFile(file);
                          await Future.value(task);
                          var url1=await ref1.getDownloadURL();
                          var ref=FirebaseFirestore.instance.collection("user3");
                          print("url"+url1.toString());
                          var auth=FirebaseAuth.instance;
                          var uid;
                          auth.createUserWithEmailAndPassword(email: emailcontroller.text.toString(), password: passcontroller.text.toString()).then((signin){
                            uid =auth.currentUser!.uid ;
                            ref.doc(uid).set({
                              "id":uid,
                              "name":namecontroller.text.toString(),
                              "email":emailcontroller.text.toString(),
                              "password":passcontroller.text.toString(),
                              "phone":phonecontroller.text.toString(),
                              "imageurl":url1.toString()
                            }).then((value){
                              if (signin!=null) {
                                Navigator.pushReplacementNamed(context, "/bottom");
                              }
                            }).catchError((e){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("${e.message}"),duration: Duration(seconds: 5),
                              ));
                            });
                          });
                        }
                        else{
                          print("error in this");
                        }
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.topSlide,
                          title: 'OOP\'S',
                          desc: 'Make Sure You have Pick Profile Picture',
                          dialogBackgroundColor: Colors.grey,
                          btnCancelOnPress: () {
                          },
                        )..show();
                      }
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
//                 ElevatedButton(onPressed: ()async{
// if (_image!=null) {
//   storage.Reference ref1=storage.FirebaseStorage.instance.ref("profile/${DateTime.now().microsecondsSinceEpoch.toString()}");
// if(ref1!=null){
//   // print("uid"+FirebaseAuth.instance.currentUser!.uid);
//   File file = File(_image!.path);
//   storage.UploadTask task = ref1.putFile(file);
//   await Future.value(task);
//   var url1=await ref1.getDownloadURL();
//   var ref=FirebaseFirestore.instance.collection("user3");
// print("url"+url1.toString());
//   var auth=FirebaseAuth.instance;
//   var uid;
//   auth.createUserWithEmailAndPassword(email: emailcontroller.text.toString(), password: passcontroller.text.toString()).then((signin){
//     uid =auth.currentUser!.uid ;
//     ref.doc(uid).set({
//       "id":uid,
//       "name":namecontroller.text.toString(),
//       "email":emailcontroller.text.toString(),
//       "password":passcontroller.text.toString(),
//       "phone":phonecontroller.text.toString(),
//       "imageurl":url1.toString()
//     }).then((value){
//       if (signin!=null) {
//         Navigator.pushNamed(context, "/bottom");
//       }
//     }).catchError((e){
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("${e.message}"),duration: Duration(seconds: 5),
//       ));
//     });
//   });
// }
// else{
//   print("error in this");
// }
// } else {
//   print("error");
// }
//                 }, child: Text("Signup")),

                SizedBox(height: 19,),
                Text("Have already account?"),
                SizedBox(height: 3,),
                RoundedLoadingButton(
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  controller: contact1,
                  resetDuration: Duration(seconds: 3),
                  resetAfterDuration: true,
                  width: 200,
                  height: 50,
                  color: Colors.blue,
                  successColor: Colors.blue,
                  borderRadius: 10,
                  elevation: 3,
                  onPressed: _isAddToContactLoading1
                      ? null
                      : () async {
                    setState(() {
                      _isAddToContactLoading1 = true;
                    });
                    Navigator.pushNamed(context, "/login");
                    setState(() {
                      _isAddToContactLoading1 = false;
                    });
                    contact1.success();

                  },
                ),
                // ElevatedButton(onPressed: (){
                //   Navigator.pushNamed(context, "/login");
                // }, child: Text("Login"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
