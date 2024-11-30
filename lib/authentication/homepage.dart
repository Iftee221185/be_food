import 'package:be_food/authentication/first_page.dart';
import 'package:be_food/models/note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'package:get/get.dart';
import 'package:be_food/provider/user_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  @override
  void initState() {
    updateData();
    // TODO: implement initState
    super.initState();
  }
  updateData() async{
    UserProvider userProvider =Provider.of(context,listen: false);
    await userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    Userdata? userdata =Provider.of<UserProvider>(context).getUser;
    if(userdata != null)
      {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width/1.2,
                  height: MediaQuery.of(context).size.height/1.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black,
                  ),
                  child:Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(userdata.imageurl!),
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Name:  ',style:GoogleFonts.abel(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),),
                                Text(userdata.name??'',style:GoogleFonts.abel(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow
                                ),),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Email:  ',style:GoogleFonts.abel(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),),
                                Text(userdata.email??'',style:GoogleFonts.abel(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow
                                ),),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Experiences:  ',style:GoogleFonts.abel(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),),
                                Text(userdata.experience??'',style:GoogleFonts.abel(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow
                                ),),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Location:  ',style:GoogleFonts.abel(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),),
                                Text(userdata.location??'',style:GoogleFonts.abel(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow
                                ),),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Number:  ',style:GoogleFonts.abel(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),),
                                Text(userdata.number??'',style:GoogleFonts.abel(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow
                                ),),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Role:  ',style:GoogleFonts.abel(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),),
                                Text(userdata.role??'',style:GoogleFonts.abel(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow
                                ),),
                              ],
                            ),

                          ],
                        ),
                      ),
                      Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: (){},
                            child: Container(
                              height: 40,
                              width: 70,
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: Center(
                                child: Text("Edit",style:GoogleFonts.abel(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),),
                              ),
                            ),
                          )
                      ),
                    ],
                  )
                ),
              ),



        );
      }
    else{
      return Center(child: CircularProgressIndicator(),);
    }

  }
}
/*body: Center(
child: Text(userdata.name?? 'guest')
),*/