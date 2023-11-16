import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class AppConstants{
  static const String appName = 'Geofence Attendance Application ';

  static String baseURL =
      //"http://14.139.43.115:8090/geofenceapi/";
      "http://192.168.105.181:8585/";

  // SHARED PREFERENCES KEYS
  static const String isLogin = 'isLogin';
  static const String isLoginAdmin = 'isLoginAdmin';

  static const String name = 'name';
  static const String mobileno = 'mobileno';

  static const String latitude = 'latitude';
  static const String longitude = 'longitude';



  //SNACK BAR METHOD
  static showSnackBar(BuildContext context, String msg, Color color) {
    final snackBar = SnackBar(
     // duration: Duration(milliseconds: 1),
      content: Text(
        msg,
        style: TextStyle(
          fontFamily: GoogleFonts.beVietnamPro().fontFamily,
        ),
      ),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //PAGE TRANSITION METHOD
  static pageTransition(BuildContext context, Widget child) {
    Navigator.pushReplacement(
      context,
      PageTransition(type: PageTransitionType.bottomToTop, child: child),
    );
  }

  static Future<Object?> successSubmitDialog(BuildContext context) {
    return ArtSweetAlert.show(
      context: context,
      barrierDismissible: false,
      artDialogArgs: ArtDialogArgs(
        onConfirm: () {
          //AppConstants.pageTransition(context, const DashBoardScreen());
        },
        confirmButtonColor: Colors.green,
        confirmButtonText: 'OK',
        type: ArtSweetAlertType.success,
        title: "Data inserted successfully.",
      ),
    );
  }


}