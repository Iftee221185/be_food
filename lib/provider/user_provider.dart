import 'package:be_food/models/note.dart';
import 'package:flutter/material.dart';
import 'package:be_food/service/auth_methods.dart';
import 'package:get/get.dart';

class UserProvider with ChangeNotifier{
  Userdata? _user;
  final AuthMethods _authMethods=AuthMethods();

  Userdata? get getUser=> _user;
  Future<void> refreshUser() async{
    Userdata user= await _authMethods.getUserDetails();
    _user=user;
    notifyListeners();
  }
}