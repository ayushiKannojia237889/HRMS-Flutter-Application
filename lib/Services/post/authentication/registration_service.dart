import 'dart:convert';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:attendence_geofence/view/basics/dashboardscreen.dart';
import 'package:attendence_geofence/view/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../app_constants/appconstants.dart';


class RegistrationService {
  static Future createUser(
      BuildContext context,
      String first_name,
      String division,
      String post_designation,
      String mobileno,
      String email_id,
      String imageBase64,
      //String password,
      String pin
      ) async {
    var uri = "${AppConstants.baseURL}insertRecordRegistration";
    var postURL = Uri.parse(uri);

    Map<String, String> body = {
      "first_name": first_name,
      "division": division,
      "post_designation": post_designation,
      "mobileno": mobileno,
      "email_id": email_id,
      "image": imageBase64,
      "pin":pin,

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
            userRegisteredSuccessfullyDialog(context);
          },
        );
      } else {
        Future.delayed(
          const Duration(milliseconds: 200),
              () {
            AppConstants.showSnackBar(context,
                "Failed to insert data. ${jsonData["message"]}.", Colors.red);
          },
        );
      }
    } catch (e) {
      Future.delayed(
        const Duration(milliseconds: 200),
            () {
          AppConstants.showSnackBar(
              context, "Failed to insert data due to $e.", Colors.red);
        },
      );
    }
  }

  static Future<Object?> userRegisteredSuccessfullyDialog(
      BuildContext context) {
    return ArtSweetAlert.show(
      context: context,
      barrierDismissible: false,
      artDialogArgs: ArtDialogArgs(
        onConfirm: () {
          AppConstants.pageTransition(context, const LoginScreen());
        },
        confirmButtonColor: Colors.green,
        confirmButtonText: 'OK',
        type: ArtSweetAlertType.success,
        title: "User registered successfully.",
      ),
    );
  }
}
