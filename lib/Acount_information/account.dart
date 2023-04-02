import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);
  @override
  State<Account> createState() => _AccountState();
}
class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  title: Text("Account information"),
  elevation: 15,
  backgroundColor: Colors.blue,
),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellow.shade500, Colors.red.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),),
        child:StreamBuilder(
          stream: FirebaseFirestore.instance.collection("user3").where("id",isEqualTo:FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder:(BuildContext ,AsyncSnapshot<QuerySnapshot>snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(color: Colors.blueGrey,backgroundColor: Colors.blue));
            }
            return
              Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (itemBuilder,index){
              return  Column(
                children: [
                    SizedBox(height: 40,),
                    Align(
    alignment: Alignment.bottomLeft,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text("Your Email",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
    )),
                    ///Email
                    Container(
                   height: 80,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Card(
                      elevation: 4,
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(snapshot.data!.docs[index]["email"],style: TextStyle(fontSize: 18),),

                              ],
                            ),
                     ),
                   ),
                 ),
                    SizedBox(height: 20,),
                    ///Phone
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Phone Number",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                        )),
                    ///Number
                    Container(
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(snapshot.data!.docs[index]["phone"],style: TextStyle(fontSize: 18),),
                              InkWell(
                                  onTap: (){
                                    updatenumber(context);
                                  },
                                  child: Icon(Icons.edit,size: 30,color: Colors.black,)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 150,),
                 ///Signout
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Card(
                     elevation: 4,
                     child: ListTile(
                       leading: Icon(Icons.logout),
                       title:    Align(
                         alignment: Alignment.center,
                         child: Text("Logout",),),
                       onTap: (){
                         signout(context);
                       },
                     ),
                   ),
                 ),
                  ],
                );
            }),
            );
        } ,
        )
      ),
    );
  }
}
///signout
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
///Update email
void updateemail(BuildContext context) {
  final editcontroller=TextEditingController();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update"),
          content: Container(
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: editcontroller,
              decoration: InputDecoration(

                hintText: "Enter Email",
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
                        "email":editcontroller.text.toString(),
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
///Update phone number
void updatenumber(BuildContext context) {
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
                hintText: "Enter Phone number",
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
                        "phone":editcontroller.text.toString(),
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