import 'package:flutter/material.dart';

class HomeController with ChangeNotifier {

  String getLabelFromIndex(int index) {
    var label = "Trang chủ";
    if (index == 2) {
      label = "Tài khoản";
    } else if (index == 1) {
      label = "Thông báo";
    }
    return label;
  }
}
