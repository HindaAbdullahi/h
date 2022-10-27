// To parse this JSON data, do
//
//     final floor = floorFromJson(jsonString);

import 'dart:convert';

import 'package:pmsmbileapp/models/apartmrnt.dart';

List<Floor> floorFromJson(String str) =>
    List<Floor>.from(json.decode(str).map((x) => Floor.fromJson(x)));

String floorToJson(List<Floor> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Floor {
  Floor({
    this.id,
    this.name,
    this.apartment,
    this.noOfUnits,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? name;
  Apartment? apartment;
  int? noOfUnits;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Floor.fromJson(Map<String, dynamic> json) => Floor(
        id: json["_id"],
        name: json["name"],
        apartment: Apartment(
          id: json['apartment']['_id'],
          name: json['apartment']['name'],
          noOfFloors: json['apartment']['noOfFloors'],
          address: json['apartment']['address'],
        ),
        noOfUnits: json["noOfUnits"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "apartment": apartment!.toJson(),
        "noOfUnits": noOfUnits,
        "status": status,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
