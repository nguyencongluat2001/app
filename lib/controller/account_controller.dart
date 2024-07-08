import 'package:flutter/material.dart';
import 'package:haiduong_sipas/services/http_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AccountController with ChangeNotifier {

  HttpService httpService = HttpService();

  Future<dynamic> getUser() async {
     final prefs = await SharedPreferences.getInstance();
    String? userInfor = prefs.getString('user_infor');
  
    dynamic user = json.decode(userInfor!);
    return user;
  }

}