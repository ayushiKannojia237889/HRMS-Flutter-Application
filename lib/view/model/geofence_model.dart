import 'dart:convert';

GeofenceModel GeofenceModelFromJson(String str) => GeofenceModel.fromJson(json.decode(str));

String GeofenceModelToJson(GeofenceModel data) => json.encode(data.toJson());

class GeofenceModel {
  List<Datum1> data;
  int totalRecords;
  String message;
  bool status;

  GeofenceModel({
    required this.data,
    required this.totalRecords,
    required this.message,
    required this.status,
  });

  factory GeofenceModel.fromJson(Map<String, dynamic> json) => GeofenceModel(
    data: List<Datum1>.from(json["data"].map((x) => Datum1.fromJson(x))),
    totalRecords: json["total_records"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "total_records": totalRecords,
    "message": message,
    "status": status,
  };
}

class Datum1 {
  String value5;
  int id;

  Datum1({
    required this.value5,
    required this.id
  });

  factory Datum1.fromJson(Map<String, dynamic> json) => Datum1(
    value5: json["value5"],
    id: json["id"]
  );

  Map<String, dynamic> toJson() => {
    "value5": value5,
    "id": id
  };
}


class GeofenceModelResponse {
  static List<Datum1> list = [];
}
