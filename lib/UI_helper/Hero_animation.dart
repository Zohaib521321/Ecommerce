import 'package:flutter/material.dart';


class animation extends StatefulWidget {
  final String url;
  final String productName;
  animation({required this.url,required this.productName}) ;

  @override
  State<animation> createState() => _animationState();
}

class _animationState extends State<animation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
title: Text(widget.productName),
        centerTitle: true,
        backgroundColor: Colors.white10,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width*1.8,
          height: MediaQuery.of(context).size.height*0.9,
          child: Hero(
            tag: "background",
            child: Image.network(widget.url),
          ),
        ),
      ),
    );

  }
}
