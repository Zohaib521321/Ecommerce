import 'package:ecommerce/Add_product/Add_dropdown.dart';
import 'package:ecommerce/Business/Home_page.dart';
import 'package:ecommerce/Business/Impression_click.dart';
import 'package:flutter/material.dart';
class Bottum extends StatefulWidget {
  const Bottum({Key? key}) : super(key: key);

  @override
  State<Bottum> createState() => _BottumState();
}

class _BottumState extends State<Bottum> {
  final List<Widget> _pages = [
    Home(),
    dropdown_add(),
impression()
  ];
  int _currentIndex = 0;
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Your Products"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), label: "Add Product"
          ),
          BottomNavigationBarItem(icon: Icon(Icons.details),label:"Detail Of Products")
        ],
      ),
    );
  }
}
