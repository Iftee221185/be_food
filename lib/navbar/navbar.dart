import 'package:be_food/authentication/first_page.dart';
import 'package:be_food/authentication/homepage.dart';
import 'package:be_food/chatbox/chat_home.dart';
import 'package:be_food/customer/customer_feed.dart';
import 'package:be_food/delevaryman/delevaryfeed.dart';
import 'package:be_food/models/note.dart';
import 'package:be_food/navbar/home.dart';
import 'package:be_food/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex=1;
  void ontabbed(int index)
  {
    setState(() {
      selectedIndex=index;
    });

  }
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
    if (userdata == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Or show a default screen
      );
    }
    else if(userdata.role=='Chef') {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            title: Row(
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
            actions: [
              IconButton(
                onPressed: () async {
                  AwesomeDialog (
                    context: context,
                    dialogType: DialogType.question,
                    headerAnimationLoop: false,
                    animType: AnimType.bottomSlide,
                    title: 'Logout',
                    desc: 'Are you sure want to Logout?',
                    buttonsTextStyle:
                    const TextStyle(color: Colors.white),
                    showCloseIcon: true,
                    btnCancelOnPress: () {},
                    btnOkText: 'YES',
                    btnCancelText: 'NO',
                    btnOkOnPress: () {

                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FirstPage()));

                    },
                  ).show();

                },
                icon: Icon(Icons.logout,color: Colors.white,),
              ),
            ],
          ),
          body: Center(
            child: pages.elementAt(selectedIndex),
          ),

          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            items:<BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home,size: 35,color: Colors.white,
              ),
                label: "Home",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(icon: Icon(Icons.message,size: 35,color: Colors.white,
              ),
                label: "Chat",
                backgroundColor: Colors.white,
              ),


              BottomNavigationBarItem(icon: Icon(Icons.person,size: 35,color: Colors.white,),
                label: "Profile",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(icon: Icon(Icons.bike_scooter,size: 35,color: Colors.white,),
                label: "Delivary-Man",
                backgroundColor: Colors.white,
              ),
            ],
            type: BottomNavigationBarType.fixed,
            // type: BottomNavigationBarType.shifting,
            currentIndex: selectedIndex,
            selectedItemColor: Colors.yellowAccent,
            iconSize: 40,
            onTap: ontabbed,
          ),
        );

      }
    else if(userdata.role=='Customer'){
       return Scaffold(
    appBar: AppBar(
    toolbarHeight: 80,
    backgroundColor: Colors.black,
    automaticallyImplyLeading: false,
    title: Row(
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
    actions: [
    IconButton(
    onPressed: () async {
    AwesomeDialog (
    context: context,
    dialogType: DialogType.question,
    headerAnimationLoop: false,
    animType: AnimType.bottomSlide,
    title: 'Logout',
    desc: 'Are you sure want to Logout?',
    buttonsTextStyle:
    const TextStyle(color: Colors.white),
    showCloseIcon: true,
    btnCancelOnPress: () {},
    btnOkText: 'YES',
    btnCancelText: 'NO',
    btnOkOnPress: () {

    FirebaseAuth.instance.signOut();
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FirstPage()));

    },
    ).show();

    },
    icon: Icon(Icons.logout,color: Colors.white,),
    ),
    ],
    ),
    body: Center(
    child: pages1.elementAt(selectedIndex),
    ),

    bottomNavigationBar: BottomNavigationBar(
    backgroundColor: Colors.black,
    items:<BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.home,size: 35,color: Colors.white,
    ),
    label: "Home",
    backgroundColor: Colors.white,
    ),
      BottomNavigationBarItem(icon: Icon(Icons.message,size: 35,color: Colors.white,
      ),
        label: "Chat",
        backgroundColor: Colors.white,
      ),
    BottomNavigationBarItem(icon: Icon(Icons.person,size: 35,color: Colors.white,),
    label: "Profile",
    backgroundColor: Colors.white,
    ),
    ],
    type: BottomNavigationBarType.fixed,
    // type: BottomNavigationBarType.shifting,
    currentIndex: selectedIndex,
    selectedItemColor: Colors.yellowAccent,
    iconSize: 40,
    onTap: ontabbed,
    ),
    );
    }

    else{
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Row(
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
          actions: [
            IconButton(
              onPressed: () async {
                AwesomeDialog (
                  context: context,
                  dialogType: DialogType.question,
                  headerAnimationLoop: false,
                  animType: AnimType.bottomSlide,
                  title: 'Logout',
                  desc: 'Are you sure want to Logout?',
                  buttonsTextStyle:
                  const TextStyle(color: Colors.white),
                  showCloseIcon: true,
                  btnCancelOnPress: () {},
                  btnOkText: 'YES',
                  btnCancelText: 'NO',
                  btnOkOnPress: () {

                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FirstPage()));

                  },
                ).show();

              },
              icon: Icon(Icons.logout,color: Colors.white,),
            ),
          ],
        ),
        body: Center(
          child: pages2.elementAt(selectedIndex),
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          items:<BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home,size: 35,color: Colors.white,
            ),
              label: "Home",
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(icon: Icon(Icons.message,size: 35,color: Colors.white,
            ),
              label: "Chat",
              backgroundColor: Colors.white,
            ),

            BottomNavigationBarItem(icon: Icon(Icons.person,size: 35,color: Colors.white,),
              label: "Profile",
              backgroundColor: Colors.white,
            ),
          ],
          type: BottomNavigationBarType.fixed,
          // type: BottomNavigationBarType.shifting,
          currentIndex: selectedIndex,
          selectedItemColor: Colors.yellowAccent,
          iconSize: 40,
          onTap: ontabbed,
        ),
      );
    }

  }

  List<Widget> pages= <Widget> [
    Home(),
    ChatHome(),
    Homepage(),
    Delevaryfeed(),
  ];
  List<Widget> pages1= <Widget> [
    CustomerFeed(),
    ChatHome(),
    Homepage(),
  ];
  List<Widget> pages2= <Widget> [
    Delevaryfeed(),
    ChatHome(),
    Homepage(),
  ];

}