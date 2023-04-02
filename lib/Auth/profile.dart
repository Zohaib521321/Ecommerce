import 'dart:io';
import 'package:ecommerce/Acount_information/account.dart';
import 'package:ecommerce/Add_product/Add_dropdown.dart';
import 'package:ecommerce/Business/CNIC.dart';
import 'package:ecommerce/Business/Home_page.dart';
import 'package:ecommerce/Business/bottum.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:image_picker/image_picker.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
File?_image;
final editcontroller=TextEditingController();

///geturl
Future geturl()async{
  try{
    final gallery=await ImagePicker().pickImage(source: ImageSource.gallery);
    ///Gallery
    if (gallery!=null) {
               _image=File(gallery.path);
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                 content: Text("Image Picked successfull From $_image",style: TextStyle(color: Colors.redAccent),
                 ),duration: Duration(seconds: 5),
               ));
             } else {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                 content: Text("Please pick image for further proccess",style: TextStyle(color: Colors.redAccent),
                 ),duration: Duration(seconds: 5),
               ));
             }



         ///Camera
         // ListTile(
         //   leading: Icon(Icons.camera_alt_outlined),
         //   title: Text("Pick Image from camera"),
         //   onTap: () async{
         //     final camera=await ImagePicker().pickImage(source: ImageSource.camera);
         //     if (camera!=null) {
         //       _image=File(camera.path);
         //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
         //         content: Text("Image Capture successfull$_image",style: TextStyle(color: Colors.redAccent),
         //         ),duration: Duration(seconds: 5),
         //       ));
         //     } else {
         //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
         //         content: Text("Please Capture Image",style: TextStyle(color: Colors.redAccent),
         //         ),duration: Duration(seconds: 5),
         //       ));
         //
         //     }
         //     Navigator.pop(context);
         //   },
         // ),
         // ///cancel
         // ListTile(
         //   leading: Icon(Icons.cancel),
         //   title: Text("Cancel"),
         //   onTap: () {
         //     Navigator.pop(context);
         //   },
         // ),




 final reference=FirebaseFirestore.instance.collection("user3");
 final storage.Reference ref=await
 storage.FirebaseStorage.instance.ref('upimages/${DateTime.now().microsecondsSinceEpoch.toString()}');
 final storage.UploadTask uploadTask = ref.putFile(_image!.absolute);
 await Future.value(uploadTask);
 final  downurl=await ref.getDownloadURL();
 reference.doc(FirebaseAuth.instance.currentUser!.uid).update(
        {
          "imageurl":downurl.toString(),
        }
    ).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Image Updated successfully",style: TextStyle(color: Colors.redAccent),
        ),duration: Duration(seconds: 5),
      ));
    }).catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${e.message}",style: TextStyle(color: Colors.redAccent),
        ),duration: Duration(seconds: 5),
      ));
    });
  }
  catch(e){
    print(e.toString());
  }
}
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body:
           Container(
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [Colors.yellow.shade500, Colors.red.shade500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),),
            child: StreamBuilder(
             stream: FirebaseFirestore.instance.collection("user3").where("id",isEqualTo:FirebaseAuth.instance.currentUser!.uid).snapshots(),
                    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                   if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(color: Colors.blueGrey,backgroundColor: Colors.blue));
                   }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Expanded(
              child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, index) {
                 return
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 25,),
                        ///Image
                        Stack(

                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundImage:_image!=null?FileImage(_image!.absolute) : NetworkImage(snapshot.data!.docs[index]["imageurl"]) as ImageProvider,
                           backgroundColor: Colors.grey,
                            ),
                            InkWell(
                                 onTap: (){
  geturl();
                                 },
                                 child: Icon(Icons.add_a_photo,size: 30,)),
                          ],
                        ),

                   ///Name
                   Padding(
                     padding: const EdgeInsets.all(37.0),
                     child: Container(
                       height: 70,
                       child: Card(
                         elevation: 4,
                        color: Colors.yellowAccent.shade100,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                               Text(snapshot.data!.docs[index]["name"],style: TextStyle(fontSize: 18),),
                               InkWell(
                                   onTap: (){
                                  updatename(context);
                                   },
                                   child: Icon(Icons.edit,size: 30,color: Colors.black,)),
                             ],
                           ),

                       ),
                     ),
                   ),
                        ///Account Information
                        Padding(
                          padding: const EdgeInsets.all(37.0),
                          child: Card(
                             elevation: 4,
                            color: Colors.yellowAccent.shade100,
                            child: ListTile(
                              leading: Icon(Icons.account_box),
                              title: Text("Account Information"),
                       onTap: (){
                                Navigator.push(context,MaterialPageRoute(builder: (builder)=>Account()));
                       },
                            ),
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.all(37.0),
                        //   child:Card(
                        //     color: Colors.yellowAccent.shade100,
                        //     elevation: 4,
                        //     child: ListTile(
                        //       leading: Icon(Icons.add,size: 30,),
                        //       title:    Align(
                        //         alignment: Alignment.center,
                        //         child: Text("Switch to business"),
                        //       ),
                        //       onTap: (){
                        //         Navigator.push(context, MaterialPageRoute(builder: (builder)=>CNIC_scanner()));
                        //       },
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(37.0),
                          child:Card(
                            color: Colors.yellowAccent.shade100,
                            elevation: 4,
                            child: ListTile(

                              leading: Icon(Icons.add,size: 30,),
                              title:    Align(
                                alignment: Alignment.center,
                                child: Text("Switch To Business"),
                              ),
                              onTap:()async{
                                final doc = await FirebaseFirestore.instance.collection('cnic').doc(FirebaseAuth.instance.currentUser!.uid).get();
                                if(doc.exists){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>Bottum()));
                                }
else{
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>CNIC()));
                                }
                              },
                            ),
                          ),
                        ),
///Add Product
                        // ///add Product
                        // Padding(
                        //   padding: const EdgeInsets.all(37.0),
                        //   child:Card(
                        //     color: Colors.yellowAccent.shade100,
                        //     elevation: 4,
                        //     child: ListTile(
                        //       leading: Icon(Icons.add,size: 30,),
                        //       title:    Align(
                        //         alignment: Alignment.center,
                        //   child: Text("Add product"),
                        //       ),
                        //       onTap: (){
                        //        Navigator.push(context, MaterialPageRoute(builder: (builder)=>dropdown_add()));
                        //       },
                        //     ),
                        //   ),
                        // ),
                        ///Signout
                        Padding(
                          padding: const EdgeInsets.all(37.0),
                          child: Card(
                            color: Colors.yellowAccent.shade100,
                            elevation: 4,
                            child: ListTile(
                              leading: Icon(Icons.logout),
                              title:    Align(
                                alignment: Alignment.center,
                                child: Text("Logout"),


                              ),
                              onTap: (){
                             signout(context);
                              }
                            ),
                          ),
                        ),
                      ],
                    );

                },
              )
              ),
                ],
              ),
            );



                   },
                ),
          ),
       
  );
  }
}
///Signout
void signout(BuildContext context) {

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to sign out?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Logout"),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, "/login");

                  },
                ),
              ],),

          ],
        );
      });
}
///Update name
void updatename(BuildContext context) {
final editcontroller=TextEditingController();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update"),
          content: Container(
            child: TextFormField(
             controller: editcontroller,
              decoration: InputDecoration(

                hintText: "Enter name",
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Update"),
                  onPressed: () {
if (editcontroller.text == null || editcontroller.text.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Name cannot be empty",style: TextStyle(color: Colors.redAccent),
    ),duration: Duration(seconds: 5),
  ));
} else {
  FirebaseFirestore.instance.collection("user3").doc(FirebaseAuth.instance.currentUser!.uid).update({
    "name":editcontroller.text.toString(),
  }).then((value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Updated",style: TextStyle(color: Colors.redAccent),
      ),duration: Duration(seconds: 5),
    ));
  }).onError((error, stackTrace) {
    print("error");
  }).then((value) {
    Navigator.pop(context);
  });
}

                  },
                ),
              ],),

          ],
        );
      });
}
///image picker
// Future image(BuildContext context) async{
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
//         height: 200,
//         child: Column(
//           children: [
//             ///Gallery
//             ListTile(
//               leading: Icon(Icons.browse_gallery),
//               title: Text("Pick image from gallery"),
//               onTap: () async{
//                 final gallery=await ImagePicker().pickImage(source: ImageSource.gallery);
// if (gallery!=null) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     content: Text("Image Picked successfull",style: TextStyle(color: Colors.redAccent),
//     ),duration: Duration(seconds: 5),
//   ));
// } else {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     content: Text("Please pick image for further proccess",style: TextStyle(color: Colors.redAccent),
//     ),duration: Duration(seconds: 5),
//   ));
// }
//                 Navigator.pop(context);
//               },
//             ),
//            ///Camera
//             ListTile(
//               leading: Icon(Icons.camera_alt_outlined),
//               title: Text("Pick Image from camera"),
//               onTap: () async{
//                 final camera=await ImagePicker().pickImage(source: ImageSource.camera);
//                 if (camera!=null) {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text("Image Capture successfull",style: TextStyle(color: Colors.redAccent),
//                     ),duration: Duration(seconds: 5),
//                   ));
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text("Please Capture Image",style: TextStyle(color: Colors.redAccent),
//                     ),duration: Duration(seconds: 5),
//                   ));
//
//                 }
//                 Navigator.pop(context);
//               },
//             ),
//       ///cancel
//             ListTile(
//               leading: Icon(Icons.cancel),
//               title: Text("Cancel"),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
///Imageurl




