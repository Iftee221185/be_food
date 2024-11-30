import 'dart:async';

import 'package:be_food/authentication/first_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  starttimer() async {
    Timer(Duration(seconds: 1), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>FirstPage()));
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    starttimer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png",height: 130,width: 130,),
            SizedBox(height: 8,),
            Text("Be-Food",style:GoogleFonts.abel(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: Colors.yellow
            ),),

            Text("your service which only matters",style:GoogleFonts.abel(
                fontSize: 15,
                color: Colors.redAccent
            ),),
            SizedBox(height: 40,),
            CircularProgressIndicator(
              color: Colors.yellowAccent.shade100,
            )
          ],
        ),
      ),
    );
  }
}
