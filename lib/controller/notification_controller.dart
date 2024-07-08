import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:haiduong_sipas/services/http_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController with ChangeNotifier {

  HttpService httpService = HttpService();

  Future<List<dynamic>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    String? userInfor = prefs.getString('user_infor');
    dynamic user = json.decode(userInfor!);
    EasyLoading.show(status: 'Đang tải...');
    Map<String, dynamic> body = {
      'user_id': user['id']
    };
    return httpService.post("app/notification", body).then((response) async {
      EasyLoading.dismiss();
      return response.data;
    });
  }

}