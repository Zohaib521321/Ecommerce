import 'dart:async';
import 'package:ecommerce/Add_product/bottom_navigation.dart';
import 'package:ecommerce/Auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    final auth=FirebaseAuth.instance;
final user=auth.currentUser;
if (user!=null){
  Timer(Duration(seconds: 4),(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
        MyHomePage()
    ));
  });
} else {
  Timer(Duration(seconds: 4),(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
        signup()
    ));
  });
}

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black45,
        child: Center(
          child: CircleAvatar(
            backgroundColor: Colors.black45,
            backgroundImage: AssetImage("assets/images/mylogo.jpeg"),
            radius: 90,
          ),
        ),
      ),
    );
  }
}