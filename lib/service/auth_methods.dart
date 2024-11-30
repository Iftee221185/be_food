import 'package:be_food/models/note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';


class AuthMethods{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _fireStore=FirebaseFirestore.instance;

  Future<String> registerUser({
    required String name,
    required String email,
    required String experience,
    required String location,
    required String number,
    required String password,
    required String role,
    required String imageurl,
  }) async {
    String resp = "Some error occurred";

    try {
      // Ensure all fields are filled out
      if (name.isNotEmpty &&
          email.isNotEmpty &&
          experience.isNotEmpty &&
          location.isNotEmpty &&
          number.isNotEmpty &&
          password.isNotEmpty &&
          role.isNotEmpty &&
          imageurl.isNotEmpty) {

        // Try to create a user with the provided email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Create a UserData object to store in Firestore
        Userdata userData = Userdata(
          name: name,
          uid: cred.user!.uid,
          email: email,
          experience: experience,
          location: location,
          number: number,
          role: role,
          imageurl: imageurl,
        );

        // Store the user data in Firestore
        await _fireStore.collection('users').doc(cred.user!.uid).set(userData.toJson());

        resp = 'success';
      } else {
        resp = "Please enter all the fields"; // If any field is empty
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication exceptions
      if (e.code == 'weak-password') {
        resp = "The password is too weak. Please choose a stronger password.";
      } else if (e.code == 'email-already-in-use') {
        resp = "The email address is already in use by another account.";
      } else if (e.code == 'invalid-email') {
        resp = "The email address is not valid.";
      } else {
        resp = e.message ?? "An unknown Firebase error occurred.";
      }
    } catch (err) {
      resp = err.toString();
    }

    return resp; // Return the response message
  }





  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success"; // Successful login
      } else {
        res = "Please Enter all the Fields"; // If fields are empty
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        res = "Incorrect password or email provided";
      } else {
        res = "An error occurred: ${e.message ?? 'Unknown error'}";
      }
    } catch (err) {
      print("Error: $err");
      res = err.toString();
    }

    return res; // Return the result string
  }

  Future<Userdata> getUserDetails() async{
    User currentUser =_auth.currentUser!;
    DocumentSnapshot snap=await _fireStore.collection('users').doc(currentUser.uid).get();
    return Userdata.fromSnap(snap);
  }
}

