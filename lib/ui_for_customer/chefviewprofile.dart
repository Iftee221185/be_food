import 'package:be_food/ui_for_customer/post_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Chefviewprofile extends StatefulWidget {
  const Chefviewprofile({super.key});

  @override
  State<Chefviewprofile> createState() => _ChefviewprofileState();
}

class _ChefviewprofileState extends State<Chefviewprofile> {
  String uid = '';
  String email = '';
  String experience = '';
  String imageUrl = '';
  String location = '';
  String name = '';
  String number = '';

  // Fetch user data from Firestore based on UID
  Future<void> getUserDataByUid() async {
    try {
      // Fetch user data from the 'users' collection using the provided UID
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users') // The 'users' collection
          .doc(uid) // Using the UID as the document ID
          .get();

      if (documentSnapshot.exists) {
        // Document found
        var data = documentSnapshot.data() as Map<String, dynamic>;

        // Update the state with the fetched data
        setState(() {
          email = data['email'] ?? '';
          experience = data['experience'] ?? '';
          imageUrl = data['imageurl'] ?? '';
          location = data['location'] ?? '';
          name = data['name'] ?? '';
          number = data['number'] ?? '';
        });
      } else {
        print('No user found with UID: $uid');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    final List<dynamic> info = Get.arguments ?? [];
    uid = info[0] ?? '';
    getUserDataByUid(); // Call function to load user data when the screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Stack(
                children: [
                  // Displaying the user's profile image or a default one if imageUrl is null
                  Image(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    image: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : AssetImage("assets/images/upload.jpg") as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 4.5),
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
                      name.toUpperCase(),
                      style: GoogleFonts.abel(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      email,
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
                              location,
                              style: GoogleFonts.abel(fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 8),
                            Lottie.asset(
                              "assets/images/call.json",
                              height: 30,
                              width: 30,
                            ),
                            Text(
                              number,
                              style: GoogleFonts.abel(fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      "Posted",
                      style: GoogleFonts.abel(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    // StreamBuilder to load posts made by the user
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('post')
                          .where('uid', isEqualTo: uid) // Filter posts by the user's UID
                          .snapshots(),
                      builder: (context, snapshot) {
                        List<Card> clientWidgets = [];
                        if (snapshot.hasData) {
                          final clients = snapshot.data?.docs.reversed.toList();
                          for (var client in clients!) {
                            String postId = client.id;
                            if (client['uid'] == uid) {
                              final clientWidget = Card(
                                elevation: 10,
                                color: Colors.grey,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(PostInterface(), arguments: [
                                      client['date'] ?? '',
                                      client['description'] ?? '',
                                      client['imageurl'] ?? '',
                                      client['nameadmin'] ?? '',
                                      client['price'] ?? '',
                                      client['profilepic'] ?? '',
                                      client['time'] ?? '',
                                      client['uid'] ?? '',
                                      client['foodname'] ?? '',
                                      client['adminlocation'] ?? '',
                                      client['likes'] ?? 0,
                                      client['rating'] ?? 0.0,
                                      postId ?? '',
                                    ]);
                                  },
                                  child: Container(
                                    height: 130,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
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
                                            image: client['imageurl'] != null
                                                ? NetworkImage(
                                                client['imageurl']!)
                                                : AssetImage(
                                                "assets/images/upload.jpg") as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 3, 10, 0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                client['foodname'],
                                                style: GoogleFonts.abel(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                client['foodtype'],
                                                style: GoogleFonts.abel(
                                                    fontSize: 10,
                                                    color: Colors.black),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    client['price'],
                                                    style: GoogleFonts.abel(
                                                        fontSize: 10,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    client['rating'].toString(),
                                                    style: GoogleFonts.abel(
                                                        fontSize: 10,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                      },
                    ),
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
