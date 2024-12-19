import 'package:cloud_firestore/cloud_firestore.dart';

class Userdata {
  final String? name;
  final String? uid;
  final String? email;
  final String? experience;
  final String? location;
  final String? number;
  final String? role;
  final String? imageurl;

  Userdata({
    required this.name,
    required this.uid,
    required this.email,
    required this.experience,
    required this.location,
    required this.number,
    required this.role,
    required this.imageurl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uid': uid,
      'email': email,
      'experience': experience,
      'location': location,
      'number': number,
      'role' : role,
      'imageurl':imageurl,
    };
  }

  static Userdata fromSnap(DocumentSnapshot snap) {
    var snapshot=snap.data() as Map<String,dynamic>;
    return Userdata(
      name: snapshot['name'],
      uid: snapshot['uid'],
      email:snapshot['email'],
      experience: snapshot['experience'],
      location: snapshot['location'],
      number: snapshot['number'],
      role: snapshot['role'],
      imageurl: snapshot['imageurl'],
    );
  }

}

