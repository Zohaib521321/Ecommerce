import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerce/Categories/Add/Automotive_add.dart';
import 'package:ecommerce/Categories/Add/Beauty_add.dart';
import 'package:ecommerce/Categories/Add/Books_add.dart';
import 'package:ecommerce/Categories/Add/Clothing_Fashion_add.dart';
import 'package:ecommerce/Categories/Add/Electronics_add.dart';
import 'package:ecommerce/Categories/Add/Health_add.dart';
import 'package:ecommerce/Categories/Add/HomeAndKitchen_add.dart';
import 'package:ecommerce/Categories/Add/Sports_add.dart';
import 'package:ecommerce/Categories/Add/Toys_add.dart';
import 'package:flutter/material.dart';
class dropdown_add extends StatefulWidget {
  const dropdown_add({Key? key}) : super(key: key);
  @override
  State<dropdown_add> createState() => _dropdown_addState();
}
class _dropdown_addState extends State<dropdown_add> {
  String? _selectedItem;
  bool _valid = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showAlertBox());
  }
  void _showAlertBox() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.topSlide,
      title: 'Hi',
      desc: 'If You don\'t find your Category then select related Category',
      dialogBackgroundColor: Colors.grey,
      btnOkOnPress: () {

      },
    )..show();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Select Category"),
        centerTitle: true,
backgroundColor: Colors.grey,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButton<String>(
                style: TextStyle(color: Colors.brown, fontSize: 18),
                items: [
                  'Fashion',
                  'Electronics',
                  'Home and Kitchen',
                  'Beauty and Personal Care',
                  'Sports and Outdoors',
                  'Books and Media',
                  "Toys and Games",
                  "Health and Wellness",
                  "Automotive",
                ].map((String item) {
                  return DropdownMenuItem<String>(

                    value: item,
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.6,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: Colors.grey,
                      ),
                      child: Text(
                        item,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedItem = value;
                  });
                },
                value: _selectedItem,
                dropdownColor: Colors.grey
                ,
                elevation: 16,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_selectedItem == null) {
                    setState(() {
                      _valid = false;
                    });
                  } else {
                    switch (_selectedItem) {
                      case 'Fashion':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => fashion()));
                        break;
                      case 'Electronics':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => electronics()));
                        break;
                      case 'Home and Kitchen':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => kitchen()));
                        break;
                      case 'Beauty and Personal Care':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => beauty()));
                        break;
                      case 'Sports and Outdoors':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => sports()));
                        break;
                      case 'Books and Media':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => books()));
                        break;
                      case 'Toys and Games':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => toys()));
                        break;
                      case 'Health and Wellness':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => health()));
                        break;
                      case 'Automotive':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => automative()));
                        break;
                    }
                  }
                },
                child: Text("Add Product"),
              ),
              _valid ? SizedBox() : Text("Please select an item to start quiz",),
            ],
          ),
        ),
      ),
    );
  }
}
