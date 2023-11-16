import 'dart:convert';

AttendanceLoginDetailModel AttendanceLoginDetailModelFromJson(String str) => AttendanceLoginDetailModel.fromJson(json.decode(str));

String AttendanceLoginDetailModelJson(AttendanceLoginDetailModel data) => json.encode(data.toJson());

class AttendanceLoginDetailModel {
  List<DatumMobileno> data;
  int totalRecords;
  String message;
  bool status;

  AttendanceLoginDetailModel({
    required this.data,
    required this.totalRecords,
    required this.message,
    required this.status,
  });

  factory AttendanceLoginDetailModel.fromJson(Map<String, dynamic> json) => AttendanceLoginDetailModel(
    data: List<DatumMobileno>.from(json["data"].map((x) => DatumMobileno.fromJson(x))),
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

class DatumMobileno{
  String firstName;
  String mobileno;


  DatumMobileno({
    required this.firstName,
    required this.mobileno,
  });

  factory DatumMobileno.fromJson(Map<String, dynamic> json) =>DatumMobileno(
      firstName: json["first_name"],
      mobileno: json["mobileno"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "mobileno": mobileno,
  };
}


class AttendanceLoginDetailModelResponse {
  static List<DatumMobileno> list = [];
}
