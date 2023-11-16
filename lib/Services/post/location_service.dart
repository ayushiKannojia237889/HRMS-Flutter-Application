import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../app_constants/appconstants.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import '../../view/basics/dashboardscreen.dart';


class LocationService {
  static Future postUser(
      BuildContext context,
      String location,
      String name,
      String time,
      String mobileno,
      ) async {
    var uri = "${AppConstants.baseURL}employees";
    var postURL = Uri.parse(uri);

    Map<String, String> body = {
      "location": location,
      "name": name,
      "time":time,
      "mobileno" : mobileno,
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
          const Duration(milliseconds: 200),
              () {
            userRegisteredSuccessfullyDialog(context);
          },
        );
       }
        else {
        Future.delayed(
          const Duration(milliseconds: 500),
              () {
            AppConstants.showSnackBar(context,
                " checking your location.", Colors.green);
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

  static Future<Object?> userRegisteredSuccessfullyDialog(
      BuildContext context) {
    return ArtSweetAlert.show(
      context: context,
      barrierDismissible: true,
      artDialogArgs: ArtDialogArgs(
        onConfirm: () {
          AppConstants.pageTransition(context, const DashBoardScreen());
        },
        confirmButtonColor: Colors.green,
        confirmButtonText: 'OK',
        type: ArtSweetAlertType.success,
        title: "User registered successfully.",
      ),
    );
  }
}
