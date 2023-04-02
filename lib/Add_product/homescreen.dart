import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Product_detail/Add_to_cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:page_transition/page_transition.dart';
import '../Categories/Show/Automotive_show.dart';
import '../Categories/Show/Beauty_show.dart';
import '../Categories/Show/Books_show.dart';
import '../Categories/Show/Cloth_show.dart';
import '../Categories/Show/Electronics_show.dart';
import '../Categories/Show/Health_show.dart';
import '../Categories/Show/Home.dart';
import '../Categories/Show/Sports_show.dart';
import '../Categories/Show/search_detail.dart';
import '../Categories/Show/toys_show.dart';
import '../Product_detail/Add_to_favourite.dart';
import '../Product_detail/detail.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'City_filter.dart';
class home_screen extends StatefulWidget {
  const home_screen({Key? key}) : super(key: key);
  @override
  State<home_screen> createState() => _home_screenState();
}
class _home_screenState extends State<home_screen> {
 final searchcontroller=TextEditingController();
 bool isFavorite = false;
 int aclick=0;
 int pclick=0;
 String? _selectedItem;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
      title:StreamBuilder(
          stream: FirebaseFirestore.instance.collection("user3").where("id",isEqualTo:FirebaseAuth.instance.currentUser?.uid).snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            if (!snapshot.hasData) {
              return Container();
            }
            return SizedBox(
              height: 80,
              child: ListView.builder(itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, index){
                    print("Welcome "+snapshot.data!.docs[index]["name"]);
                    return  Container(
                      // for testing purposes
                        child:AnimatedTextKit(
                          animatedTexts: [
                            WavyAnimatedText( "WELCOME "+snapshot.data!.docs[index]["name"].toUpperCase(),
                              textStyle: TextStyle(fontSize: 24.0, color: Colors.white),

                            ),
                            TyperAnimatedText(
                                "WELCOME "+snapshot.data!.docs[index]["name"].toUpperCase(),
                                textStyle: TextStyle(fontSize: 24.0, color: Colors.grey.shade50),
                                speed: Duration(milliseconds: 300)
                            )  ,
                            TypewriterAnimatedText(
                                "WELCOME "+snapshot.data!.docs[index]["name"].toUpperCase(),
                                textStyle: TextStyle(fontSize: 22.0, color: Colors.white),
                                speed: Duration(milliseconds: 300)
                            )  ,
                            FadeAnimatedText(
                                "WELCOME "+snapshot.data!.docs[index]["name"].toUpperCase(),
                                textStyle: TextStyle(fontSize: 22.0, color: Colors.white),
                                fadeInEnd: 0.5,
                                fadeOutBegin: 0.6
                            )  ,

                          ],
                          isRepeatingAnimation: true,
                          repeatForever: true,
                          onTap: (){
                            Fluttertoast.showToast(
                                msg: "WELCOME "+snapshot.data!.docs[index]["name"].toUpperCase(),
                                toastLength: Toast.LENGTH_LONG,
                                fontSize: 16.0

                            );
                          },
                        ));

                  }),
            );
          }),
        backgroundColor: Colors.grey,
      actions: [
        IconButton(onPressed:(){
          Navigator.push(context, MaterialPageRoute(builder: (builder)=>search_detail(
            enableFocusMode: true,
          )));
        } , icon: Icon(Icons.search)),
        IconButton(
tooltip: "favorite",
        onPressed: (){
          Navigator.push(context, PageTransition(
              duration: Duration(milliseconds: 400)
              ,type: PageTransitionType.topToBottom,
              child:favourite()));
        }
        , icon: Icon(Icons.favorite,)),
      ],
      ),

      body:
      SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*.01,
            ),
            ///Image slider
            StreamBuilder(
              stream:  FirebaseFirestore.instance.collection("All_products")
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.red,
                      size: 100,
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xffDA4453), Color(0xff89216B)],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CarouselSlider.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (itemBuilder, index, real) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, PageTransition(
                                    duration: Duration(milliseconds: 600)
                                    ,type: PageTransitionType.rightToLeft,
                                    child:detail(
                                      url: snapshot.data!.docs[index]["url"],
                                      productName: snapshot.data!.docs[index]["product_name"],
                                      productPrice: snapshot.data!.docs[index]["product_price"],
                                      phonenumber:snapshot.data!.docs[index]["phonenumber"],
                                    )));
                              },
                              child: Image.network(
                                snapshot.data!.docs[index]["url"],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.3,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.easeIn,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            ///Products
              Column(
                children: [
                  SizedBox(height: 20,),
                  Text("Popular Catagories",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 25,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF5E9FFF), Color(0xFFB8E7FF)],
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),

                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>cloth_show()));
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/cloth.jpg"),
                                  child: Text("Fashion",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>beauty_show()));
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/beauty.jpg"),
                                child: Text("Beauty",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>books_show()));
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/book.jpg"),
                                  child: Text("Books",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>electronic_show()));
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/electronics.jpg"),
                                  child: Text("Electronics",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>health_show()));
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/health.jpg"),
                                  child: Text("Health",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>toys_show()));
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/toys.jpg"),
                                  child: Text("Toys",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  Text("Catagories",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 25,),
                  SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF5E9FFF), Color(0xFFB8E7FF)],
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){

                                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>cloth_show()));

                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/cloth.jpg"),
                                  child: Text("Fashion",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                            Padding(

                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>beauty_show()));
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/beauty.jpg"),
                                  child: Text("Beauty",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>automotive()));
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/automotive.jpg"),
                                  child: Text("Automotive",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>books_show()));
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/book.jpg"),
                                  child: Text("Books",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>electronic_show()));
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/electronics.jpg"),
                                  child: Text("Electronics",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                            ///
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>health_show()));
                                },
                                child: CircleAvatar(

                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/health.jpg"),
                                  child: Text("Health",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black45),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>kitchen_show()));
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/kitchen.jpg"),
                                  child: Text("Kitchen ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>sports_show()));
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/Sport.jpg"),
                                  child: Text("Sport",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>kitchen_show()));
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage("assets/images/toys.jpg"),
                                  child: Text("Toys",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),


                Text("Items for you",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  DropdownButton<String>(
                    value: _selectedItem,
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value;
                      });
                    },
                    items: [    "Abbottabad",    "Ahmedpur East",    "Alipur",    "Arifwala",    "Attock",    "Badin",    "Bahawalnagar",    "Bahawalpur",    "Bannu",    "Battagram",    "Bhakkar",    "Bhalwal",    "Bhera",    "Chakwal",    "Chaman",    "Charsadda",    "Chichawatni",    "Chiniot",    "Chishtian",    "Chitral",    "Dadu",    "Daska",    "Depalpur",    "Dera Ghazi Khan",    "Dera Ismail Khan",    "Faisalabad",    "Fateh Jang",    "Ghotki",    "Gilgit",    "Gojra",    "Gujranwala",    "Gujrat",    "Hafizabad",    "Haripur",    "Havelian",    "Hyderabad",    "Islamabad",    "Jacobabad",    "Jaranwala",    "Jehanian",    "Jhang",    "Jhelum",    "Jiwani",    "Jhang Sadr",    "Kabirwala",    "Kahror Pakka",    "Kalat",    "Kamalia",    "Kamoke",    "Karachi",    "Karak",    "Kasur",    "Khairpur",    "Khanewal",    "Khanpur",    "Kharian",    "Khushab",    "Kohat",    "Kot Addu",    "Kotri",    "Kunri",    "Lahore",    "Larkana",    "Layyah",    "Liaquat Pur",    "Lodhran",    "Mailsi",    "Mardan",    "Mastung",    "Mian Channu",    "Mianwali",    "Mingora",    "Mirpur Khas",    "Multan",    "Muridke",    "Muzaffargarh",    "Nankana Sahib",    "Narowal",    "Nawabshah"  ].map((String item) {
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
                    dropdownColor: Colors.white,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color:Colors.teal,
                      size: 30,
                    ),
                    elevation: 10,
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 18,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedItem == null) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'Please Select City For Further Process',
                          dialogBackgroundColor: Colors.grey,
                          btnCancelOnPress: () {
                            },
                        )..show();
                      } else {
Navigator.push(context, MaterialPageRoute(builder: (builder)=>
city_filter(
cityname: _selectedItem??"",
)
));
                    }
                      },
                    child: Text("Select City"),
                  ),
                  SizedBox(height: 15,),
                  StreamBuilder(
                      stream:  FirebaseFirestore.instance.collection("All_products").snapshots(),
                      builder:(BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                        if (!snapshot.hasData) {
                          return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 10));
                        }

                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.7),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (itemBuilder,index){
                              return Container(
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),

                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, PageTransition(
                                            duration: Duration(milliseconds: 600)
                                            ,type: PageTransitionType.rightToLeft,
                                            child:detail(
                                              url: snapshot.data!.docs[index]["url"],
                                              productName: snapshot.data!.docs[index]["product_name"],
                                              productPrice: snapshot.data!.docs[index]["product_price"],
                                              phonenumber:snapshot.data!.docs[index]["phonenumber"],
                                            )));
setState(() {
  pclick++;
});
                                        FirebaseFirestore.instance
                                            .collection('pclick')
                                            .where('imageurl', isEqualTo: snapshot.data!.docs[index]['url'])
                                            .get()
                                            .then((querySnapshot) {
                                          if (querySnapshot.docs.isNotEmpty){
                                            // If a document with the same imageurl exists, update its pclick field
                                            String docId = querySnapshot.docs.first.id;
                                            int currentPclick = int.parse(querySnapshot.docs.first['pclick'].toString());
                                            int updatedPclick = currentPclick + 1;
                                            FirebaseFirestore.instance
                                                .collection('pclick')
                                                .doc(docId)
                                                .update({'pclick': updatedPclick.toString()});
                                          } else {
                                            // If no document with the same imageurl exists, add a new document
                                            FirebaseFirestore.instance
                                                .collection('pclick')
                                                .add({
                                              'imageurl': snapshot.data!.docs[index]['url'],
                                              'pclick': '1',
                                              "uid": snapshot.data!.docs[index]['id'],
                                              "name":snapshot.data!.docs[index]["product_name"],
                                            });
                                          }
                                        });



                                      },
                                      child: Card(
                                        elevation:5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(9.0),
                                              child: Image.network(snapshot.data!.docs[index]["url"],width: MediaQuery.of(context).size.width*.49,height:MediaQuery.of(context).size.height*.17 ,),
                                            ),
                                            SizedBox(height: 7,),
                                            Text(
                                              snapshot.data!.docs[index]["product_name"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Rs "+snapshot.data!.docs[index]["product_price"],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                IconButton(onPressed: () async{
                                                  final favoriteItems = await FirebaseFirestore.instance.collection("favorite").where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
                                                  for (var doc in favoriteItems.docs) {
                                                    if (doc["url"] == snapshot.data!.docs[index]["url"]) {
                                                      Fluttertoast.showToast(
                                                        msg: "Item already added to favorites",
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.BOTTOM,
                                                          timeInSecForIosWeb: 5,
                                                          backgroundColor: Colors.redAccent,
                                                          textColor: Colors.white,
                                                          fontSize: 16.0
                                                      );
                                                      return;
                                                    }
                                                  }
    FirebaseFirestore.instance.collection("favorite").add({
    "Date": DateTime.now(),
    "url": snapshot.data!.docs[index]["url"],
    "price": snapshot.data!.docs[index]["product_price"],
    "name": snapshot.data!.docs[index]["product_name"],
    "id": FirebaseAuth.instance.currentUser!.uid,
      "phonenumber":snapshot.data!.docs[index]["phonenumber"],
      "isFavorite": true,
    }).then((value) {
  Fluttertoast.showToast(
      msg: "Item added to favourite successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0
  );
});
                                                  setState(() {
                                                    isFavorite = true; // Update the flag
aclick++;
                                                  });
                                                  FirebaseFirestore.instance
                                                      .collection('aclick')
                                                      .where('imageurl', isEqualTo: snapshot.data!.docs[index]['url'])
                                                      .get()
                                                      .then((querySnapshot) {
                                                    if (querySnapshot.docs.isNotEmpty) {
                                                      // If a document with the same imageurl exists, update its pclick field
                                                      String docId = querySnapshot.docs.first.id;
                                                      int currentPclick = int.parse(querySnapshot.docs.first['aclick'].toString());
                                                      int updatedPclick = currentPclick + 1;
                                                      FirebaseFirestore.instance
                                                          .collection('aclick')
                                                          .doc(docId)
                                                          .update({'aclick': updatedPclick.toString()});
                                                    } else {
                                                      // If no document with the same imageurl exists, add a new document
                                                      FirebaseFirestore.instance
                                                          .collection('aclick')
                                                          .add({
                                                        'imageurl': snapshot.data!.docs[index]['url'],
                                                        'aclick': '1',
                                                      });
                                                    }
                                                  });

                                                },
                                                  icon: Icon(Icons.add_circle, color: Colors.redAccent),
                                                )                  ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),


                              );
                            },
                          ),
                        );
                      }
                  ),
                  SizedBox(height: 15,),
                  ///Clothing and fashion
                  Text("Clothing and Fashion",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Add_product").doc("product1").collection("Add_product").snapshots(),
                      builder:(BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                        if (!snapshot.hasData) {
                          return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 10));
                        }
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.7),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (itemBuilder,index){
                              return Container(
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),

                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, PageTransition(
                                        duration: Duration(milliseconds: 600)
                                        ,type: PageTransitionType.rightToLeft,
                                        child:detail(
                                          url: snapshot.data!.docs[index]["url"],
                                          productName: snapshot.data!.docs[index]["product_name"],
                                          productPrice: snapshot.data!.docs[index]["product_price"],
                                          phonenumber:snapshot.data!.docs[index]["phonenumber"],
                                        )));

                                  },
                                  child: Card(
                                    elevation:5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Image.network(snapshot.data!.docs[index]["url"],width: MediaQuery.of(context).size.width*.49,height:MediaQuery.of(context).size.height*.17 ,),
                                        ),
                                        SizedBox(height: 7,),
                                        Text(
                                          snapshot.data!.docs[index]["product_name"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children:[
                                            Text(
                                              "Rs "+snapshot.data!.docs[index]["product_price"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(onPressed: () async{
                                              final favoriteItems = await FirebaseFirestore.instance.collection("favorite").where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
                                              for (var doc in favoriteItems.docs) {
                                                if (doc["url"] == snapshot.data!.docs[index]["url"]) {
                                                  Fluttertoast.showToast(
                                                      msg: "Item already added to favorites",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 5,
                                                      backgroundColor: Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  return;
                                                }
                                              }
                                              FirebaseFirestore.instance.collection("favorite").add({
                                                "Date": DateTime.now(),
                                                "url": snapshot.data!.docs[index]["url"],
                                                "price": snapshot.data!.docs[index]["product_price"],
                                                "name": snapshot.data!.docs[index]["product_name"],
                                                "phonenumber":snapshot.data!.docs[index]["phonenumber"],
                                                "id": FirebaseAuth.instance.currentUser!.uid,
                                                "isFavorite": true,
                                              }).then((value) {
                                                Fluttertoast.showToast(
                                                    msg: "Item added to favourite successfully",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 5,
                                                    backgroundColor: Colors.black87,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0
                                                );
                                              });

                                            },
                                              icon: Icon(Icons.add_circle, color: Colors.redAccent),
                                            )                  ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              );
                            },
                          ),
                        );
                      }
                  ),
                  SizedBox(height: 15,),
                  ///Beauty
                  Text("Beauty and Personal care",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Add_product").doc("product3").collection("Add_product").snapshots(),
                      builder:(BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                        if (!snapshot.hasData) {
                          return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 10));
                        }
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.7),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (itemBuilder,index){
                              return Container(
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),

                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, PageTransition(
                                        duration: Duration(milliseconds: 600)
                                        ,type: PageTransitionType.rightToLeft,
                                        child:detail(
                                          url: snapshot.data!.docs[index]["url"],
                                          productName: snapshot.data!.docs[index]["product_name"],
                                          productPrice: snapshot.data!.docs[index]["product_price"],
                                          phonenumber:snapshot.data!.docs[index]["phonenumber"],
                                        )));

                                  },
                                  child: Card(
                                    elevation:5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Image.network(snapshot.data!.docs[index]["url"],width: MediaQuery.of(context).size.width*.49,height:MediaQuery.of(context).size.height*.17 ,),
                                        ),
                                        SizedBox(height: 7,),
                                        Text(
                                          snapshot.data!.docs[index]["product_name"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children:[
                                            Text(
                                              "Rs "+snapshot.data!.docs[index]["product_price"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(onPressed: () async{
                                              final favoriteItems = await FirebaseFirestore.instance.collection("favorite").where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
                                              for (var doc in favoriteItems.docs) {
                                                if (doc["url"] == snapshot.data!.docs[index]["url"]) {
                                                  Fluttertoast.showToast(
                                                      msg: "Item already added to favorites",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 5,
                                                      backgroundColor: Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  return;
                                                }
                                              }
                                              FirebaseFirestore.instance.collection("favorite").add({
                                                "Date": DateTime.now(),
                                                "url": snapshot.data!.docs[index]["url"],
                                                "price": snapshot.data!.docs[index]["product_price"],
                                                "name": snapshot.data!.docs[index]["product_name"],
                                                "phonenumber":snapshot.data!.docs[index]["phonenumber"],
                                                "id": FirebaseAuth.instance.currentUser!.uid,
                                                "isFavorite": true,
                                              }).then((value) {
                                                Fluttertoast.showToast(
                                                    msg: "Item added to favourite successfully",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 5,
                                                    backgroundColor: Colors.black87,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0
                                                );
                                              });

                                            },
                                              icon: Icon(Icons.add_circle, color: Colors.redAccent),
                                            )                  ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              );
                            },
                          ),
                        );
                      }
                  ),
                  SizedBox(height: 15,),
                  ///Books
                  Text("Books and Media",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Add_product").doc("product4").collection("Add_product").snapshots(),
                      builder:(BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                        if (!snapshot.hasData) {
                          return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 10));
                        }
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.7),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (itemBuilder,index){
                              return Container(
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),

                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, PageTransition(
                                        duration: Duration(milliseconds: 600)
                                        ,type: PageTransitionType.rightToLeft,
                                        child:detail(
                                          url: snapshot.data!.docs[index]["url"],
                                          productName: snapshot.data!.docs[index]["product_name"],
                                          productPrice: snapshot.data!.docs[index]["product_price"],
                                          phonenumber:snapshot.data!.docs[index]["phonenumber"],
                                        )));

                                  },
                                  child: Card(
                                    elevation:5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Image.network(snapshot.data!.docs[index]["url"],width: MediaQuery.of(context).size.width*.49,height:MediaQuery.of(context).size.height*.17 ,),
                                        ),
                                        SizedBox(height: 7,),
                                        Text(
                                          snapshot.data!.docs[index]["product_name"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children:[
                                            Text(
                                              "Rs "+snapshot.data!.docs[index]["product_price"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(onPressed: () async{
                                              final favoriteItems = await FirebaseFirestore.instance.collection("favorite").where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
                                              for (var doc in favoriteItems.docs) {
                                                if (doc["url"] == snapshot.data!.docs[index]["url"]) {
                                                  Fluttertoast.showToast(
                                                      msg: "Item already added to favorites",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 5,
                                                      backgroundColor: Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  return;
                                                }
                                              }
                                              FirebaseFirestore.instance.collection("favorite").add({
                                                "Date": DateTime.now(),
                                                "url": snapshot.data!.docs[index]["url"],
                                                "price": snapshot.data!.docs[index]["product_price"],
                                                "name": snapshot.data!.docs[index]["product_name"],
                                                "phonenumber":snapshot.data!.docs[index]["phonenumber"],
                                                "id": FirebaseAuth.instance.currentUser!.uid,
                                                "isFavorite": true,
                                              }).then((value) {
                                                Fluttertoast.showToast(
                                                    msg: "Item added to favourite successfully",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 5,
                                                    backgroundColor: Colors.black87,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0
                                                );
                                              });

                                            },
                                              icon: Icon(Icons.add_circle, color: Colors.redAccent),
                                            )                  ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              );
                            },
                          ),
                        );
                      }
                  ),
                  SizedBox(height: 15,),
                  ///Automotive
                  Text("Automotive",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Add_product").doc("product2").collection("Add_product").snapshots(),
                      builder:(BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                        if (!snapshot.hasData) {
                          return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 10));
                        }
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.7),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (itemBuilder,index){
                              return Container(
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),

                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, PageTransition(
                                        duration: Duration(milliseconds: 600)
                                        ,type: PageTransitionType.rightToLeft,
                                        child:detail(
                                          url: snapshot.data!.docs[index]["url"],
                                          productName: snapshot.data!.docs[index]["product_name"],
                                          productPrice: snapshot.data!.docs[index]["product_price"],
                                          phonenumber:snapshot.data!.docs[index]["phonenumber"],
                                        )));

                                  },
                                  child: Card(
                                    elevation:5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Image.network(snapshot.data!.docs[index]["url"],width: MediaQuery.of(context).size.width*.49,height:MediaQuery.of(context).size.height*.17 ,),
                                        ),
                                        SizedBox(height: 7,),
                                        Text(
                                          snapshot.data!.docs[index]["product_name"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children:[
                                            Text(
                                              "Rs "+snapshot.data!.docs[index]["product_price"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(onPressed: () async{
                                              final favoriteItems = await FirebaseFirestore.instance.collection("favorite").where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
                                              for (var doc in favoriteItems.docs) {
                                                if (doc["url"] == snapshot.data!.docs[index]["url"]) {
                                                  Fluttertoast.showToast(
                                                      msg: "Item already added to favorites",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 5,
                                                      backgroundColor: Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  return;
                                                }
                                              }
                                              FirebaseFirestore.instance.collection("favorite").add({
                                                "Date": DateTime.now(),
                                                "url": snapshot.data!.docs[index]["url"],
                                                "price": snapshot.data!.docs[index]["product_price"],
                                                "name": snapshot.data!.docs[index]["product_name"],
                                                "phonenumber":snapshot.data!.docs[index]["phonenumber"],
                                                "id": FirebaseAuth.instance.currentUser!.uid,
                                                "isFavorite": true,
                                              }).then((value) {
                                                Fluttertoast.showToast(
                                                    msg: "Item added to favourite successfully",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 5,
                                                    backgroundColor: Colors.black87,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0
                                                );
                                              });

                                            },
                                              icon: Icon(Icons.add_circle, color: Colors.redAccent),
                                            )                  ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              );
                            },
                          ),
                        );
                      }
                  ),
                  SizedBox(height: 15,),
                  ///Electronics
                  Text("Electronics",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Add_product").doc("product5").collection("Add_product").snapshots(),
                      builder:(BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                        if (!snapshot.hasData) {
                          return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 10));
                        }
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.7),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (itemBuilder,index){
                              return Container(
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),

                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, PageTransition(
                                        duration: Duration(milliseconds: 600)
                                        ,type: PageTransitionType.rightToLeft,
                                        child:detail(
                                          url: snapshot.data!.docs[index]["url"],
                                          productName: snapshot.data!.docs[index]["product_name"],
                                          productPrice: snapshot.data!.docs[index]["product_price"],
                                          phonenumber:snapshot.data!.docs[index]["phonenumber"],
                                        )));

                                  },
                                  child: Card(
                                    elevation:5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Image.network(snapshot.data!.docs[index]["url"],width: MediaQuery.of(context).size.width*.49,height:MediaQuery.of(context).size.height*.17 ,),
                                        ),
                                        SizedBox(height: 7,),
                                        Text(
                                          snapshot.data!.docs[index]["product_name"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children:[
                                            Text(
                                              "Rs "+snapshot.data!.docs[index]["product_price"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(onPressed: () async{
                                              final favoriteItems = await FirebaseFirestore.instance.collection("favorite").where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
                                              for (var doc in favoriteItems.docs) {
                                                if (doc["url"] == snapshot.data!.docs[index]["url"]) {
                                                  Fluttertoast.showToast(
                                                      msg: "Item already added to favorites",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 5,
                                                      backgroundColor: Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  return;
                                                }
                                              }
                                              FirebaseFirestore.instance.collection("favorite").add({
                                                "Date": DateTime.now(),
                                                "url": snapshot.data!.docs[index]["url"],
                                                "price": snapshot.data!.docs[index]["product_price"],
                                                "name": snapshot.data!.docs[index]["product_name"],
                                                "phonenumber":snapshot.data!.docs[index]["phonenumber"],
                                                "id": FirebaseAuth.instance.currentUser!.uid,
                                                "isFavorite": true,
                                              }).then((value) {
                                                Fluttertoast.showToast(
                                                    msg: "Item added to favourite successfully",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 5,
                                                    backgroundColor: Colors.black87,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0
                                                );
                                              });

                                            },
                                              icon: Icon(Icons.add_circle, color: Colors.redAccent),
                                            )                  ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              );
                            },
                          ),
                        );
                      }
                  ),
                  SizedBox(height: 15,),
                  ///Health
                  Text("Health and Wellness",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Add_product").doc("product6").collection("Add_product").snapshots(),
                      builder:(BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                        if (!snapshot.hasData) {
                          return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 10));
                        }
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.7),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (itemBuilder,index){
                              return Container(
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),

                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, PageTransition(
                                        duration: Duration(milliseconds: 600)
                                        ,type: PageTransitionType.rightToLeft,
                                        child:detail(
                                          url: snapshot.data!.docs[index]["url"],
                                          productName: snapshot.data!.docs[index]["product_name"],
                                          productPrice: snapshot.data!.docs[index]["product_price"],
                                          phonenumber:snapshot.data!.docs[index]["phonenumber"],
                                        )));

                                  },
                                  child: Card(
                                    elevation:5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Image.network(snapshot.data!.docs[index]["url"],width: MediaQuery.of(context).size.width*.49,height:MediaQuery.of(context).size.height*.17 ,),
                                        ),
                                        SizedBox(height: 7,),
                                        Text(
                                          snapshot.data!.docs[index]["product_name"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children:[
                                            Text(
                                              "Rs "+snapshot.data!.docs[index]["product_price"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(onPressed: () async{
                                              final favoriteItems = await FirebaseFirestore.instance.collection("favorite").where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
                                              for (var doc in favoriteItems.docs) {
                                                if (doc["url"] == snapshot.data!.docs[index]["url"]) {
                                                  Fluttertoast.showToast(
                                                      msg: "Item already added to favorites",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 5,
                                                      backgroundColor: Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  return;
                                                }
                                              }
                                              FirebaseFirestore.instance.collection("favorite").add({
                                                "Date": DateTime.now(),
                                                "url": snapshot.data!.docs[index]["url"],
                                                "price": snapshot.data!.docs[index]["product_price"],
                                                "name": snapshot.data!.docs[index]["product_name"],
                                                "phonenumber":snapshot.data!.docs[index]["phonenumber"],
                                                "id": FirebaseAuth.instance.currentUser!.uid,
                                                "isFavorite": true,
                                              }).then((value) {
                                                Fluttertoast.showToast(
                                                    msg: "Item added to favourite successfully",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 5,
                                                    backgroundColor: Colors.black87,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0
                                                );
                                              });

                                            },
                                              icon: Icon(Icons.add_circle, color: Colors.redAccent),
                                            )                  ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              );
                            },
                          ),
                        );
                      }
                  ),
                  SizedBox(height: 15,),
                  ///Kitchen
                  Text("Home and Kitchen",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Add_product").doc("product7").collection("Add_product").snapshots(),
                      builder:(BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                        if (!snapshot.hasData) {
                          return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 10));
                        }
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.7),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (itemBuilder,index){
                              return Container(
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),

                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, PageTransition(
                                        duration: Duration(milliseconds: 600)
                                        ,type: PageTransitionType.rightToLeft,
                                        child:detail(
                                          url: snapshot.data!.docs[index]["url"],
                                          productName: snapshot.data!.docs[index]["product_name"],
                                          productPrice: snapshot.data!.docs[index]["product_price"],
                                          phonenumber:snapshot.data!.docs[index]["phonenumber"],
                                        )));

                                  },
                                  child: Card(
                                    elevation:5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Image.network(snapshot.data!.docs[index]["url"],width: MediaQuery.of(context).size.width*.49,height:MediaQuery.of(context).size.height*.17 ,),
                                        ),
                                        SizedBox(height: 7,),
                                        Text(
                                          snapshot.data!.docs[index]["product_name"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children:[
                                            Text(
                                              "Rs "+snapshot.data!.docs[index]["product_price"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(onPressed: () async{
                                              final favoriteItems = await FirebaseFirestore.instance.collection("favorite").where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
                                              for (var doc in favoriteItems.docs) {
                                                if (doc["url"] == snapshot.data!.docs[index]["url"]) {
                                                  Fluttertoast.showToast(
                                                      msg: "Item already added to favorites",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 5,
                                                      backgroundColor: Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  return;
                                                }
                                              }
                                              FirebaseFirestore.instance.collection("favorite").add({
                                                "Date": DateTime.now(),
                                                "url": snapshot.data!.docs[index]["url"],
                                                "price": snapshot.data!.docs[index]["product_price"],
                                                "name": snapshot.data!.docs[index]["product_name"],
                                                "id": FirebaseAuth.instance.currentUser!.uid,
                                                "phonenumber":snapshot.data!.docs[index]["phonenumber"],
                                                "isFavorite": true,
                                              }).then((value) {
                                                Fluttertoast.showToast(
                                                    msg: "Item added to favourite successfully",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 5,
                                                    backgroundColor: Colors.black87,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0
                                                );
                                              });

                                            },
                                              icon: Icon(Icons.add_circle, color: Colors.redAccent),
                                            )                  ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              );
                            },
                          ),
                        );
                      }
                  ),
                  SizedBox(height: 15,),
                  ///Sports
                  Text("Sports",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Add_product").doc("product8").collection("Add_product").snapshots(),
                      builder:(BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                        if (!snapshot.hasData) {
                          return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 10));
                        }
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.7),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (itemBuilder,index){
                              return Container(
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),

                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, PageTransition(
                                        duration: Duration(milliseconds: 600)
                                        ,type: PageTransitionType.rightToLeft,
                                        child:detail(
                                          url: snapshot.data!.docs[index]["url"],
                                          productName: snapshot.data!.docs[index]["product_name"],
                                          productPrice: snapshot.data!.docs[index]["product_price"],
                                          phonenumber:snapshot.data!.docs[index]["phonenumber"],
                                        )));

                                  },
                                  child: Card(
                                    elevation:5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Image.network(snapshot.data!.docs[index]["url"],width: MediaQuery.of(context).size.width*.49,height:MediaQuery.of(context).size.height*.17 ,),
                                        ),
                                        SizedBox(height: 7,),
                                        Text(
                                          snapshot.data!.docs[index]["product_name"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children:[
                                            Text(
                                              "Rs "+snapshot.data!.docs[index]["product_price"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(onPressed: () async{
                                              final favoriteItems = await FirebaseFirestore.instance.collection("favorite").where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
                                              for (var doc in favoriteItems.docs) {
                                                if (doc["url"] == snapshot.data!.docs[index]["url"]) {
                                                  Fluttertoast.showToast(
                                                      msg: "Item already added to favorites",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 5,
                                                      backgroundColor: Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  return;
                                                }
                                              }
                                              FirebaseFirestore.instance.collection("favorite").add({
                                                "Date": DateTime.now(),
                                                "url": snapshot.data!.docs[index]["url"],
                                                "price": snapshot.data!.docs[index]["product_price"],
                                                "name": snapshot.data!.docs[index]["product_name"],
                                                "phonenumber":snapshot.data!.docs[index]["phonenumber"],
                                                "id": FirebaseAuth.instance.currentUser!.uid,
                                                "isFavorite": true,
                                              }).then((value) {
                                                Fluttertoast.showToast(
                                                    msg: "Item added to favourite successfully",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 5,
                                                    backgroundColor: Colors.black87,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0
                                                );
                                              });

                                            },
                                              icon: Icon(Icons.add_circle, color: Colors.redAccent),
                                            )                  ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              );
                            },
                          ),
                        );
                      }
                  ),
                  ///toys
                  Text("Toys and Games",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Add_product").doc("product9").collection("Add_product").snapshots(),
                      builder:(BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                        if (!snapshot.hasData) {
                          return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 10));
                        }
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.7),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (itemBuilder,index){
                              return Container(
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),

                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, PageTransition(
                                        duration: Duration(milliseconds: 600)
                                        ,type: PageTransitionType.rightToLeft,
                                        child:detail(
                                          url: snapshot.data!.docs[index]["url"],
                                          productName: snapshot.data!.docs[index]["product_name"],
                                          productPrice: snapshot.data!.docs[index]["product_price"],
                                          phonenumber:snapshot.data!.docs[index]["phonenumber"],
                                        )));

                                  },
                                  child: Card(
                                    elevation:5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Image.network(snapshot.data!.docs[index]["url"],width: MediaQuery.of(context).size.width*.49,height:MediaQuery.of(context).size.height*.17 ,),
                                        ),
                                        SizedBox(height: 7,),
                                        Text(
                                          snapshot.data!.docs[index]["product_name"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children:[
                                            Text(
                                              "Rs "+snapshot.data!.docs[index]["product_price"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(onPressed: () async{
                                              final favoriteItems = await FirebaseFirestore.instance.collection("favorite").where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
                                              for (var doc in favoriteItems.docs) {
                                                if (doc["url"] == snapshot.data!.docs[index]["url"]) {
                                                  Fluttertoast.showToast(
                                                      msg: "Item already added to favorites",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 5,
                                                      backgroundColor: Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  return;
                                                }
                                              }
                                              FirebaseFirestore.instance.collection("favorite").add({
                                                "Date": DateTime.now(),
                                                "url": snapshot.data!.docs[index]["url"],
                                                "price": snapshot.data!.docs[index]["product_price"],
                                                "name": snapshot.data!.docs[index]["product_name"],
                                                "phonenumber":snapshot.data!.docs[index]["phonenumber"],
                                                "id": FirebaseAuth.instance.currentUser!.uid,
                                                "isFavorite": true,
                                              }).then((value) {
                                                Fluttertoast.showToast(
                                                    msg: "Item added to favourite successfully",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 5,
                                                    backgroundColor: Colors.black87,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0
                                                );
                                              });

                                            },
                                              icon: Icon(Icons.add_circle, color: Colors.redAccent),
                                            )                  ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              );
                            },
                          ),
                        );
                      }
                  ),
                  SizedBox(height: 15,),
                ],
              ),
          ],
        ),
      )

    );
  }
}
