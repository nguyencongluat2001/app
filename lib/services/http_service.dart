import 'dart:convert';

import 'package:haiduong_sipas/config/app_config.dart';
import 'package:haiduong_sipas/responses/base_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart' as parser;

class HttpService {
  Uri getUrl(String url) => Uri.parse('${AppConfig.baseUrl}/$url');

  Future<BaseResponse> get(String apiUrl) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    print(getUrl(apiUrl));
    try {
      var url = getUrl(apiUrl);
      final response = await UrlRequest(token).get(url);
      return BaseResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<BaseResponse> post(String apiUrl, Map<String, dynamic>? body) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    try {
      print(getUrl(apiUrl));
      print(jsonEncode(body));
      final response =
          await UrlRequest(token).post(getUrl(apiUrl), body: jsonEncode(body));
      return BaseResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> upload(
      String apiUrl, String fieldName, String path) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    try {
      final client = http.MultipartRequest('POST', getUrl(apiUrl));
      if (token != null) {
        client.headers.addAll({'Authorization': 'Bearer $token'});
      }
      client.files.add(await http.MultipartFile.fromPath(fieldName, path,
          contentType: parser.MediaType('image', 'm4a')));

      return _handleResponse(
          await http.Response.fromStream(await client.send()));
    } catch (e) {
      throw Exception(e);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      //todo add error handling
      throw Exception();
    }
  }
}

class UrlRequest extends http.BaseClient {
  final String? token;

  UrlRequest([this.token]);
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'application/json; charset=UTF-8';
    }
    return request.send();
  }
}
