import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:be_food/authentication/first_page.dart';
import 'package:be_food/models/note.dart';
import 'package:be_food/provider/user_provider.dart';
import 'package:be_food/ui_for_customer/chefviewprofile.dart';
import 'package:be_food/ui_for_customer/post_interface.dart';
import 'package:be_food/ui_for_customer/searchbox.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int _currentIndex = 0;
  late PageController _pageController;


  @override
  void initState() {
    updateData();
    _pageController = PageController();
    _startSlideshow();
    // TODO: implement initState
    super.initState();
  }
  void _startSlideshow() {
    Future.delayed(Duration(seconds: 3), () {
      if (_currentIndex < 5) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(_currentIndex,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      _startSlideshow(); // Recursive call to keep the slideshow going
    });
  }

  updateData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    Userdata? userdata = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 13,
                          ),
                          Image.asset(
                            "assets/images/logo.png",
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Be-Food",
                            style: GoogleFonts.abel(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                AwesomeDialog (
                                  context: context,
                                  dialogType: DialogType.noHeader,
                                  headerAnimationLoop: false,
                                  animType: AnimType.bottomSlide,
                                  title: 'Logout',
                                  desc: 'Are you sure want to Logout?',
                                  buttonsTextStyle:
                                  const TextStyle(color: Colors.white),
                                  showCloseIcon: true,
                                  btnCancelOnPress: () {},
                                  btnOkText:  'YES',
                                  btnCancelText: 'NO',
                                  btnOkOnPress: () {

                                    FirebaseAuth.instance.signOut();
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FirstPage()));

                                  },
                                ).show();
                              }, icon: Icon(Icons.logout,color: Colors.white,)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width/1.06,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      onTap: (){
                        Get.to(()=>FoodSearchPage());
                      },
                      decoration: InputDecoration(
                          hintText: "Search for Food",
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical:2.0,horizontal: 2.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(Icons.search,color: Colors.white,)
                      ),
                      style: TextStyle(fontSize: 13,color: Colors.white),
                    ),
                  ),
                ],
              )),
          Positioned(
              top: 140,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Hello ",
                                      style: GoogleFonts.abel(
                                          fontSize: 17, color: Colors.black),
                                    ),
                                    Text(
                                      userdata?.name ?? '',
                                      style: GoogleFonts.abel(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      ",",
                                      style: GoogleFonts.abel(
                                          fontSize: 17, color: Colors.black),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Search and Order!",
                                  style: GoogleFonts.abel(
                                      fontSize: 17, color: Colors.black),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 20,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: userdata?.imageurl != null
                                    ? NetworkImage(userdata!.imageurl!)
                                    : AssetImage("assets/images/file.png")
                                        as ImageProvider,
                              ),
                            ),
                          ],
                        ),




                        SizedBox(height: 20,),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('post').snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Center(child: Text('No data available'));
                            }
                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            }



                            var images = snapshot.data!.docs.map((doc) => doc['imageurl']).toList();

                            return SizedBox(
                              height: 170,
                              width: MediaQuery.of(context).size.width,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13)
                                    ),
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(13),
                                      child: CachedNetworkImage(
                                        imageUrl: images[index],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),










                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "For you",
                          style: GoogleFonts.abel(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('post')
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<Card> clientWidgets = [];
                              if (snapshot.hasData) {
                                final clients =
                                    snapshot.data?.docs.reversed.toList();
                                for (var client in clients!) {
                                  String postId = client.id;
                                  if(client['discount'] =='') {
                                    final clientWidget = Card(
                                      elevation: 10,
                                      color: Colors.grey,
                                      child: GestureDetector(
                                          onTap: () {
                                            Get.to(PostInterface(), arguments: [
                                              client['date']??'',
                                              client['description']??'',
                                              client['imageurl']??'',
                                              client['nameadmin']??'',
                                              client['price']??'',
                                              client['profilepic']??'',
                                              client['time']??'',
                                              client['uid']??'',
                                              client['foodname']??'',
                                              client['adminlocation']??'',
                                              client['likes']??0,
                                              client['rating']??0.0,
                                              postId??'',

                                            ],);
                                            print(postId);
                                          },
                                          child: Container(
                                            height: 130,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .only(
                                                    topLeft: Radius.circular(
                                                        12),
                                                    topRight: Radius.circular(
                                                        12),
                                                  ),
                                                  child: Image(
                                                    height: 80,
                                                    width: 150,
                                                    image: client['imageurl'] !=
                                                        null
                                                        ? NetworkImage(
                                                        client['imageurl']!)
                                                        : AssetImage(
                                                        "assets/images/upload.jpg")
                                                    as ImageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 3, 10, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        client['foodname'],
                                                        style: GoogleFonts.abel(
                                                            fontSize: 10,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors
                                                                .black),
                                                      ),
                                                      Text(
                                                        client['foodtype'],
                                                        style: GoogleFonts.abel(
                                                            fontSize: 10,
                                                            color: Colors
                                                                .black),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            client['price'],
                                                            style:
                                                            GoogleFonts.abel(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            '', //give rating
                                                            style:
                                                            GoogleFonts.abel(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    );

                                    clientWidgets.add(clientWidget);
                                  }
                                }
                              }
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 14, 0, 14),
                                  child: Row(
                                    children: clientWidgets,
                                  ),
                                ),
                              );
                            }),
                        Text(
                          "Special Items",
                          style: GoogleFonts.abel(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('post')
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<Card> clientWidgets = [];
                              if (snapshot.hasData) {
                                final clients =
                                snapshot.data?.docs.reversed.toList();
                                for (var client in clients!) {
                                  if(client['discount'] =='' && client['foodtype']=='Special Item') {
                                    String postId = client.id;
                                    final clientWidget = Card(
                                      elevation: 10,
                                      color: Colors.grey,
                                      child: GestureDetector(
                                          onTap: () {
                                            Get.to(PostInterface(), arguments: [
                                              client['date']??'',
                                              client['description']??'',
                                              client['imageurl']??'',
                                              client['nameadmin']??'',
                                              client['price']??'',
                                              client['profilepic']??'',
                                              client['time']??'',
                                              client['uid']??'',
                                              client['foodname']??'',
                                              client['adminlocation']??'',
                                              client['likes']??0,
                                              client['rating']??0.0,
                                              postId??'',

                                            ],);
                                            print(postId);
                                          },
                                          child: Container(
                                            height: 130,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .only(
                                                    topLeft: Radius.circular(
                                                        12),
                                                    topRight: Radius.circular(
                                                        12),
                                                  ),
                                                  child: Image(
                                                    height: 80,
                                                    width: 150,
                                                    image: client['imageurl'] !=
                                                        null
                                                        ? NetworkImage(
                                                        client['imageurl']!)
                                                        : AssetImage(
                                                        "assets/images/upload.jpg")
                                                    as ImageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 3, 10, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        client['foodname'],
                                                        style: GoogleFonts.abel(
                                                            fontSize: 10,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors
                                                                .black),
                                                      ),
                                                      Text(
                                                        client['foodtype'],
                                                        style: GoogleFonts.abel(
                                                            fontSize: 10,
                                                            color: Colors
                                                                .black),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            client['price'],
                                                            style:
                                                            GoogleFonts.abel(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            '', //give rating
                                                            style:
                                                            GoogleFonts.abel(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    );

                                    clientWidgets.add(clientWidget);
                                  }
                                }
                              }
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(0, 14, 0, 14),
                                  child: Row(
                                    children: clientWidgets,
                                  ),
                                ),
                              );
                            }),
                        Text(
                          "Chefs",
                          style: GoogleFonts.abel(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<Container> clientWidgets = [];
                              if (snapshot.hasData) {
                                final clients =
                                    snapshot.data?.docs.reversed.toList();
                                for (var client in clients!) {
                                  if (client['role'] == "Chef") {
                                    final clientWidget = Container(
                                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                          onTap: () {
                                             Get.to(Chefviewprofile(), arguments: [
                                                client.id??'',
                                               ],);
                                             },
                                            child: CircleAvatar(
                                              radius: 60,
                                              backgroundImage: NetworkImage(
                                                  client['imageurl']),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){},
                                            child: Text(
                                              client['name'],
                                              style: GoogleFonts.abel(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    clientWidgets.add(clientWidget);
                                  }
                                }
                              }
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                                  child: Row(
                                    children: clientWidgets,
                                  ),
                                ),
                              );
                            }),
                        Text(
                          "Offers Available",
                          style: GoogleFonts.abel(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('post')
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<Card> clientWidgets = [];
                              if (snapshot.hasData) {
                                final clients =
                                    snapshot.data?.docs.reversed.toList();
                                for (var client in clients!) {
                                  String postId = client.id;
                                  if(client['discount']!='') {
                                    final clientWidget = Card(
                                      elevation: 10,
                                      color: Colors.grey,
                                      child: GestureDetector(
                                          onTap: () {
                                            Get.to(PostInterface(), arguments: [
                                              client['date']??'',
                                              client['description']??'',
                                              client['imageurl']??'',
                                              client['nameadmin']??'',
                                              client['price']??'',
                                              client['profilepic']??'',
                                              client['time']??'',
                                              client['uid']??'',
                                              client['foodname']??'',
                                              client['adminlocation']??'',
                                              client['likes']??0,
                                              client['rating']??0.0,
                                              postId??'',
                                            ],);
                                          },
                                          child: Container(
                                            height: 130,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .only(
                                                    topLeft: Radius.circular(
                                                        12),
                                                    topRight: Radius.circular(
                                                        12),
                                                  ),
                                                  child: Stack(children: [
                                                    Image(
                                                      height: 80,
                                                      width: 150,
                                                      image: client['imageurl'] !=
                                                          null
                                                          ? NetworkImage(
                                                          client['imageurl']!)
                                                          : AssetImage(
                                                          "assets/images/upload.jpg")
                                                      as ImageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Positioned(
                                                      top: -30,
                                                      right: -30,
                                                      child: Stack(
                                                        children: [
                                                          Lottie.asset(
                                                              "assets/images/Animation.json",
                                                              height: 120,
                                                              width: 120),
                                                          Positioned(
                                                            top: 50,
                                                            left: 45,
                                                            child: Text(
                                                              client['discount'],
                                                              style: GoogleFonts
                                                                  .adamina(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  color: Colors
                                                                      .black
                                                              ),
                                                            ),),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 3, 10, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        client['foodname'],
                                                        style: GoogleFonts.abel(
                                                            fontSize: 10,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors
                                                                .black),
                                                      ),
                                                      Text(
                                                        client['foodtype'],
                                                        style: GoogleFonts.abel(
                                                            fontSize: 10,
                                                            color: Colors
                                                                .black),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            client['price'],
                                                            style:
                                                            GoogleFonts.abel(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            '',
                                                            style:
                                                            GoogleFonts.abel(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    );
                                    clientWidgets.add(clientWidget);
                                  }
                                }
                              }
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 14, 0, 14),
                                  child: Row(
                                    children: clientWidgets,
                                  ),
                                ),
                              );
                            }),
                        Text(
                          "Platter",
                          style: GoogleFonts.abel(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('post')
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<Card> clientWidgets = [];
                              if (snapshot.hasData) {
                                final clients =
                                snapshot.data?.docs.reversed.toList();
                                for (var client in clients!) {
                                  if(client['platter']=='Yes') {
                                    String postId = client.id;
                                    final clientWidget = Card(
                                      elevation: 10,
                                      color: Colors.grey,
                                      child: GestureDetector(
                                          onTap: () {
                                            Get.to(PostInterface(), arguments: [
                                              client['date']??'',
                                              client['description']??'',
                                              client['imageurl']??'',
                                              client['nameadmin']??'',
                                              client['price']??'',
                                              client['profilepic']??'',
                                              client['time']??'',
                                              client['uid']??'',
                                              client['foodname']??'',
                                              client['adminlocation']??'',
                                              client['likes']??0,
                                              client['rating']??0.0,
                                              postId??'',

                                            ],);
                                          },
                                          child: Container(
                                            height: 130,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .only(
                                                    topLeft: Radius.circular(
                                                        12),
                                                    topRight: Radius.circular(
                                                        12),
                                                  ),
                                                  child: Image(
                                                    height: 80,
                                                    width: 150,
                                                    image: client['imageurl'] !=
                                                        null
                                                        ? NetworkImage(
                                                        client['imageurl']!)
                                                        : AssetImage(
                                                        "assets/images/upload.jpg")
                                                    as ImageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 3, 10, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        client['foodname'],
                                                        style: GoogleFonts.abel(
                                                            fontSize: 10,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors
                                                                .black),
                                                      ),
                                                      Text(
                                                        "member: ${client['member']}",
                                                        style: GoogleFonts.abel(
                                                            fontSize: 10,
                                                            color: Colors
                                                                .black),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            client['price'],
                                                            style:
                                                            GoogleFonts.abel(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            '',
                                                            style:
                                                            GoogleFonts.abel(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    );
                                    clientWidgets.add(clientWidget);
                                  }
                                }
                              }
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(0, 14, 0, 14),
                                  child: Row(
                                    children: clientWidgets,
                                  ),
                                ),
                              );
                            }),
                        SizedBox(
                          height: 200,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
