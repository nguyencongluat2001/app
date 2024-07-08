import 'dart:core';

import 'package:flutter/material.dart';

class AppModel with ChangeNotifier {
  var logined = false;
  var accessToken = '';
  var user = {};
  var unit = {};
  // Lưu dữ liệu phiếu
  var dataVote = {};
  var _dataAnswer = {};
  dynamic get dataAnswer => _dataAnswer;
  var listtype = {};
  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  dynamic questionsSN = [];
  dynamic questionsQH = [];

  AppModel() {
    reset();
  }

  void setTabindex(tabIndex) {
    _tabIndex = tabIndex;
  }

  void setListtype(data) {
    listtype = data;
  }

  void setGeodeticCoordinate(latitude, longitude) {
    var geodetic_coordinate = {};
    geodetic_coordinate['latitude'] = latitude;
    geodetic_coordinate['longitude'] = longitude;
    dataVote['geodetic_coordinate'] = geodetic_coordinate;
  }

  dynamic getQuestion(tabIndex) {
    if (tabIndex == 0) {
      return questionsSN;
    }
    return questionsQH;
  }

  void setQuestionSN(question) {
    questionsSN = question;
  }

  void setQuestionQH(question) {
    questionsQH = question;
  }

  void setVote(String value, String keyInput) {
    dataVote[keyInput] = value;
  }

  dynamic getVote(String keyInput) {
    return dataVote[keyInput];
  }

  dynamic getAnswer(String id) {
    return _dataAnswer[id];
  }

  void setAnswer(String id, String value) {
    _dataAnswer[id] = value;
  }
  void setAnswerCheckBox(String id, String value) {
    _dataAnswer[id] = value;
  }

  reset() {
    Map<String, dynamic> dynamicMap = {};
    dynamicMap['id'] = "";
    dynamicMap['survey_sipas_id'] = "";
    dynamicMap['code'] = "";
    dynamicMap['unit'] = "";
    dynamicMap['unit_quan_huyen'] = "";
    dynamicMap['quan_huyen'] = "";
    dynamicMap['phuong_xa'] = "";
    dynamicMap['thon_xom'] = "";
    dynamicMap['administrative_service'] = "";
    dynamicMap['phone'] = "";
    dynamicMap['phone_reply'] = "";
    dynamicMap['level_unit'] = "";
    dynamicMap['sex'] = "";
    dynamicMap['name_unit'] = "";
    dynamicMap['name_investigator'] = "";
    dynamicMap['survey_form'] = "";
    dynamicMap['age'] = "";
    dynamicMap['nation'] = "";
    dynamicMap['education'] = "";
    dynamicMap['job'] = "";
    dynamicMap['address'] = "";
    dynamicMap['address_region'] = "";
    dynamicMap['address_region_other'] = "";
    dynamicMap['address_survey'] = "";
    dynamicMap['geodetic_coordinate'] = "";
    dynamicMap['nation_other'] = "";
    dynamicMap['education_other'] = "";
    dynamicMap['job_other'] = "";
    dynamicMap['address_other'] = "";
    dynamicMap['created_at'] = "";
    dataVote = dynamicMap;
    _dataAnswer = {};
    questionsSN = [];
    questionsQH = [];
  }
}
