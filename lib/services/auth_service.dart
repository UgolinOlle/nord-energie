import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/utils/constants.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  Future<UserModel> loginWithToken(String jwt) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/auth/login_token');
    Map<String, dynamic> body = {
      "token": jwt,
    };

    var response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      return UserModel.fromJson(decodedJson);
    } else {
      throw Exception('Failed to login with token');
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      var url = Uri.parse('${ApiConstants.baseUrl}/auth/login');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'email': email,
            'password': password,
          },
        ),
      );

      if (response.statusCode == HttpStatus.created) {
        final jsonResponse = json.decode(response.body);

        // -- Write JWT in secure storage
        await storage.write(
            key: 'accessToken', value: jsonResponse['accessToken']);

        Map<String, dynamic> decodedToken =
            JwtDecoder.decode(jsonResponse['accessToken']);
        decodedToken.remove('iat');
        decodedToken.remove('exp');

        return {
          'accessToken': jsonResponse['accessToken'],
          'user': decodedToken
        };
      }
    } catch (e) {
      throw Exception('Failed to login.');
    }
  }
}
