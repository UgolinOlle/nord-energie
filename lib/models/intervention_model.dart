import 'dart:convert';

import 'package:mobile/models/note_model.dart';
import 'package:mobile/models/user_model.dart';

List<InterventionModel> userModelFromJson(String str) =>
    List<InterventionModel>.from(
        json.decode(str).map((x) => InterventionModel.fromJson(x)));

String userModelToJson(List<InterventionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InterventionModel {
  final String? id;
  final String? createdAt;
  final String title;
  final String description;
  final String? date;
  final String? address;
  final String? clientName;
  final String? clientPhone;
  final String? picture;
  final List<Note> notes;
  final String status;
  final UserModel? user;
  final bool? archived;

  InterventionModel({
    this.id,
    this.createdAt,
    required this.title,
    required this.description,
    this.date,
    this.address,
    this.clientName,
    this.clientPhone,
    this.picture,
    required this.notes,
    required this.status,
    this.user,
    this.archived,
  });

  factory InterventionModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> notesJson = json['notes'] ?? [];
    final notes = notesJson.map((noteJson) => Note.fromJson(noteJson)).toList();
    return InterventionModel(
      id: json['id'],
      createdAt: json['createdAt'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      address: json['address'],
      clientName: json['clientName'],
      picture: json['picture'],
      notes: notes,
      status: json['status'],
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : UserModel(
              id: '',
              email: '',
              firstName: '',
              lastName: '',
              phone: '',
              role: '',
              interventions: [],
            ),
      archived: json['archived'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['title'] = title;
    data['description'] = description;
    data['date'] = date;
    data['address'] = address;
    data['clientName'] = clientName;
    data['picture'] = picture;
    data['notes'] = notes.map((note) => note.toJson()).toList();
    data['status'] = status;
    data['user'] = user?.toJson();
    data['archived'] = archived;

    return data;
  }
}
