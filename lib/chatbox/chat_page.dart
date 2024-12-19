import 'package:be_food/chatbox/chatbubble.dart';
import 'package:be_food/chatbox/time_message.dart';
import 'package:be_food/service/message_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  final String receivedemail;
  final String receivedname;
  final String imageurl;
  final String receivedID;
  const ChatPage({
    super.key,
    required this.receivedemail,
    required this.receivedname,
    required this.imageurl,
    required this.receivedID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Map<String, bool> _showTimeMap = {};  // Track visibility per message
  final TextEditingController _messagecontroller = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messagecontroller.text.isNotEmpty) {
      await _chatService.sendmessage(
          widget.receivedID, _messagecontroller.text);
      _messagecontroller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // The back arrow icon
            color: Colors.yellow, // Change this to any color you want
          ),
          onPressed: () {
            // Add your back navigation logic here
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(widget.imageurl),
            ),
            SizedBox(width: 10),
            Text(
              widget.receivedname,
              style: GoogleFonts.abel(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Image.asset("assets/images/logo.png", height: 22, width: 22),
              SizedBox(width: 5),
              Text(
                "Be-Food",
                style: GoogleFonts.abel(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow),
              ),
            ],
          ),
          SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
          SizedBox(height: 7),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receivedID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }

          // Ensure we initialize the map for each new message
          final messages = snapshot.data!.docs;
          for (var message in messages) {
            // Check if the message ID already exists in the map
            String documentId = message.id;
            if (!_showTimeMap.containsKey(documentId)) {
              _showTimeMap[documentId] = false; // Initialize to false (time hidden initially)
            }
          }

          return ListView(
            children: messages
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    String documentId = document.id;
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
          (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment:
          (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _showTimeMap[documentId] = !_showTimeMap[documentId]!; // Toggle visibility of time
                });
              },
              child: Column(
                children: [
                  Chatbubble(message: data['message']),
                  if (_showTimeMap[documentId] == true) ...[
                    Chattime(time: data['time'] ?? '', date: data['date'] ?? ''),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 45,
              child: TextFormField(
                controller: _messagecontroller,
                decoration: InputDecoration(
                  hintText: "Enter message",
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                style: TextStyle(fontSize: 16, color: Colors.white),
                cursorColor: Colors.blueAccent,
              ),
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send,
              color: Colors.yellow,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
