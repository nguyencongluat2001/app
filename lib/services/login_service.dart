import 'dart:convert';
import 'package:haiduong_sipas/config/app_config.dart';
import 'package:haiduong_sipas/responses/base_response.dart';
import 'package:http/http.dart' as http;

class LoginService {
  Future<BaseResponse> call(body) async {
    var response =
        await http.post(Uri.parse('${AppConfig.baseUrl}/loginMobile'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(body));
    return BaseResponse.fromJson(jsonDecode(response.body));
  }
}
