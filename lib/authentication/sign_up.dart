import 'dart:io';
import 'package:be_food/authentication/homepage.dart';
import 'package:be_food/authentication/login_page.dart';
import 'package:be_food/main.dart';
import 'package:be_food/service/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final namecontroller=TextEditingController();
  final emailcontroller=TextEditingController();
  final experienceController=TextEditingController();
  final numberController=TextEditingController();
  final locationController=TextEditingController();
  final passwordcontroller=TextEditingController();


  bool showSpinner=false;
  bool obscurePassword = true;
  String? imageUrl="https://www.pngarts.com/files/5/Cartoon-Avatar-PNG-Image-Transparent.png";


  FirebaseAuth auth=FirebaseAuth.instance;
  User? user;
  File? pic;
  Uint8List? imgbytes;
  final ImagePicker picker = ImagePicker();

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



  @override
  void dispose() {
     namecontroller.dispose();
     emailcontroller.dispose();
     experienceController.dispose();
     numberController.dispose();
     locationController.dispose();
     passwordcontroller.dispose();
     super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String gender =Get.arguments??"unknown";
    String role=gender;
    void registerUser() async {
      String resp=await AuthMethods().registerUser(
          name: namecontroller .text,
          email: emailcontroller.text,
          experience: experienceController.text,
          location: locationController.text,
          number: numberController.text,
          password: passwordcontroller.text,
          role : role.toString(),
          imageurl : imageUrl.toString(),
      );
      if(resp=='success'){
        Get.to(MyHomePage());
        //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Homepage()));
      }
      else{
        Get.snackbar("Failled Login",resp,backgroundColor: Colors.red,colorText: Colors.white,snackPosition: SnackPosition.BOTTOM);

      }
      setState(() {
        showSpinner=false;
      });

    }

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
              SizedBox(height:MediaQuery.of(context).size.height/11,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo.png",height: 50,width: 50,),
                  SizedBox(width: 10,),
                  Text("Be-Food",style:GoogleFonts.abel(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow
                  ),),
                ],
              ),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.yellow.shade400)
                ),
                child: Center(child: Text("$gender",style: TextStyle(color: Colors.yellow.shade400,fontWeight: FontWeight.bold,fontSize: 25,),)),
              ),
              SizedBox(height: 50,),
              Stack(
                children: [
                  imageUrl!=null?
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(imageUrl!),
                  )
                      :
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage('https://www.pngarts.com/files/5/Cartoon-Avatar-PNG-Image-Transparent.png'),
                  ),
                  Positioned(child: IconButton(
                      onPressed: (){
                        uploadImage();
                      },
                      icon: Icon(Icons.add_a_photo,color: Colors.white,)
                  ),
                    bottom: -10,
                    left: 80,
                  ),

                ],
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: MediaQuery.of(context).size.width/1.1,
                child: TextFormField(
                  controller: namecontroller,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Name" ,
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      hintText: "Enter your Name",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical:10.0,horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.person,color: Colors.white,)
                  ),
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
              SizedBox(height: 10.0,),
              SizedBox(
                width: MediaQuery.of(context).size.width/1.1,
                child: TextFormField(
                  controller: emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email" ,
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      hintText: "Enter Email",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical:10.0,horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.mail,color: Colors.white,)
                  ),
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
              if(gender!='Customer')...[
                SizedBox(height: 10.0,),
                SizedBox(
                  width: MediaQuery.of(context).size.width/1.1,
                  child: TextFormField(
                    controller: experienceController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Experiences" ,
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        hintText: "Enter your Experiences",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical:10.0,horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.shopping_bag,color: Colors.white,)
                    ),
                    style: TextStyle(fontSize: 16,color: Colors.white),
                  ),
                ),
              ],
              SizedBox(height: 10.0,),
              SizedBox(
                width: MediaQuery.of(context).size.width/1.1,
                child: TextFormField(
                  controller: locationController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Location" ,
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      hintText: "Enter your Location",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical:10.0,horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.location_city,color: Colors.white,)
                  ),
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
              SizedBox(height: 10.0,),
              SizedBox(
                width: MediaQuery.of(context).size.width/1.1,
                child: TextFormField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Number" ,
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      hintText: "Enter your Phone-Number",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical:10.0,horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.phone,color: Colors.white,)
                  ),
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
              SizedBox(height: 10.0,),
              SizedBox(
                width: MediaQuery.of(context).size.width/1.1,
                child: TextFormField(
                  controller: passwordcontroller,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical:10.0,horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    prefixIcon: Icon(Icons.lock,color: Colors.white,),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: obscurePassword
                            ? const Icon(Icons.visibility_outlined,)
                            : const Icon(Icons.visibility_outlined,color: Colors.white,)),
                  ),
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
              SizedBox(height: 30.0,),
              Material(
                elevation: 5.0,
                color: Colors.yellow.shade400,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: (){
                    setState(() {
                      showSpinner=true;
                    });
                    registerUser();
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text('Register',style: TextStyle(
                    color: Colors.black,
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}