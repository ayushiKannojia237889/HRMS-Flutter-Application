import 'dart:convert';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:attendence_geofence/view/basics/dashboardscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../app_constants/appconstants.dart';


class AttendanceService{
  static Future attendUser(
      BuildContext context,
      String first_name,
      String mobileno,
     // String month,
      // String time,
      // String date,
      String present,
      String imageBase64

      ) async {
    var uri = "${AppConstants.baseURL}insertRecordAttendance";
    var postURL = Uri.parse(uri);

    Map<String, String> body = {
      "first_name": first_name,
      "mobileno" : mobileno,
     // "month":month,
      // "time": time,
      // "date" : date,
      "present": present,
      "image": imageBase64,
    };

    try {
      var response = await http.post(
        postURL,
        body: jsonEncode(body),
        headers: {'Content-Type': 'Application/JSON'},
      );

      var jsonData = jsonDecode(response.body);
      print(jsonData);
      if (jsonData["status"] == true) {
        Future.delayed(
          const Duration(milliseconds: 100),
              () {
                // AppConstants.showSnackBar(context,
                //     "Attendance Punched Sucessfully", Colors.green);
                attendancePunchedFullyDialog(context);
          },
        );
      }
      else {
        Future.delayed(
          const Duration(milliseconds: 200),
              () {
            AppConstants.showSnackBar(context,
                "Failed to insert data. ${jsonData["message"]}.", Colors.red);
          },
        );
      }
    }
    catch (e) {
      Future.delayed(
        const Duration(milliseconds: 200),
            () {
          AppConstants.showSnackBar(
              context, "Failed to insert data due to $e.", Colors.red);
        },
      );
    }
  }
  static Future<Object?> attendancePunchedFullyDialog(
      BuildContext context) {
    return ArtSweetAlert.show(
      context: context,
      barrierDismissible: false,
      artDialogArgs: ArtDialogArgs(
        onConfirm: () {
          AppConstants.pageTransition(context, const DashBoardScreen());
        },
        confirmButtonColor: Colors.green,
        confirmButtonText: 'OK',
        type: ArtSweetAlertType.success,
        title: "Attendance punched successfully.",
      ),
    );
  }
}