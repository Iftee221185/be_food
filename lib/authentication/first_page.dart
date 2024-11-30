import 'package:be_food/authentication/login_page.dart';
import 'package:be_food/authentication/second_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            GestureDetector(
               onTap: (){
                 Get.to(LoginPage(),arguments: "Chef");
               },
              child: Container(
                height: MediaQuery.of(context).size.height/13,
                width: MediaQuery.of(context).size.width/1.2,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.yellowAccent.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text("Login as Chef",style: GoogleFonts.abel(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Get.to(LoginPage(),arguments: "Customer");
              },
              child: Container(
                height: MediaQuery.of(context).size.height/13,
                width: MediaQuery.of(context).size.width/1.2,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.yellowAccent.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text("Login as Customer",style: GoogleFonts.abel(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Get.to(LoginPage(),arguments: "Delevary-Man");
              },
              child: Container(
                height: MediaQuery.of(context).size.height/13,
                width: MediaQuery.of(context).size.width/1.2,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.yellowAccent.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text("Login as Delivaryman",style: GoogleFonts.abel(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?",style: TextStyle(color: Colors.white),),
                TextButton(
                  onPressed: () {
                     Get.to(SecondPage());
                  },
                  child: const Text(
                    "Register now",
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
