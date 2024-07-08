import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:haiduong_sipas/config/app_config.dart';
import 'package:haiduong_sipas/services/http_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VoteController with ChangeNotifier {
  // ignore: prefer_typing_uninitialized_variables
  var voteList;
  var search = '';
  String? fromDate;
  String? toDate;
  var unitCode = '';
  late int tabIndex = 0;
  dynamic listtype = {};
  HttpService httpService = HttpService();

  Future<void> voteDelete(context, data) async {
    EasyLoading.show(status: 'Đang tải...');
    Map<String, dynamic> body = {
      'ids': data['id'],
    };
    return httpService.post("app/voteDelete", body).then((response) async {
      EasyLoading.dismiss();
      Navigator.of(context).pushNamed('home');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xóa thành công.'),
        ),
      );
      return response.data;
    });
  }

  String getFileNameUpload() {
    int length = 20;
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random.secure();
    List<String> result =
        List.generate(length, (index) => chars[random.nextInt(chars.length)]);
    return "${result.join()}.m4a";
  }

  //final String filePath = '/data/user/0/com.efy.haiduong_sipas/cache/audio8853755631194792503.m4a'; // Replace with your file path
  Future<void> uploadFile(filePath, filename) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final url = Uri.parse(
        '${AppConfig.baseUrl}/app/uploadFile'); // Replace with your server's upload endpoint URL

    final file = File(filePath);

    if (!file.existsSync()) {
      return;
    }
    final request = http.MultipartRequest('POST', url)
      ..files.add(
        http.MultipartFile(
          'audio',
          file.openRead(),
          file.lengthSync(),
          filename: filename,
        ),
      );

    // Add your headers here
    request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();

    if (response.statusCode == 200) {
      // Successfully uploaded the file
    } else {
      // Handle the error

      // If there's a response body, you can also print it
      if (response.contentLength != 0) {
        final responseBody = await response.stream.bytesToString();
      }
    }
  }

  Future<bool> voteUpdate(context, body) async {
    final prefs = await SharedPreferences.getInstance();
    String? userInfor = prefs.getString('user_infor');
    var geodeticCoordinate = {};
    geodeticCoordinate['latitude'] = prefs.getString('latitude');
    geodeticCoordinate['longitude'] = prefs.getString('longitude');
    body['geodetic_coordinate'] = geodeticCoordinate;
    dynamic user = json.decode(userInfor!);
    body['user_id'] = user['id'];
    EasyLoading.show(status: 'Đang tải...');
    print(body);
    return httpService.post("app/voteUpdate", body).then((response) async {
      EasyLoading.dismiss();
      if (response.status == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cập nhật thành công.'),
          ),
        );
        Navigator.of(context).pushNamed('home');
        return true;
      } else {
        Timer? timer;
        // ignore: dead_code
        timer?.cancel();
        EasyLoading.showError(response.message);
        return false;
      }
    });
  }

  Future<List<dynamic>> getServicesByUnitCode(String unitCode) async {
    EasyLoading.show(status: 'Đang tải...');
    return httpService
        .get("app/votesipas/getDVHHC?code=$unitCode")
        .then((response) async {
      EasyLoading.dismiss();
      return response.data;
    });
  }
  Future<List<dynamic>> getArrPX(String code) async {
    EasyLoading.show(status: 'Đang tải...');
    return httpService
    //  .get("app/votesipas/getDVHHC?code=s00")
        .get("app/getUnitPX?madanhmuc=$code")
        .then((response) async {
      EasyLoading.dismiss();
      return response.data;
    });
  }
   Future<List<dynamic>> getArrPX_edit(String id) async {
    EasyLoading.show(status: 'Đang tải...');
    return httpService
    //  .get("app/votesipas/getDVHHC?code=s00")
        .get("app/getUnitPX_edit?id=$id")
        .then((response) async {
      EasyLoading.dismiss();
      return response.data;
    });
  }

  Future<List<dynamic>> getAllQuestion(dynamic voteTab, String idVote) async {
    EasyLoading.show(status: 'Đang tải...');

    // ignore: unused_local_variable
    var group = 'SO_NGANH';
    if (voteTab == '1') {
      group = 'QUAN_HUYEN';
    }
    Map<String, dynamic> body = {};
    if (isUUID(idVote)) {
      body = {
        'id': idVote,
      };
    } else {
      body = {
        'type_unit': group,
      };
    }
    return httpService.post("app/listQuestion", body).then((response) async {
      EasyLoading.dismiss();
      return response.data;
    });
  }

  bool isUUID(String value) {
    final uuidPattern = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    return uuidPattern.hasMatch(value);
  }

  Future<List<dynamic>> getAll(widget, int voteTab) async {
    final prefs = await SharedPreferences.getInstance();
    String? userInfor = prefs.getString('user_infor');
    dynamic user = json.decode(userInfor!);
    var group = 'QUAN_HUYEN';
    if (voteTab == 0) {
      group = 'SO_NGANH';
    }
    EasyLoading.show(status: 'Đang tải...');
    Map<String, dynamic> body = {
      'level_unit': group,
      'search': search,
      'fromDate': fromDate,
      'toDate': toDate,
      //'unitCode': unitCode,
      'user_id': user['id']
    }; 
    print(body);
    return httpService.post("app/voteList", body).then((response) async {
      EasyLoading.dismiss();
      widget.callback(voteTab, response.data.length);
      return response.data;
    });
  }
}
