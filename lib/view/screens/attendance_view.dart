import 'package:attendence_geofence/view/screens/Map.dart';
import 'package:attendence_geofence/view/screens/loginscreen.dart';
import 'package:attendence_geofence/view/screens/useradminscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_constants/appconstants.dart';
import 'adminscreen.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff9a8ec4),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool(AppConstants.isLoginAdmin, false);
              prefs.remove("isLoginAdmin");
              AppConstants.pageTransition(context, const UserScreen());
            },
            icon: Icon(Icons.logout,color:Colors.white ),
          )
        ],
        // title: const Text("DashBoard",
        //   textAlign: TextAlign.center,
        //   style: TextStyle(color: Colors.white,
        //       fontWeight: FontWeight.bold),
        // ),
      ),
      body: Container(
        child:  Stack(
          children: [
            // Positioned(
            //       child: Padding(
            //         padding: const EdgeInsets.only(left: 130.0,top: 130.0,bottom: 0.0,right: 130.0),
            //         child: GestureDetector(
            //           onTap: (){
            //             AppConstants.pageTransition(context,const LoginScreen());
            //           },
            //           child: SizedBox(
            //             height: 150,
            //             width: 190,
            //             child: Card(
            //               color: Color(0xff9a8ec4),
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(20.0),
            //               ),
            //               elevation: 20.0,
            //               //shadowColor: Colors.grey.shade100,
            //               child:const Center(
            //                 child: Column(
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: [
            //                     Icon(Icons.admin_panel_settings_outlined,size: 60,
            //                         color: Colors.white),
            //                     SizedBox(height: 5),
            //                     Text("Login",
            //                       style: TextStyle(
            //                           color: Colors.white,
            //                           fontSize: 15
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //SizedBox(height: 50),
            Positioned(
              child: Padding(
                padding: const EdgeInsets.only(left: 130.0,top: 250.0,bottom: 0.0,right: 130.0),
                child: GestureDetector(
                  onTap: (){
                    AppConstants.pageTransition(context, AdminScreenS());
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
                            Text("Attendance View",
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
