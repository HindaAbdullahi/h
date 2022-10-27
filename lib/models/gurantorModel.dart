// To parse this JSON data, do
//
//     final guarantor = guarantorFromJson(jsonString);

import 'dart:convert';

List<Guarantor> guarantorFromJson(String str) =>
    List<Guarantor>.from(json.decode(str).map((x) => Guarantor.fromJson(x)));

String guarantorToJson(List<Guarantor> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Guarantor {
  Guarantor({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.gender,
    required this.title,
    required this.updatedAt,
  });

  String id;
  String name;
  String phone;
  String address;
  String gender;
  String title;
  DateTime updatedAt;

  factory Guarantor.fromJson(Map<String, dynamic> json) => Guarantor(
        id: json["_id"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        gender: json["gender"],
        title: json["title"],
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "phone": phone,
        "address": address,
        "gender": gender,
        "title": title,
        "updatedAt": updatedAt.toIso8601String(),
      };
}
