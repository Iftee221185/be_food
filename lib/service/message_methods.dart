import 'package:be_food/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<void> sendmessage(String receivedId, String message) async {
    //get currentuserInfo
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    var date = DateTime.now();
    var date1 = date.day.toString().padLeft(2, '0');  // Ensures two digits for the day
    var date2 = date.month.toString().padLeft(2, '0'); // Ensures two digits for the month
    var date3 = date.year.toString();
    var todaysdate = "$date1-$date2-$date3";
    var time3 = date.hour.toString().padLeft(2, '0');  // Adds leading zero if needed
    var time4 = date.minute.toString().padLeft(2, '0'); // Adds leading zero if needed
    var time = "$time3:$time4";  // Concatenate as 'HH:mm'


    //create a new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receivedId,
        message: message,
        timestamp: timestamp,
        date:todaysdate,
        time:time,
    );

    //chatroom id
    List<String> ids = [currentUserId, receivedId];
    ids.sort();
    String chatRoomId = ids.join("_");
    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //get the message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}


