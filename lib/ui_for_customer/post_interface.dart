import 'dart:convert';
import 'package:be_food/ui_for_customer/server_key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:be_food/ui_for_customer/server_key.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:url_launcher/url_launcher.dart';


class PostInterface extends StatefulWidget {
  const PostInterface({super.key});

  @override
  State<PostInterface> createState() => _PostInterfaceState();
}

class _PostInterfaceState extends State<PostInterface> {
// Send push notifications to multiple tokens

  String postid='';
  late String date='';
  late String description ='' ;
  late String postimg ='';
  late String chefname ='' ;
  late String price ='';
  late String chefpic ='';
  late String time = '';
  late String chefId = '';
  late String foodname ='';
  late String cheflocation ='' ;
  late int likes = 0;
  late double rating= 0.0;
  String? number;

  double value=0.0;

  bool isLiked = false; // To track if the post is liked or not
  int likeCount = 0; // To track the current number of likes

  Future<void> makePhoneCall(String phoneNumber) async {
    Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text('Could not launch phone call to $phoneNumber'),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
      );
    }
  }
  // Function to update the like status in Firestore
  // Function to update the like status in Firestore (both increment and decrement)
  Future<void> _updateLikes() async {
    try {
      // Reference to the Firestore document for the current post
      DocumentReference postRef = FirebaseFirestore.instance.collection('post').doc(postid);

      // Fetch the current document snapshot
      DocumentSnapshot docSnap = await postRef.get();

      if (docSnap.exists) {
        // Fetch the current likes count from the document
        int currentLikes = docSnap['likes'] ?? 0;

        int newLikes;
        if (isLiked) {
          // If it's already liked, decrease the like count (unlike)
          newLikes = currentLikes - 1;
          likeCount=0;
        } else {
          // If it's not liked, increase the like count (like)
          newLikes = currentLikes + 1;

        }
        print(newLikes);
        // Ensure likes doesn't go negative
        newLikes = newLikes < 0 ? 0 : newLikes;

        // Update the Firestore document with the new likes count
        await postRef.update({
          'likes': newLikes,
        });

        // Update the UI by setting the new likes count and isLiked status
        setState(() {
          likes = newLikes;
          isLiked = !isLiked; // Toggle the like status
        });

        print("Likes updated successfully! New likes count: $newLikes");
      } else {
        print("No post found with the provided postID.");
      }
    } catch (e) {
      print("Error updating likes: $e");
    }
  }




  Future<void> getPhoneNumberByChefId() async {
    try {
      // Get the document reference using the chefID (document ID)
      DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(chefId);

      // Fetch the document snapshot
      DocumentSnapshot docSnap = await docRef.get();

      if (docSnap.exists) {
        // If the document exists, get the phone number from the document
        var phoneNumber = docSnap['number'];
        setState(() {
          number=phoneNumber;
        });
        print("Phone Number: $phoneNumber");
        // You can return or display the phone number as needed
      } else {
        print("No chef found with the provided chefID.");
      }
    } catch (e) {
      print("Error getting phone number: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final List<dynamic> info = Get.arguments;
    date = info[0];
    description = info[1];
    postimg = info[2];
    chefname = info[3];
    price = info[4];
    chefpic = info[5];
    time = info[6];
    chefId = info[7];
    foodname = info[8];
    cheflocation = info[9];
    int likescount = info[10];
    rating= info[11];
    postid=info[12];




    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Stack(
                children: [
                  Image(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    image: postimg != null
                        ? NetworkImage(postimg!)
                        : AssetImage("assets/images/upload.jpg")
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                      top: 45,
                      right: 30,
                      child: LikeButton(
                        isLiked: isLiked, // Initial like status// Initial like status
                       // likeCount: likeCount, // Initial like count
                        onTap: (isLiked) async {
                          await _updateLikes();
                          // Update the likes in Firestore
                          return !isLiked; // Return the new like status for the UI update
                        },
                      )
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
              )
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height / 2.3,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              foodname,
                              style: GoogleFonts.abel(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            // RatingStars(
                            //   value: value,
                            //   onValueChanged: (v) {
                            //     setState(() {
                            //       value = v;
                            //     });
                            //   },
                            //   starBuilder: (index, color) => Icon(
                            //     Icons.star,
                            //     color: color,
                            //   ),
                            //   starCount: 5,
                            //   starSize: 20,
                            //   valueLabelColor: const Color(0xff9b9b9b),
                            //   valueLabelTextStyle: const TextStyle(
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.w400,
                            //       fontStyle: FontStyle.normal,
                            //       fontSize: 12.0),
                            //   valueLabelRadius: 10,
                            //   maxValue: 5,
                            //   starSpacing: 2,
                            //   maxValueVisibility: true,
                            //   valueLabelVisibility: true,
                            //   animationDuration: Duration(milliseconds: 1000),
                            //   valueLabelPadding:
                            //   const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                            //   valueLabelMargin: const EdgeInsets.only(right: 8),
                            //   starOffColor: const Color(0xffe7e8ea),
                            //   starColor: Colors.yellow,
                            // ),
                          ],
                        ),
                        Text(
                          "${likes.toString()} likes",
                          style: GoogleFonts.abel(
                              fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                    Text(
                      description,
                      style:
                          GoogleFonts.abel(fontSize: 15, color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Lottie.asset(
                          "assets/images/Main.json",
                          height: 40,
                          width: 40,
                        ),
                        Text(
                          price,
                          style: GoogleFonts.abel(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Chef:",
                      style:
                          GoogleFonts.abel(fontSize: 20, color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          chefname,
                          style: GoogleFonts.abel(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 20,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundImage: chefpic != null
                                ? NetworkImage(chefpic!)
                                : AssetImage("assets/images/file.png")
                                    as ImageProvider,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Lottie.asset(
                          "assets/images/location.json",
                          height: 40,
                          width: 40,
                        ),
                        Text(
                          cheflocation,
                          style:
                          GoogleFonts.abel(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 9,),
                        Lottie.asset(
                          "assets/images/time.json",
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(width: 5,),
                        Text(
                          time,
                          style:
                          GoogleFonts.abel(fontSize: 13, color: Colors.black),
                        ),
                        SizedBox(width: 6,),
                        Text(
                          date,
                          style:
                          GoogleFonts.abel(fontSize: 13, color: Colors.black),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,

            child: GestureDetector(
              onTap: () async{
                await getPhoneNumberByChefId();
                makePhoneCall(number!);
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                height: 50,
                width: MediaQuery.of(context).size.width / 1.06,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red,
                ),
                child: Center(
                  child: Text(
                    "Call for Order",
                    style: GoogleFonts.abel(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
