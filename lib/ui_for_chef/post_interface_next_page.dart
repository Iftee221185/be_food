import 'dart:convert';
import 'dart:io';
import 'package:be_food/models/note.dart';
import 'package:be_food/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class UploadPage extends StatefulWidget {
  final File file;  // The image file
  final String chefname;  // Chef's name
  final String chefimage;  // Chef's image URL
  final String chefuid;  // Chef's UID
  final String cheflocation;  // Receive the file from the first page

  const UploadPage({Key? key, required this.file,
    required this.chefname,
    required this.chefimage,
    required this.chefuid,
    required this.cheflocation,}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool isUploading = false;
  bool isPlatter = false; // To toggle between platter and non-platter
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int likes = 0;
  double rating = 0.0;
  final Timestamp timestamp = Timestamp.now();

  // Controllers for text fields
  TextEditingController _foodNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _membersController = TextEditingController();

  // Variable for food type dropdown selection
  String? _foodType;

  // List of food type options
  List<String> foodTypes = [
    'Snacks',
    'Dinner',
    'Lunch',
    'Special Item',
    'Breakfast'
  ];

  // Function to upload image to Cloudinary
  Future<Map<String, String>?> uploadToCloudinary(File file) async {
    String cloudName = 'dsyujcmxf'; // Set your Cloudinary cloud name
    String uploadPreset = 'post_image'; // Set your upload preset

    var uri = Uri.parse("https://api.cloudinary.com/v1_1/dsyujcmxf/image/upload");
    var request = http.MultipartRequest("POST", uri);

    // Read the file content as bytes
    var fileBytes = await file.readAsBytes();

    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: file.path.split("/").last,
    );

    // Add the file part to the request
    request.files.add(multipartFile);

    // Add upload preset
    request.fields['upload_preset'] = uploadPreset;

    // Send the request and await the response
    var response = await request.send();

    // Get the response as text
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseBody);
      Map<String, String> requiredData = {
        "url": jsonResponse["secure_url"],
        "id": jsonResponse["public_id"],
        "name": file.path.split("/").last,
      };
      return requiredData;
    } else {
      print("Upload failed with status: ${response.statusCode}");
      return null;
    }
  }

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle form submission
      setState(() {
        isUploading = true;
      });

      // Proceed to upload image and food data
      uploadToCloudinary(widget.file).then((result) {


        if (result != null) {
          // Get the Cloudinary URL from the result
          String imageUrl = result['url']!;
          String PublicID=  result["id"]!;

          // Save the post data along with the image URL to Firebase

          onPressed(imageUrl,PublicID);
          setState(() {
            isUploading = false;
          });
          Get.snackbar("Success", "Upload Successful!",backgroundColor: Colors.greenAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
          print("File uploaded to Cloudinary: ${result['url']}");
          Navigator.pop(context);

        } else {
          setState(() {
            isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Upload failed!")),
          );
          Navigator.pop(context);
        }
      });
    } else {
      print("Form is not valid");
    }




  }
  void onPressed(String imageUrl,String PublicID) {
     var date = DateTime.now();
     var date1 = date.day.toString().padLeft(2, '0');  // Ensures two digits for the day
     var date2 = date.month.toString().padLeft(2, '0'); // Ensures two digits for the month
     var date3 = date.year.toString();
     var todaysdate = "$date1-$date2-$date3";
     var time3 = date.hour.toString().padLeft(2, '0');  // Adds leading zero if needed
     var time4 = date.minute.toString().padLeft(2, '0'); // Adds leading zero if needed
     var time = "$time3:$time4";  // Concatenate as 'HH:mm'


    CollectionReference collRef = FirebaseFirestore.instance.collection('post');
    collRef.add({
      'foodname': _foodNameController.text,
      'foodtype': _foodType,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'discount': _discountController.text,
      'platter': isPlatter ? "Yes" : "No",
      'member': _membersController.text,
      'imageurl': imageUrl,
      'likes': likes,
      'rating': rating,
      'timestamp': timestamp,
      'date': todaysdate,
      'time': time,
      'adminlocation': widget.cheflocation,
      'uid': widget.chefuid,
      'profilepic': widget.chefimage,
      'nameadmin': widget.chefname,
      'imagepublicid': PublicID,
    });
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _membersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Center(
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Colors.white),
              ),
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
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: CircleAvatar(
              radius: 18,
              backgroundImage:widget.chefimage!= null
                  ? NetworkImage(widget.chefimage!)
                  : AssetImage("assets/images/file.png")
              as ImageProvider,
            ),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isUploading,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Food Image Preview
                Image.file(
                  widget.file,
                  width: 200,
                  height: 400,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),

                // Food Name Text Field
                TextFormField(
                  controller: _foodNameController,
                  decoration: InputDecoration(
                    labelText: "Food Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Please enter a food name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Type of Food Dropdown
                DropdownButtonFormField<String>(
                  value: _foodType,
                  decoration: InputDecoration(
                    labelText: "Type of Food",
                    border: OutlineInputBorder(),
                  ),
                  items: foodTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _foodType = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Please select a type of food";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Description Text Field
                TextFormField(
                  controller: _descriptionController,
                  maxLength: 150,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                    counterText: "",
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Please enter a description";
                    }
                    if (value!.length > 150) {
                      return "Description must not exceed 150 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Price Text Field
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Please enter a price.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Discount Text Field (Optional)
                TextFormField(
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Discount (Optional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                // Platter Option Toggle
                Row(
                  children: [
                    Text("Is it a Platter?"),
                    Switch(
                      value: isPlatter,
                      onChanged: (value) {
                        setState(() {
                          isPlatter = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Number of Members (If Platter is Yes)
                if (isPlatter)
                  TextFormField(
                    controller: _membersController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Number of Members",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Please enter the number of members.";
                      }
                      return null;
                    },
                  ),
                SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: (){

                    _submitForm();

                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: Text("Upload"),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
