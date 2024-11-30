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
      backgroundColor: Colors.white10,
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
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    client['role'] ?? '',
                    style: GoogleFonts.abel(
                      fontSize: 15,
                      color: Colors.black,
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
