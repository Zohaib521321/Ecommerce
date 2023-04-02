import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
class forget extends StatefulWidget {
  const forget({Key? key}) : super(key: key);

  @override
  State<forget> createState() => _forgetState();
}

class _forgetState extends State<forget> {
  var emailcontroller=TextEditingController();
  final contact1=RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  bool _isAddToContactLoading1 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                child: TextFormField(
controller: emailcontroller,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Field is required"),
                    EmailValidator(errorText: "Enter Valid Email")
                  ]),
                  decoration: InputDecoration(
                  hintText: "abc123@gmail.com",
                    labelText: "Enter your email",
                    border: OutlineInputBorder(
                    )
                  ),
                ),
              ),
              RoundedLoadingButton(
                child: Text(
                  'Forget',
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
                 if (_formKey.currentState!.validate()) {
                   FirebaseAuth.instance.sendPasswordResetEmail(email: emailcontroller.text.toString()).then((value){
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                       content: Text("We have sent email to recover password,please check email"),duration: Duration(seconds: 5),
                     ));
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
                    _isAddToContactLoading1 = false;
                  });
                  contact1.success();
                },
              ),
            ],
          ),
        ),
      ),

    );
  }
}
