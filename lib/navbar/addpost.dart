import 'package:be_food/models/note.dart';
import 'package:be_food/provider/user_provider.dart';
import 'package:be_food/service/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class Addpost extends StatefulWidget {
  const Addpost({super.key});


  @override
  State<Addpost> createState() => _AddpostState();
}

class _AddpostState extends State<Addpost> {
  var descriptioncontroller=TextEditingController();
  var pricecontroller=TextEditingController();
  final ImagePicker picker = ImagePicker();
  String? imageUrl=null;
  bool showSpinner=false;

  final GlobalKey<FormState> noteFormKey = GlobalKey();
  Future<XFile?> takeimagefromcamera() async {
    final pickedfile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1200,
      maxWidth: 1200,
      imageQuality: 100,
    );
    return pickedfile;

  }

  Future<XFile?> takeimagefromgallery() async {
    final pickedfile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 1200,
      imageQuality: 100,
    );
    return pickedfile;
  }
  @override
  void dispose() {
    descriptioncontroller.dispose();
    pricecontroller.dispose();
    super.dispose();
  }

  // Store the URL of the uploaded image
  Future<void> uploadImage() async {
    // Show bottom sheet to choose between camera and gallery
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
        final cloudinary = CloudinaryPublic('dsyujcmxf', 'post_image', cache: false);

        // Upload the image to Cloudinary
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: "post"),
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

  @override
  Widget build(BuildContext context) {

    final List<dynamic> args=Get.arguments;
    final String name=args[0];
    final String imageurl=args[1];
    final String Uid=args[2];
    var date=DateTime.now();
    var date1=date.day.toString();
    var date2=date.month.toString();
    var date3=date.year.toString();
    var todaysdate=date1+"-"+date2+"-"+date3;
    var time=date.hour.toString()+":"+date.minute.toString();
    void onpressed(){
      CollectionReference collRef =FirebaseFirestore.instance.collection('post');
      collRef.add({
        'description' :descriptioncontroller.text,
        'price': pricecontroller.text,
        'imageurl':imageUrl,
        'uid':Uid,
        'date':todaysdate,
        'time':time,
        'profilepic':imageurl,
        'nameadmin':name,
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
        toolbarHeight: 120,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset("assets/images/logo.png",height: 40,width: 40,),
            SizedBox(width: 10,),
            Text("Upload Post",style:GoogleFonts.abel(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.yellow
            ),),
          ],
        ),

      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height/1.4,
            width: MediaQuery.of(context).size.width/1.1,
            margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              color: Colors.black
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage:NetworkImage(imageurl),
                          ),
                        ),

                        Text(name,style:GoogleFonts.abel(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow
                        ),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: MediaQuery.of(context).size.height/2,
                      width: MediaQuery.of(context).size.width/1.3,
                      child: Image(
                        image: imageUrl!= null
                            ? NetworkImage(imageUrl!)
                            : AssetImage("assets/images/upload.jpg") as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),

                  ],
                ),
                Positioned(
                    bottom: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: (){
                        if(pricecontroller.text!="" && imageurl!='null')
                          {
                            onpressed();
                            Get.back();
                          }else{
                          Get.snackbar("Error", "Please Add Image of your Food and Price",
                              backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
                        }

                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Center(
                          child: Text("Upload",style:GoogleFonts.abel(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),),
                        ),
                      ),
                    )
                ),
                Positioned(
                  left: 20,
                    bottom: 20,
                    child:  SizedBox(
                      width: MediaQuery.of(context).size.width/2,
                      child: TextFormField(
                        controller: descriptioncontroller,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Enter a description",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            //contentPadding: EdgeInsets.symmetric(vertical:10.0,horizontal: 20.0),
                            border: InputBorder.none
                        ),
                        style: TextStyle(fontSize: 16,color: Colors.white),
                      ),
                    ),
                ),
                Positioned(
                    top: 20,
                    right: 20,
                    child:  GestureDetector(
                      onTap: (){
                        uploadImage();
                      },
                      child: Container(
                        height: 50,
                        width: 110,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 2,color: Colors.yellow)
                        ),

                        child: Center(
                          child: Text("Add Image",style:GoogleFonts.abel(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow
                          ),),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  left: 80,
                  bottom: 120,
                  child:  SizedBox(
                    width: MediaQuery.of(context).size.width/2,
                    child: TextFormField(
                      controller: pricecontroller,
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.yellow,
                          hintText: "Price",
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          //contentPadding: EdgeInsets.symmetric(vertical:10.0,horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        prefixIcon: Icon(Icons.money),
                      ),

                      style: TextStyle(fontSize: 16,color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
