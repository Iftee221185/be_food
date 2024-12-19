import 'package:be_food/authentication/first_page.dart';
import 'package:be_food/authentication/homepage.dart';
import 'package:be_food/chatbox/chat_home.dart';
import 'package:be_food/customer/customer_feed.dart';
import 'package:be_food/delevaryman/delevaryfeed.dart';
import 'package:be_food/models/note.dart';
import 'package:be_food/navbar/home.dart';
import 'package:be_food/provider/user_provider.dart';
import 'package:be_food/ui_for_chef/post_interface.dart';
import 'package:be_food/ui_for_customer/customer_home.dart';
import 'package:be_food/ui_for_customer/customer_profile.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
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
  int selectedIndex = 2;
  void ontabbed(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  int _currentIndex = 0;
  PageController _pageController= PageController();

  @override
  void initState() {
    updateData();
    super.initState();
    _pageController = PageController();
    pageController = PageController(initialPage: _tabIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  int _tabIndex = 2;
  int get tabIndex => _tabIndex;
  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  late PageController pageController;

  updateData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    Userdata? userdata = Provider.of<UserProvider>(context).getUser;
    if (userdata == null) {
      return Scaffold(
        body: Center(
            child: CircularProgressIndicator()), // Or show a default screen
      );
    }
    else if (userdata.role == 'Chef') {
      return Scaffold(
        extendBody: true,
        bottomNavigationBar: CircleNavBar(
          activeIcons: const [
            Icon(Icons.person, color: Colors.black),
            Icon(Icons.messenger, color: Colors.black),
            Icon(Icons.home, color: Colors.black),
            Icon(Icons.post_add, color: Colors.black),
            Icon(Icons.man, color: Colors.black),
          ],
          inactiveIcons:  [
            Text(
              "Profile",
              style: GoogleFonts.abel(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black),
            ),
            Text(
              "Chatbox",
              style: GoogleFonts.abel(fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              "Home",
              style: GoogleFonts.abel(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              "Post",
              style: GoogleFonts.abel(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              "DelevaryMan",
              style: GoogleFonts.abel(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black),
            ),
          ],
          color: Colors.white,
          height: 50,
          circleWidth: 50,
          activeIndex: tabIndex,
          onTap: (index) {
            tabIndex = index;
            pageController.jumpToPage(tabIndex);
          },
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
          cornerRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(24),
            bottomLeft: Radius.circular(24),
          ),
          shadowColor: Colors.black,
          elevation: 3,
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (v) {
            tabIndex = v;
          },
          children: [
            CustomerProfile(),
            ChatHome(),
            CustomerHome(),
            AddPosts(),
            Delevaryfeed(),

          ],
        ),
      );
    }
    else if (userdata.role == 'Customer') {
      return Scaffold(
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              CustomerHome(),
              ChatHome(),
              CustomerProfile(),
            ],
          ),
        ),
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: _currentIndex,
            showElevation: true, // use this to remove appBar's elevation
            onItemSelected: (index) => setState(() {
              _currentIndex = index;
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
            }),
            items: [
              BottomNavyBarItem(
                icon: Icon(Icons.apps),
                title: Text('Home'),
                activeColor: Colors.black,
              ),
              BottomNavyBarItem(
                  icon: Icon(Icons.message),
                  title: Text('Messages'),
                  activeColor: Colors.black
              ),
              BottomNavyBarItem(
                  icon: Icon(Icons.person),
                  title: Text('Settings'),
                  activeColor: Colors.black
              ),
            ],
          )
      );
    }
    else {
      return Scaffold(
        body: Center(
          child: pages2.elementAt(selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor:   Colors.black,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 25,
                color: Colors.white,
              ),
              label: "Home",
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
                size: 25,
                color: Colors.white,
              ),
              label: "Chat",
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 25,
                color: Colors.white,
              ),
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

  List<Widget> pages = <Widget>[
    Home(),
    ChatHome(),
    CustomerProfile(),
    Delevaryfeed(),
  ];
  List<Widget> pages2 = <Widget>[
    CustomerHome(),
    ChatHome(),
    CustomerProfile(),
  ];
}
