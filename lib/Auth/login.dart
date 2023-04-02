import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/Add_product/forget.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);
  @override
  State<login> createState() => _loginState();
}
class _loginState extends State<login> {
 var emailcontroller=TextEditingController();
 var passcontroller=TextEditingController();
 final _formKey = GlobalKey<FormState>();
 final contact=RoundedLoadingButtonController();
 bool _isAddToContactLoading = false;
 final contact1=RoundedLoadingButtonController();
 bool _isAddToContactLoading1 = false;
 final contact2=RoundedLoadingButtonController();
 bool _isAddToContactLoading2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Field is required"),
                    ]),
                    obscureText: true,
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
              RoundedLoadingButton(
                child: Text(
                  'Login',
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
                    var auth=FirebaseAuth.instance;
                    auth.signInWithEmailAndPassword(email: emailcontroller.text.toString(), password: passcontroller.text.toString()).then((value){
                      Navigator.pushReplacementNamed(context, "/bottom");
                    }).catchError((e){
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.topSlide,
                        title: 'OOP\'S',
                        desc: '${e.message}',
                        dialogBackgroundColor: Colors.grey,
                        btnCancelOnPress: () {
                        },
                      )..show();
                    });
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
// ElevatedButton(onPressed: (){
//   var auth=FirebaseAuth.instance;
//   auth.signInWithEmailAndPassword(email: emailcontroller.text.toString(), password: passcontroller.text.toString()).then((value){
// Navigator.pushReplacementNamed(context, "/bottom");
//   }).catchError((e){
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text("${e.message}"),duration: Duration(seconds: 5),
//     ));
//   });
// }, child: Text("Login")),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>forget()));
                }, child: Text("Forget password")),
              ),
              SizedBox(height: 19,),
              Text("Have not already account?"),
              SizedBox(height: 12,),
              RoundedLoadingButton(
                child: Text(
                  'Signup',
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
                  Navigator.pushReplacementNamed(context, "/signup");
                  setState(() {
                    _isAddToContactLoading1 = false;
                  });
                  contact1.success();

                },
              ),
              // ElevatedButton(onPressed: (){
              //   Navigator.pushReplacementNamed(context, "/signup");
              // }, child: Text("Signup"))
            ],
          ),
        ),
      ),
    );
  }
}
