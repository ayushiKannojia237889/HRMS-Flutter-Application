import 'dart:convert';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:attendence_geofence/view/basics/dashboardscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../app_constants/appconstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../view/screens/adminscreen.dart';
import '../../../view/screens/attendance_view.dart';


class AdminLoginService {
  static Future AdminLoginUser(
      BuildContext context,
      String mobileno,
      String pin,
      ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var uri = "${AppConstants.baseURL}adminLogin";
    var postURL = Uri.parse(uri);
    print(postURL);

    Map<String, String> body = {
      "mobileno": mobileno,
      "pin": pin,
    };
    print(mobileno);
    try {
      var response = await http.post(
        postURL,
        body: jsonEncode(body),
        headers: {'Content-Type': 'Application/JSON'},
      );
      print(body);
      print(response);
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      if (jsonData["status"] == true) {
        pref.setBool(AppConstants.isLoginAdmin, true);

        AppConstants.showSnackBar(
          context,
          " Admin Logged-in successfully.",
          Colors.green,
        );
        AppConstants.pageTransition(
          context,
          const AttendanceScreen(),
        );
      } else {
        Future.delayed(
          const Duration(milliseconds: 100),
              () {
            AppConstants.showSnackBar(
                context, "${jsonData["message"]}", Colors.red);
          },
        );
      }
    } catch (e) {
      Future.delayed(
        const Duration(milliseconds: 100),
            () {
          AppConstants.showSnackBar(
              context, "Couldn't check user due to $e.", Colors.red);
        },
      );
    }
  }

  static Future<Object?> adminLoginSuccessfullyDialog(BuildContext context) {
    return ArtSweetAlert.show(
      context: context,
      barrierDismissible: false,
      artDialogArgs: ArtDialogArgs(
        onConfirm: () {
          AppConstants.pageTransition(context, const AdminScreenS());
        },
        confirmButtonColor: Colors.green,
        confirmButtonText: 'OK',
        type: ArtSweetAlertType.success,
        title: "your Login successfully.",
      ),
    );
  }
}
