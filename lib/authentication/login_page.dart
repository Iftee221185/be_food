import 'package:be_food/authentication/homepage.dart';
import 'package:be_food/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:get/get.dart';
import 'package:be_food/service/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailcontroller=TextEditingController();
  final passwordcontroller=TextEditingController();
  bool showSpinner=false;
  bool obscurePassword = true;
  String youare="";
  String gender="";






  @override
  void dispose(){
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }
  void loginUser() async{
    setState(() {
      showSpinner=true;
    });
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await users.where('email', isEqualTo: emailcontroller.text).get();
    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        var userData = doc.data() as Map<String, dynamic>;
        youare=  userData['role'];

      });
    }
    String res=await AuthMethods().loginUser(
      email:emailcontroller.text,
      password:passwordcontroller.text,
    );
    setState(() {
      showSpinner=false;
    });
    if(res=="success"){
      if(youare==gender) {
        Get.to(MyHomePage());
        Get.snackbar("Success","Logged In",backgroundColor: Colors.white,colorText: Colors.black,snackPosition: SnackPosition.BOTTOM);

      }
      else{
         Get.snackbar("Failled Login","Enter in the right Role",backgroundColor: Colors.red,colorText: Colors.white,snackPosition: SnackPosition.BOTTOM);
      }
    }
    else{
      Get.snackbar("Failled Login",res,backgroundColor: Colors.red,colorText: Colors.white,snackPosition: SnackPosition.BOTTOM);

    }

  }

  FirebaseAuth auth=FirebaseAuth.instance;
  User? user;

  @override
  Widget build(BuildContext context) {
    gender=Get.arguments??"";
    return Scaffold(
      backgroundColor: Colors.black12,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            SizedBox(height: 40,),
            Container(
             width: MediaQuery.of(context).size.width/2,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow.shade400)
              ),
              child: Center(child: Text("$gender",style: TextStyle(color: Colors.yellow.shade400,fontWeight: FontWeight.bold,fontSize: 25,),)),
            ),
            SizedBox(height: 20,),
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
            SizedBox(height: 30.0,),
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
              color: Colors.yellowAccent.shade400,
              borderRadius: BorderRadius.circular(30.0),
              child: MaterialButton(
                onPressed:(){

                 loginUser();

                },
                minWidth: 200.0,
                height: 42.0,
                child: Text('Login In',style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ),

          ],
        ),
      ),
    );
  }
}