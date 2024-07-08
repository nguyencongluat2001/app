import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:haiduong_sipas/services/change_password_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordController with ChangeNotifier {
  ChangePasswordService changePasswordService = ChangePasswordService();
  String _password = '';
  String _newPassword01 = '';
  String _newPassword02 = '';

  Future<void> updatePassword(context) async {
    EasyLoading.show(status: 'Đang tải...');
    final prefs = await SharedPreferences.getInstance();
    String? userInfor = prefs.getString('user_infor');
    // Parse the JSON string into a map
    Map<String, dynamic> userMap = jsonDecode(userInfor ?? "");

    // Access the "id" field from the map
    String? userId = userMap['id'];

    Map<String, dynamic> body = {
      'id': userId,
      'password': _password,
      'newPass01': _newPassword01,
      'newPass02': _newPassword02
    };

    changePasswordService.call(body).then((response) {
      EasyLoading.dismiss();
      if (response.status) {
        EasyLoading.showSuccess(response.message);
        Navigator.pop(context);
      } else {
        EasyLoading.showError(response.message);
      }
    });
  }

  set password(value) {
    _password = value;
  }

  set newPassword01(value) {
    _newPassword01 = value;
  }

  set newPassword02(value) {
    _newPassword02 = value;
  }
}
