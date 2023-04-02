import 'package:ecommerce/Add_product/Add_product.dart';
import 'package:ecommerce/Add_product/User_data.dart';
import 'package:ecommerce/Add_product/bottom_navigation.dart';
import 'package:ecommerce/Add_product/homescreen.dart';
import 'package:ecommerce/Auth/login.dart';
import 'package:ecommerce/Add_product/product_detail.dart';
import 'package:ecommerce/Auth/profile.dart';
import 'package:ecommerce/Auth/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ecommerce/splash_screen/splashscreen.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
        options: const FirebaseOptions(apiKey: "AIzaSyCiK0Yhr_SQTwMfzFUcOGJRxfGuBdOqYww",
            authDomain: "ecommerce-1b43e.firebaseapp.com",
            projectId: "ecommerce-1b43e",
            storageBucket: "ecommerce-1b43e.appspot.com",
            messagingSenderId: "161410519947",
            appId: "1:161410519947:web:b057cf4fa4813071e4158e",
            measurementId: "G-S0YSYBVE8E"

        )
    );
  }else{
    Stripe.publishableKey = 'pk_test_51LqlRXEwNZ69LkbQ8TnR44n8M2OJVgeKGztwsmCz52meAjpk4Sp9VPDALiI7EZ5vdgQLgT550odq8v51wOL6QGPj00ZkWIWaBC';

    await Firebase.initializeApp();
  }
  runApp(MyApp());}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {

        "/signup":(BuildContext context)=>signup(),
"/login":(BuildContext context)=>login(),
        "/homescreen":(BuildContext context)=>home_screen(),
        "/user_data":(BuildContext context)=>user_data(),
        "/add_product":(BuildContext context)=>add_product(),
        "/product_detail":(BuildContext context)=>product_detail(),
"/bottom":(BuildContext context)=>MyHomePage(),
        // "/contact":(BuildContext context)=>contact_list(),
        "/profile":(BuildContext context)=>profile(),
      },

    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text('Welcome to the home screen!'),
      ),
    );
  }
}
