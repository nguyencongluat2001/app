import 'dart:convert';
import 'package:haiduong_sipas/config/app_config.dart';
import 'package:haiduong_sipas/responses/base_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordService {
  Future<BaseResponse> call(body) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    var response =
        await http.post(Uri.parse('${AppConfig.baseUrl}/app/change_password'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body));
    return BaseResponse.fromJson(jsonDecode(response.body));
  }
}
