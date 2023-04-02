import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Product_detail/detail.dart';
import '../../UI_helper/Hero_animation.dart';

class search_detail extends StatefulWidget {
  final bool enableFocusMode;
  const search_detail({Key? key, required this.enableFocusMode}) : super(key: key);

  @override
  State<search_detail> createState() => _search_detailState();
}

class _search_detailState extends State<search_detail> {
  final searchcontroller = TextEditingController();
  final fousnode = FocusNode();
  Timer? _debounceTimer;
  @override
  void initState() {
    super.initState();
    if (widget.enableFocusMode) {
      Future.delayed(Duration(microseconds: 100), () {
        fousnode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    searchcontroller.dispose();
    fousnode.dispose();
    super.dispose();
  }
  void _onSearchTextChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        // Execute Firestore query here
        FirebaseFirestore.instance
            .collectionGroup("Add_product")
            .where("product_name", isGreaterThanOrEqualTo: query)
            .where("product_name", isLessThan: query + 'z')
            .snapshots();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          child: Stack(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                controller: searchcontroller,
                focusNode: fousnode,
        onChanged: _onSearchTextChanged,
                style: TextStyle(fontSize: 16, color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search Product",
                  hintStyle: TextStyle(color: Colors.white54),
                  suffixIcon: widget.enableFocusMode? IconButton(
  icon: Icon(Icons.clear,color: Colors.white,),
  onPressed: () {
    searchcontroller.clear();
  },
)
                        : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                  ),
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
              onPressed: () {
                fousnode.requestFocus();
              },
              icon: Icon(Icons.search))
        ],
      ),
      backgroundColor: Colors.grey.shade400,
      body:
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Recently Searched",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            StreamBuilder(
                stream:
                FirebaseFirestore.instance.collection("search_history").where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .orderBy("timestamp",descending: true).limit(20).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.red, size: 10));
                  }
                  List<QueryDocumentSnapshot> data = snapshot.data!.docs;
                  if (searchcontroller.text.isNotEmpty) {
                    data = data.where((doc) => doc["searchTerm"]
                        .toLowerCase()
                        .contains(searchcontroller.text.toLowerCase()))
                        .toList();
                  }
                  if (data.isEmpty) {
                    return Center(
                      child: Text(
                        "No Data Found",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 6.0,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                    ),
                    itemCount:data.length,
                    itemBuilder: (itemBuilder, index) {
                      final product = data[index]["searchTerm"];
                      final searchValue = searchcontroller.text.toLowerCase();
                      final searchIndex = product.toLowerCase().indexOf(searchValue);
                      final searchLength = searchValue.length;
                      final filteredDoc = data[index];
                      return  Card(
                        child: Container(

                            child: InkWell(
                              onTap: (){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>detail(
                                  url: filteredDoc["url"],
                                  productName: filteredDoc["searchTerm"],
                                  productPrice: filteredDoc["price"],
                                phonenumber: filteredDoc["phonenumber"],
                                )));
                              },
                              child: ListTile(
                                leading: InkWell(
                                  onTap: (){

                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.noHeader,
                                      animType: AnimType.scale,
                                      transitionAnimationDuration: Duration(microseconds: 11100),
                                      title: filteredDoc["searchTerm"],
                                      body: InkWell(
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (_)=>animation(
                                                  url:filteredDoc["url"],
                                                  productName:filteredDoc["searchTerm"]))
                                          );

                                        },
                                        child: Hero(
                                            tag: "background",
                                            child: Image.network(filteredDoc["url"], fit: BoxFit.cover)
                                        ),),
                                      btnOkIcon: Icons.info_outline,
                                      btnOkText: "Info",
                                      btnOkOnPress: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (builder)=>detail(
                                                url: filteredDoc["url"],
                                                productName: filteredDoc["searchTerm"],
                                                productPrice: filteredDoc["price"],
                                              phonenumber: filteredDoc["phonenumber"],
                                            ))
                                        );
                                      },
                                    )..show();
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(filteredDoc["url"]),
                                    backgroundColor: Colors.white,
                                    radius: 25,
                                    foregroundColor: Colors.black,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.grey, width: 1),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: RichText(
                                    text: TextSpan(
                                      text: product.substring(0, searchIndex),
                                      style: TextStyle(color: Colors.black, fontSize: 16),
                                      children: [
                                        TextSpan(
                                          text: product.substring(searchIndex, searchIndex + searchLength),
                                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        TextSpan(
                                          text: product.substring(searchIndex + searchLength),
                                          style: TextStyle(color: Colors.black ,fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),),

                                trailing: IconButton(
                                  onPressed: (){
                                  showDialog(context: context, builder: (builder){
return AlertDialog(
  title: Text("Delete"),
  actions: [
    TextButton(onPressed: (){
     Navigator.pop(context);

    }, child: Text("Cancel")),
    TextButton(onPressed: (){
      FirebaseFirestore.instance.collection("search_history").doc(snapshot.data!.docs[index].id).delete();
      Fluttertoast.showToast(
          msg: "Item $product deleted successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      ).then((value) {
        Navigator.pop(context);
      });
    }, child: Text("Delete")),
  ],
);
                                  });
                                    },
                                  icon: Icon(Icons.clear),
                                ),
                              ),
                            ),
                          ),
                      )
                      ;

                    },
                  );
                }),
SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Products",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            SingleChildScrollView(

              child: SizedBox(
                child: StreamBuilder(
                    stream:
                    FirebaseFirestore.instance.collectionGroup("Add_product").snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.red, size: 10));
                      }

                      List<QueryDocumentSnapshot> data = snapshot.data!.docs;
                      if (searchcontroller.text.isNotEmpty) {
                        data = data.where((doc) => doc["product_name"]
                            .toLowerCase()
                            .contains(searchcontroller.text.toLowerCase()))
                            .toList();
                      }
                      if (data.isEmpty) {
                        return Center(
                          child: Text(
                            "No Product Found",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 6.0,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                        ),
                        itemCount:data.length,
                        itemBuilder: (itemBuilder, index) {
                          final product = data[index]["product_name"];
                          final searchValue = searchcontroller.text.toLowerCase();
                          final searchIndex = product.toLowerCase().indexOf(searchValue);
                          final searchLength = searchValue.length;
                          final filteredDoc = data[index];
                            return Card(
                              child: Container(
                                child: InkWell(
                                  onTap: (){
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>detail(
                                      url: filteredDoc["url"],
                                      productName: filteredDoc["product_name"],
                                      productPrice: filteredDoc["product_price"],
                                      phonenumber: filteredDoc["phonenumber"],
                                    )));
                                    final user = FirebaseAuth.instance.currentUser;
                                    if (user != null) {
                                      FirebaseFirestore.instance.collection('search_history').add({
                                        'searchTerm': filteredDoc["product_name"],
                                        "url":filteredDoc["url"],
                                        "price":filteredDoc["product_price"],
                                        'userId': user.uid,
                                        'timestamp': Timestamp.now(),
                                      });
                                    }
                                  },
                                  child: ListTile(
                                    leading:InkWell(
                                      onTap: (){

                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.noHeader,
                                          animType: AnimType.scale,
                                          transitionAnimationDuration: Duration(microseconds: 11100),
                                          title: filteredDoc["product_name"],
                                        body: InkWell(
                                            onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (_)=>animation(url:filteredDoc["url"], productName:filteredDoc["product_name"]))
                                              );
                                            },
                                            child: Hero(
                                                tag: "background",
                                                child: Image.network(filteredDoc["url"], fit: BoxFit.cover)
                                            ),),
                                          btnOkIcon: Icons.info_outline,
                                          btnOkText: "Info",
                                          btnOkOnPress: (){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (builder)=>detail(
                                                    url: filteredDoc["url"],
                                                    productName: filteredDoc["product_name"],
                                                    productPrice: filteredDoc["product_price"],
                                                  phonenumber: filteredDoc["phonenumber"],
                                                ))
                                            );
                                          },
                                        )..show();
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(filteredDoc["url"]),
                                        backgroundColor: Colors.white,
                                        radius: 25,
                                        foregroundColor: Colors.black,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.grey, width: 1),
                                          ),
                                        ),
                                      ),
                                    ),

                                    title: RichText(
                                      text: TextSpan(
                                        text: product.substring(0, searchIndex),
                                        style: TextStyle(color: Colors.black, fontSize: 16),
                                        children: [
                                          TextSpan(
                                            text: product.substring(searchIndex, searchIndex + searchLength),
                                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          TextSpan(
                                            text: product.substring(searchIndex + searchLength),
                                            style: TextStyle(color: Colors.black ,fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                        },
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}