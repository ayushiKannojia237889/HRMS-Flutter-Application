import 'package:attendence_geofence/view/basics/dashboardscreen.dart';
import 'package:attendence_geofence/view/screens/Map.dart';
import 'package:attendence_geofence/view/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_constants/appconstants.dart';
import 'adminLogin.dart';
import 'attendance_view.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff9a8ec4),
        title: Center(
          child: const Text("Geofence Attendance Application",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back,
        //     color: Colors.white,
        //   ), onPressed: () {
        //   AppConstants.pageTransition(context, const DashBoardScreen());
        // },
        // ),
      ),
      body: Container(
        child:  Stack(
          children: [
            Positioned(
              child: Padding(
                padding: const EdgeInsets.only(left: 130.0,top: 130.0,bottom: 0.0,right: 130.0),
                child: GestureDetector(
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    var isLogin = prefs.getBool(AppConstants.isLogin);
                    print(isLogin);
                    if (!mounted) return;
                    if (isLogin == null) {
                      AppConstants.pageTransition(context,   LoginScreen());
                    } else if (isLogin) {
                      AppConstants.pageTransition(context, const  DashBoardScreen());
                    } else {
                      AppConstants.pageTransition(context, const  LoginScreen());
                    }
                    //AppConstants.pageTransition(context, LoginScreen());
                  },
                  child: SizedBox(
                    height: 150,
                    width: 190,
                    child: Card(
                      color: Color(0xff9a8ec4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 20.0,
                      //shadowColor: Colors.grey.shade100,
                      child:const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.perm_identity_rounded,size: 60,
                                color: Colors.white),
                            SizedBox(height: 5),
                            Text("Employees",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Positioned(
              child: Padding(
                padding: const EdgeInsets.only(left: 130.0,top: 320.0,bottom: 0.0,right: 130.0),
                child: GestureDetector(
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    var isLoginAdmin = prefs.getBool(AppConstants.isLoginAdmin);
                    print(isLoginAdmin);
                    if (!mounted) return;
                    if (isLoginAdmin == null) {
                      AppConstants.pageTransition(context,   AdminLoginScreen());
                    } else if (isLoginAdmin) {
                      AppConstants.pageTransition(context, const  AttendanceScreen());
                    } else {
                      AppConstants.pageTransition(context, const  AdminLoginScreen());
                    }
                    //AppConstants.pageTransition(context,const AdminLoginScreen());
                  },
                  child: SizedBox(
                    height: 150,
                    width: 190,
                    child: Card(
                      color: Color(0xff9a8ec4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),

                      ),
                      elevation: 20.0,
                      //shadowColor: Colors.grey.shade100,
                      child:const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.admin_panel_settings_outlined,size: 60,
                                color: Colors.white),
                            SizedBox(height: 5),
                            Text("Admin",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
