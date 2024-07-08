import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:haiduong_sipas/controller/vote_controller.dart';
import 'package:haiduong_sipas/models/app_model.dart';
import 'package:haiduong_sipas/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class LoginController with ChangeNotifier {
  LoginService loginService = LoginService();
  VoteController voteController = VoteController();

  String username = '';
  String password = '';

  Future<void> login(context) async {
    final appModel = Provider.of<AppModel>(context, listen: false);
    EasyLoading.show(status: 'Đang tải...');
    if (username.isEmpty || password.isEmpty) {
      appModel.logined = false;
      EasyLoading.showError('Tên đăng nhập hoặc mật khẩu không được để trống');
    } else {
      Map<String, dynamic> body = {'username': username, 'password': password};
      return loginService.call(body).then((response) async {
        EasyLoading.dismiss();
        if (response.status) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', response.data['access_token']);
          await prefs.setString(
              'user_infor', json.encode(response.data['user_infor']));
          await prefs.setInt('totalDepartment',
              response.data['notification']['totalDepartment']);
          await prefs.setInt(
              'totalDistrict', response.data['notification']['totalDistrict']);
          appModel.setListtype(response.data['listtype']);
          Navigator.of(context).pushNamed('home');
        } else {
          appModel.logined = false;
          EasyLoading.showError('Tên đăng nhập hoặc mật khẩu không đúng!');
        }
      });
    }
  }
}
