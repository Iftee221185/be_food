import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:be_food/authentication/first_page.dart';
import 'package:be_food/models/note.dart';
import 'package:be_food/provider/user_provider.dart';
import 'package:be_food/ui_for_customer/dataupdate.dart';
import 'package:be_food/ui_for_customer/post_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  @override
  void initState() {
    updateData();
    // TODO: implement initState
    super.initState();
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
          Column(
            children: [
              Stack(
                children: [
                  Image(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    image: userdata?.imageurl != null
                        ? NetworkImage(userdata!.imageurl!)
                        : AssetImage("assets/images/upload.jpg")
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                      top: 30,
                      right: 20,
                      child: IconButton(
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
                              btnOkText: 'YES',
                              btnCancelText: 'NO',
                              btnOkOnPress: () {

                                FirebaseAuth.instance.signOut();
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FirstPage()));

                              },
                            ).show();
                          }, icon: Icon(Icons.logout,color: Colors.yellow,))),
                  Positioned(
                      top: 30,
                      left: 20,
                      child: IconButton(
                          onPressed: () async {
                             Get.to(Dataupdate(),arguments: userdata!.uid!);
                          }, icon: Icon(Icons.settings,color: Colors.yellow,)))
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 4.5,)
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height / 1.9,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      (userdata!.name!).toUpperCase(),
                      style: GoogleFonts.abel(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      userdata!.email!,
                      style: GoogleFonts.abel(
                          fontSize: 17,
                          color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Lottie.asset(
                              "assets/images/location.json",
                              height: 45,
                              width: 45,
                            ),
                            Text(
                              userdata!.location!,
                              style:
                              GoogleFonts.abel(fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 8,),
                            Lottie.asset(
                              "assets/images/call.json",
                              height: 30,
                              width: 30,
                            ),
                            Text(
                              userdata!.number!,
                              style:
                              GoogleFonts.abel(fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),

                    if(userdata.role=='Chef')...[
                      Text(
                        "Posted",
                        style: GoogleFonts.abel(
                            fontSize: 30,
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
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12),
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
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    client['foodtype'],
                                                    style: GoogleFonts.abel(
                                                        fontSize: 10,
                                                        color: Colors.black),
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
                                                        client['rating'].toString(),
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
                    ],

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
