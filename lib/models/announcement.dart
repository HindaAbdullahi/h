// To parse this JSON data, do
//
//     final floor = floorFromJson(jsonString);

import 'dart:convert';


import 'package:pmsmbileapp/models/user.dart';
List<Anouncement> anouncementFromJson(String str) =>
    List<Anouncement>.from(json.decode(str).map((x) => Anouncement.fromJson(x)));

String anouncementToJson(List<Anouncement> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Anouncement {
  Anouncement({
    this.id,
    this.name,
  required  this.user,
   required this.message,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? name;
  User? user;
  String? message;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

 factory Anouncement.fromJson(Map<String, dynamic> json) => Anouncement(
        id: json["_id"],
        name: json["name"],
        user: User(
          id: json['user']['_id'],
          name: json['user']['name'],
          email: json ['user']['email'],
          createdAt: json['user ']['createdAt '],
          updatedAt: json ['user '][ 'updatedAt ' ],
        ),
        message: json["message"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "user": user!.toJson(),
        "message": message,
        "status": status,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
