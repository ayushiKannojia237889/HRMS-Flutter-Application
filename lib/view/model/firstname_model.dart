import 'dart:convert';

FirstNameModel firstNameModelFromJson(String str) => FirstNameModel.fromJson(json.decode(str));

String firstNameModelToJson(FirstNameModel data) => json.encode(data.toJson());

class FirstNameModel {
  List<Datum> data;
  int totalRecords;
  String message;
  bool status;

  FirstNameModel({
    required this.data,
    required this.totalRecords,
    required this.message,
    required this.status,
  });

  factory FirstNameModel.fromJson(Map<String, dynamic> json) => FirstNameModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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

class Datum {
  String firstName;
  String toLowerCase(){
    return firstName.toLowerCase();
  }

  Datum({
    required this.firstName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    firstName: json["first_name"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
  };
}

class FirstNameModelResponse {
  static List<Datum> list = [];
}
