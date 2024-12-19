import 'dart:io';
import 'package:be_food/models/note.dart';
import 'package:be_food/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:be_food/ui_for_chef/post_interface_next_page.dart';
import 'package:provider/provider.dart';  // Adjust the import based on your project structure

class AddPosts extends StatefulWidget {
  const AddPosts({super.key});

  @override
  State<AddPosts> createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {
  File? _image;
  String? chefname;
  String? chefimage;
  String? chefuid;
  String? cheflocation;

  final ImagePicker _picker = ImagePicker();
  // Function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to take a photo using the camera
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to navigate to the next page
  // Function to navigate to the next page
  void _goToNextPage() {
    if (_image != null) {
      // If a photo is selected, navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadPage(file: _image!, chefname: chefname!, chefimage: chefimage!, chefuid: chefuid!, cheflocation: cheflocation!), // Pass the selected image to the next page
        ),
      ).then((_) {
        // Reset the image state after returning to this page
        setState(() {
          _image = null;
        });
      });
    } else {
      // If no photo is selected, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a photo first'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  void initState() {
    updateData();
    super.initState();
  }
  updateData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }


  @override
  Widget build(BuildContext context) {
    Userdata? userdata = Provider.of<UserProvider>(context).getUser;
    setState(() {
      chefname=userdata!.name!;
      chefimage=userdata!.imageurl!;
      chefuid=userdata!.uid!;
      cheflocation=userdata!.location!;
    });

    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            SizedBox(width: 5),
            Image.asset("assets/images/logo.png", height: 30, width: 30),
            SizedBox(width: 10),
            Text(
              "Upload Post",
              style: GoogleFonts.abel(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: _goToNextPage,  // Correct the onTap usage here
            child: Text(
              "Next",
              style: GoogleFonts.abel(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss the keyboard if tapping anywhere on the screen
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(

                width: double.infinity,
                height: 400, // Total height for the container
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 4),
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.white60], // Red and Yellow gradient
                    begin: Alignment.topLeft, // Start of the gradient
                    end: Alignment.bottomRight, // End of the gradient
                  ),
                ),
                child: _image == null
                    ? Center(
                  child: Text(
                    "No image selected",
                    style: GoogleFonts.abel(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    width: double.infinity, // Ensure full width
                    height: 100, // Take half the height of the container
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _pickImageFromCamera,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow, // Set the button background color to yellow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4), // Set a smaller border radius
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50), // Add some padding
                      elevation: 5, // Optional: Adds shadow for effect
                    ),
                    child: Text(
                      "Take Photo",
                      style: GoogleFonts.abel(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Text color should be black to contrast with yellow background
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _pickImageFromGallery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow, // Set the button background color to yellow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4), // Set a smaller border radius
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25), // Add some padding
                      elevation: 5, // Optional: Adds shadow for effect
                    ),
                    child: Text(
                      "Choose From Gallery",
                      style: GoogleFonts.abel(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Text color should be black to contrast with yellow background
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
