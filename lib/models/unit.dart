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
    this.unitname,
    this. noofrooms,
    this.nooftoilets,
    this.noofkitchens,
    this.floor,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? unitname;
  int? noofrooms;
  int? nooftoilets;
  int? noofkitchens;
  Floor? floor;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["_id"],
        unitname: json["unitname"],
        noofrooms:json ["noofrooms"],
        nooftoilets: json["nooftoilets"],
        noofkitchens: json["noofkitchens"],
        floor: Floor(
          id: json['floor']['_id'],
          name: json['floor']['name'],
          noOfUnits: json['apartment']['noOfFloors'],
          
        ),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
  Map<String, dynamic> toJson() => {
        "_id": id,
        "unitname": unitname,
        "nofrooms": noofrooms,
        "nooftoilets": nooftoilets,
        "noofkitchens": noofkitchens,
        "floor": floor!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
