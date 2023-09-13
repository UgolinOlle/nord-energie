import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:mobile/models/user_model.dart';
import 'package:mobile/utils/constants.dart';

class UserService {
  final storage = FlutterSecureStorage();

  // -- Actions
  Future<UserModel> create(UserModel user, String password) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/user/signup');
    var jwt = await storage.read(key: 'accessToken');

    final Map<String, dynamic> body = {
      'email': user.email,
      'password': password,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'phone': user.phone,
      'role': user.role,
    };

    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Authorization': 'Bearer $jwt',
        'Content-Type': 'application/json',
      },
    );

    final UserModel data =
        UserModel.fromJson(jsonDecode(response.body.toString()));
    return data;
  }

  Future<UserModel> update(String id, UserModel user) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/user/$id');
    var jwt = await storage.read(key: 'accessToken');

    final Map<String, dynamic> body = {
      'firstName': user.firstName,
      'lastName': user.lastName,
      'phone': user.phone,
      'role': user.role,
    };

    final response = await http.put(
      url,
      body: jsonEncode(body),
      headers: {
        'Authorization': 'Bearer $jwt',
        'Content-Type': 'application/json',
      },
    );

    final UserModel data =
        UserModel.fromJson(jsonDecode(response.body.toString()));
    return data;
  }

  Future<String> delete(String id) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/user/$id');
    var jwt = await storage.read(key: 'accessToken');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $jwt',
      },
    );

    if (response.statusCode == 200) {
      return id;
    } else {
      throw Exception('Error on delete user: $id');
    }
  }

  // -- Getters
  Future<List<UserModel>> getAllUsers() async {
    var url = Uri.parse('${ApiConstants.baseUrl}/user');
    var jwt = await storage.read(key: 'accessToken');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $jwt',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<UserModel> users =
          data.map((user) => UserModel.fromJson(user)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<UserModel> getUserById(String userId) async {
    try {
      var url = Uri.parse('${ApiConstants.baseUrl}/user/$userId');
      var jwt = await storage.read(key: 'accessToken');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $jwt',
      });

      final userData = json.decode(response.body) as Map<String, dynamic>;
      return UserModel.fromJson(userData);
    } catch (error) {
      throw const HttpException('Could not fetch user.');
    }
  }
}
