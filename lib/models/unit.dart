// To parse this JSON data, do
//
//     final floor = floorFromJson(jsonString);

import 'dart:convert';

import 'package:pmsmbileapp/models/floor.dart';

List<Unit> unitFromJson(String str) =>
    List<Unit>.from(json.decode(str).map((x) => Unit.fromJson(x)));

String unitToJson(List<Unit> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Unit {
  Unit({
    this.id,
    this.name,
    this.floor,
    this.noOfRooms,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? name;
  Floor? floor;
  int? noOfRooms;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["_id"],
        name: json["name"],
        floor: Floor(
          id: json['floor']['_id'],
          name: json['floor']['name'],
        ),
        noOfRooms: json["noOfRooms"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "floor": floor!.toJson(),
        "noOfRooms": noOfRooms,
        "status": status,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}