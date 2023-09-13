import 'dart:convert';

import 'package:mobile/models/intervention_model.dart';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  final String? id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String role;
  final List<InterventionModel> interventions;

  UserModel({
    this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.role,
    required this.interventions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      role: json['role'],
      interventions: json['interventions'] != null
          ? List<InterventionModel>.from(
              json['interventions'].map((x) => InterventionModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "role": role,
        "interventions":
            List<dynamic>.from(interventions.map((x) => x.toJson())),
      };
}
