import 'dart:convert';

UserDetailModel UserDetailModelFromJson(String str) => UserDetailModel.fromJson(json.decode(str));

String UserDetailModelJson(UserDetailModel data) => json.encode(data.toJson());

class UserDetailModel {
  List<DatumValue> data;
  int totalRecords;
  String message;
  bool status;

  UserDetailModel({
    required this.data,
    required this.totalRecords,
    required this.message,
    required this.status,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) => UserDetailModel(
    data: List<DatumValue>.from(json["data"].map((x) => DatumValue.fromJson(x))),
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

class DatumValue {
  String date_n;
  String time_n;
  String present;

  DatumValue({
    required this.date_n,
    required this.time_n,
    required this.present,

  });

  factory DatumValue.fromJson(Map<String, dynamic> json) =>DatumValue(
      date_n: json["date_n"] ,
      time_n: json["time_n"],
      present: json["present"],

  );

  Map<String, dynamic> toJson() => {
    "date_n": date_n,
    "time_n": time_n,
    "present": present,


  };
}


class UserDetailModelResponse {
  static List<DatumValue> list = [];
}
