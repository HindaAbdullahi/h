// To parse this JSON data, do
//
//     final apartment = apartmentFromJson(jsonString);

import 'dart:convert';

List<Apartment> apartmentFromJson(String str) => List<Apartment>.from(json.decode(str).map((x) => Apartment.fromJson(x)));

String apartmentToJson(List<Apartment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Apartment {
    Apartment({
        this.id,
        this.name,
        this.noOfFloors,
        this.address,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    String? id;
    String? name;
    int? noOfFloors;
    String? address;
    String? status;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory Apartment.fromJson(Map<String, dynamic> json) => Apartment(
        id: json["_id"],
        name: json["name"],
        noOfFloors: json["noOfFloors"],
        address: json["address"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "noOfFloors": noOfFloors,
        "address": address,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}