import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mobile/models/intervention_model.dart';
import 'package:mobile/utils/constants.dart';

class InterventionService {
  final storage = const FlutterSecureStorage();

  // -- Actions
  Future<InterventionModel> create(InterventionModel intervention) async {
    try {
      var url = Uri.parse('${ApiConstants.baseUrl}/intervention');
      var jwt = await storage.read(key: 'accessToken');

      final Map<String, dynamic> body = {
        'title': intervention.title,
        'description': intervention.description,
        'date': intervention.date,
        'address': intervention.address,
        'clientName': intervention.clientName,
        'status': intervention.status,
        'user': intervention.user,
      };

      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': 'application/json',
        },
      );

      final InterventionModel data =
          InterventionModel.fromJson(jsonDecode(response.body.toString()));
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<InterventionModel> update(
      String id, InterventionModel intervention) async {
    try {
      var url = Uri.parse('${ApiConstants.baseUrl}/intervention/$id');
      var jwt = await storage.read(key: 'accessToken');

      final Map<String, dynamic> body = {
        'title': intervention.title,
        'description': intervention.description,
        'date': intervention.date,
        'address': intervention.address,
        'clientName': intervention.clientName,
        'status': intervention.status,
        'user': intervention.user,
      };

      final response = await http.put(
        url,
        body: jsonEncode(body),
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': 'application/json',
        },
      );

      final InterventionModel data =
          InterventionModel.fromJson(jsonDecode(response.body.toString()));
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> delete(String id) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/intervention/$id');
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
      throw Exception('Error on delete intervention for $id');
    }
  }

  Future<void> sendImage(String id, File image) async {
    var url = Uri.parse("${ApiConstants.baseUrl}/intervention/upload/$id");
    var jwt = await storage.read(key: 'accessToken');

    final request = http.MultipartRequest('POST', url);
    final fileStream = http.ByteStream(image.openRead());
    final length = await image.length();

    final multipartFile = http.MultipartFile(
      'file',
      fileStream,
      length,
      filename: image.path.split('/').last,
    );

    request.files.add(multipartFile);
    request.headers.addAll({'Authorization': 'Bearer $jwt'});
    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to upload image');
    }
  }

  Future<InterventionModel> deletePicture(String id) async {
    try {
      var url =
          Uri.parse('${ApiConstants.baseUrl}/intervention/remove_picture/$id');
      var jwt = await storage.read(key: 'accessToken');

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': 'application/json',
        },
      );

      final InterventionModel data =
          InterventionModel.fromJson(jsonDecode(response.body.toString()));
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> addNote(String id, String content) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/intervention/note/$id');
    var jwt = await storage.read(key: 'accessToken');

    final Map<String, dynamic> body = {'text': content};

    final response = await http.post(
      url,
      body: body,
      headers: {
        'Authorization': 'Bearer $jwt',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Cannot create note to $id');
    }

    return true;
  }

  Future<InterventionModel> archive(String id) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/intervention/archive/$id');
    var jwt = await storage.read(key: 'accessToken');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $jwt',
      },
    );

    final InterventionModel data =
        InterventionModel.fromJson(jsonDecode(response.body.toString()));
    return data;
  }

  // -- Getter
  Future<List<InterventionModel>> getAll() async {
    var url = Uri.parse('${ApiConstants.baseUrl}/intervention');
    var jwt = await storage.read(key: 'accessToken');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $jwt',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<InterventionModel> interventions = data
          .map((intervention) => InterventionModel.fromJson(intervention))
          .toList();

      return interventions;
    } else {
      throw Exception('Failed to load interventions');
    }
  }

  Future<InterventionModel> getById(String id) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/intervention/$id');
    var jwt = await storage.read(key: 'accessToken');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwt',
      },
    );

    final InterventionModel data =
        InterventionModel.fromJson(jsonDecode(response.body));
    return data;
  }

  Future<List<InterventionModel>> getInterventionsByUserId(String id) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/intervention/user/$id');
    var jwt = await storage.read(key: 'accessToken');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwt',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<InterventionModel> interventions = data
          .map((intervention) => InterventionModel.fromJson(intervention))
          .toList();

      return interventions;
    } else {
      throw Exception('Failed to load interventions by user id');
    }
  }
}
