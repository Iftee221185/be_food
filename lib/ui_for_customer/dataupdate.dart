import 'package:be_food/service/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dataupdate extends StatefulWidget {
  const Dataupdate({super.key});

  @override
  State<Dataupdate> createState() => _DataupdateState();
}

class _DataupdateState extends State<Dataupdate> {
  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final experienceController = TextEditingController();
  final numberController = TextEditingController();
  final locationController = TextEditingController();

  bool showSpinner = false;
  String? imageUrl;

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getUserData();  // Fetch the user data when the screen is initialized
  }

  // Get user data from Firestore
  Future<void> getUserData() async {
    try {
      user = auth.currentUser;

      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (userSnapshot.exists) {
          // Populate the controllers with the existing data
          namecontroller.text = userSnapshot['name'] ?? '';
          emailcontroller.text = userSnapshot['email'] ?? '';
          numberController.text = userSnapshot['number'] ?? '';
          locationController.text = userSnapshot['location'] ?? '';
          experienceController.text = userSnapshot['experience'] ?? '';
          imageUrl = userSnapshot['imageurl'] ?? '';
          setState(() {});
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching user data: $e");
      print("Error fetching user data: $e");
    }
  }

  // Take a picture using the camera
  Future<XFile?> takeimagefromcamera() async {
    final pickedfile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1200,
      maxWidth: 1200,
      imageQuality: 100,
    );
    return pickedfile;
  }

  // Take a picture from the gallery
  Future<XFile?> takeimagefromgallery() async {
    final pickedfile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 1200,
      imageQuality: 100,
    );
    return pickedfile;
  }

  // Upload the image to Cloudinary
  Future<void> uploadImage() async {
    final XFile? image = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (BuildContext ab) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Camera"),
                onTap: () async {
                  final pickedFile = await takeimagefromcamera();
                  Navigator.of(context).pop(pickedFile);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_album),
                title: Text("Gallery"),
                onTap: () async {
                  final pickedFile = await takeimagefromgallery();
                  Navigator.of(context).pop(pickedFile);
                },
              ),
            ],
          ),
        );
      },
    );

    if (image != null) {
      try {
        setState(() {
          showSpinner = true; // Show loading spinner while uploading
        });

        // Initialize Cloudinary with your Cloud name, API Key, and API Secret
        final cloudinary = CloudinaryPublic('dsyujcmxf', 'profile_pic', cache: false);

        // Upload the image to Cloudinary
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: "profile_pic"),
        );

        // Store the URL of the uploaded image
        setState(() {
          imageUrl = response.secureUrl;
          showSpinner = false; // Hide loading spinner after upload
        });
        Fluttertoast.showToast(msg: "Image uploaded successfully!");
      } catch (e) {
        setState(() {
          showSpinner = false; // Hide loading spinner in case of error
        });
        Fluttertoast.showToast(msg: "Error uploading image. Please try again.");
        print("Error uploading image: $e");
      }
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData() async {
    try {
      setState(() {
        showSpinner = true;
      });

      // Get the current user
      User? user = auth.currentUser;

      if (user != null) {
        // Reference to Firestore collection 'users'
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentReference userDoc = firestore.collection('users').doc(user.uid);

        // Update user data
        await userDoc.update({
          'name': namecontroller.text,
          'email': emailcontroller.text,
          'experience': experienceController.text,
          'location': locationController.text,
          'number': numberController.text,
          'imageurl': imageUrl.toString(), // Use the image URL
        });

        setState(() {
          showSpinner = false;
        });

        Fluttertoast.showToast(msg: "User data updated successfully!");
        Get.back();  // Go back after successful update
      }
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      Fluttertoast.showToast(msg: "Error updating user data: $e");
      print("Error updating user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 11),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo.png", height: 50, width: 50),
                  SizedBox(width: 10),
                  Text(
                    "Be-Food",
                    style: GoogleFonts.abel(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Stack(
                children: [
                  imageUrl != null
                      ? CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(imageUrl!),
                  )
                      : CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                        'https://www.pngarts.com/files/5/Cartoon-Avatar-PNG-Image-Transparent.png'),
                  ),
                  Positioned(
                    child: IconButton(
                      onPressed: () {
                        uploadImage();
                      },
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      ),
                    ),
                    bottom: -10,
                    left: 80,
                  ),
                ],
              ),
              SizedBox(height: 10),
              buildTextField(namecontroller, "Name", "Enter your Name", Icons.person),
              SizedBox(height: 30.0),
              buildTextField(experienceController, "Experience", "Enter your Experience", Icons.shopping_bag),
              SizedBox(height: 30.0),
              buildTextField(locationController, "Location", "Enter your Location", Icons.location_city),
              SizedBox(height: 30.0),
              buildTextField(numberController, "Phone Number", "Enter your Phone Number", Icons.phone),
              SizedBox(height: 30.0),
              Material(
                elevation: 5.0,
                color: Colors.yellow.shade400,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      showSpinner = true;
                    });
                    updateUserData();
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, String hint, IconData icon) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: Icon(icon, color: Colors.white)),
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
