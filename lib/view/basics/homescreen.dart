import 'dart:async';
import 'package:attendence_geofence/view/screens/useradminscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../app_constants/appconstants.dart';


class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Timer(
    //   const Duration(seconds: 3),
    //       () async {
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     var isLogin = prefs.getBool(AppConstants.isLogin);
    //     print(isLogin);
    //     if (!mounted) return;
    //     if (isLogin == null) {
    //       AppConstants.pageTransition(context,   LoginScreen());
    //     } else if (isLogin) {
    //       AppConstants.pageTransition(context, const  DashBoardScreen());
    //     } else {
    //       AppConstants.pageTransition(context, const  LoginScreen());
    //     }
    //   },
    // );
    Timer(const Duration(seconds: 3), () async{
      AppConstants.pageTransition(context, UserScreen());
    }
    );

  }
  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      backgroundColor: Color(0xff9a8ec4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Geofence Attendance\nApplication',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 15),
            SpinKitFadingCircle(color: Colors.white, size: 36)
            //SpinKitSpinningLines(color: Colors.white, size: 36),
            //SpinKitSpinningLines(color: color)
          ],
        ),
      ),

    );
  }
}
