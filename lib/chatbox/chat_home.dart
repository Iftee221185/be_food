import 'package:be_food/chatbox/chat_page.dart';
import 'package:be_food/models/note.dart';
import 'package:be_food/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            SizedBox(width: 10),
            Image.asset("assets/images/logo.png", height: 35, width: 35),
            SizedBox(width: 5),
            Text(
              "ChatBox",
              style: GoogleFonts.abel(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: CircleAvatar(
              radius: 18,
              backgroundImage: userdata!.imageurl!= null
                  ? NetworkImage(userdata!.imageurl!)
                  : AssetImage("assets/images/file.png")
              as ImageProvider,
            ),
          ),
          SizedBox(width: 20,)
        ],

      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          List<Widget> clientWidgets = [];
          final clients = snapshot.data?.docs.reversed.toList() ?? [];

          for (var client in clients) {
            if (client['email'] != userdata!.email) {
              final phoneNumber = client['number'];  // Assuming `phone` field exists
              final clientWidget = Card(
                margin: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.white70], // Red and Yellow gradient
                      begin: Alignment.topLeft, // Start of the gradient
                      end: Alignment.bottomRight, // End of the gradient
                    ),
                  ),
                  child: ListTile(
                    onTap: (){
                      Get.to(ChatPage(receivedemail: client['email'],receivedname: client['name'],imageurl:client['imageurl'] ,receivedID: client['uid']));
                    },
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(client['imageurl'] ?? ''),
                    ),
                    title: Text(
                      client['name'],
                      style: GoogleFonts.abel(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      client['role'] ?? '',
                      style: GoogleFonts.abel(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
              clientWidgets.add(clientWidget);
            }
          }

          return ListView(
            children: clientWidgets,
          );
        },
      ),
    );
  }
}
