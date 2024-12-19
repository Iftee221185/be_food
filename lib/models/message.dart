import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String date;
  final String time;
  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.date,
    required this.time,

  });
  Map<String,dynamic> toMap() {
    return{
      'senderId':senderId,
      'senderEmail':senderEmail,
      'receiverId':receiverId,
      'message':message,
      'timestamp':timestamp,
      'date':date,
      'time':time,
    };
  }

}
