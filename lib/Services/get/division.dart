import 'dart:convert';
import 'package:attendence_geofence/view/model/date_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../app_constants/appconstants.dart';
import '../../view/model/attendanceLogindetail.dart';
import '../../view/model/month_Model.dart';
import '../../view/model/userdetail_model.dart';
import '../../view/model/designation_model.dart';
import '../../view/model/division_model.dart';
import '../../view/model/firstname_model.dart';
import '../../view/model/geofence_model.dart';

class DivisionServices{

  static Future getDivision(BuildContext context) async {
    var uri = '${AppConstants.baseURL}getDivisionList';
    var getURL = Uri.parse(uri);

    try {
      var response = await http.get(getURL);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true) {
          DivisionResponse.list.clear();
          DivisionResponse.list = List.from(jsonData["data"])
              .map<DivisionModel>((item) => DivisionModel.fromJson(item))
              .toList();
        } else {
          Future.delayed(
            const Duration(milliseconds: 100),
                () {
              AppConstants.showSnackBar(
                  context,
                  "Couldn't load district list. ${jsonData['message']}",
                  Colors.red);
            },
          );
        }
      } else {
        Future.delayed(
          const Duration(milliseconds: 100),
              () {
            AppConstants.showSnackBar(
                context, "Couldn't load district list.", Colors.red);
          },
        );
      }
    } catch (e) {
      Future.delayed(
        const Duration(milliseconds: 100),
            () {
          AppConstants.showSnackBar(
              context, "Couldn't load district list due to $e", Colors.red
          );
        },
      );
    }
  }


  static Future getMonthList(BuildContext context) async {
    var uri = '${AppConstants.baseURL}getMonthList';
    var getURL = Uri.parse(uri);

    try {
      var response = await http.get(getURL);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true) {
          MonthResponse.list.clear();
          MonthResponse.list = List.from(jsonData["data"])
              .map<MonthModel>((item) => MonthModel.fromJson(item))
              .toList();
        } else {
          Future.delayed(
            const Duration(milliseconds: 100),
                () {
              AppConstants.showSnackBar(
                  context,
                  "Couldn't load month list. ${jsonData['message']}",
                  Colors.red);
            },
          );
        }
      } else {
        Future.delayed(
          const Duration(milliseconds: 100),
              () {
            AppConstants.showSnackBar(
                context, "Couldn't load month list.", Colors.red);
          },
        );
      }
    } catch (e) {
      Future.delayed(
        const Duration(milliseconds: 100),
            () {
          AppConstants.showSnackBar(
              context, "Couldn't load month list due to $e", Colors.red
          );
        },
      );
    }
  }



  static Future getDesignation(BuildContext context) async {
    var uri = '${AppConstants.baseURL}getDesignationList';
    var getURL = Uri.parse(uri);

    try {
      var response = await http.get(getURL);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true) {
          DesignationResponse.list.clear();
          DesignationResponse.list = List.from(jsonData["data"])
              .map<DesignationModel>((item) => DesignationModel.fromJson(item))
              .toList();
        } else {
          Future.delayed(
            const Duration(milliseconds: 100),
                () {
              AppConstants.showSnackBar(
                  context,
                  "Couldn't load district list. ${jsonData['message']}",
                  Colors.red);
            },
          );
        }
      } else {
        Future.delayed(
          const Duration(milliseconds: 100),
              () {
            AppConstants.showSnackBar(
                context, "Couldn't load district list.", Colors.red);
          },
        );
      }
    } catch (e) {
      Future.delayed(
        const Duration(milliseconds: 100),
            () {
          AppConstants.showSnackBar(
              context, "Couldn't load district list due to $e", Colors.red);
        },
      );
    }
  }


  static Future getDate(BuildContext context) async {
    var uri = '${AppConstants.baseURL}getDateList';
    var getURL = Uri.parse(uri);

    try {
      var response = await http.get(getURL);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true) {
          DateResponse.list.clear();
          DateResponse.list = List.from(jsonData["data"])
              .map<DateModel>((item) => DateModel.fromJson(item))
              .toList();
        } else {
          Future.delayed(
            const Duration(milliseconds: 100),
                () {
              AppConstants.showSnackBar(
                  context,
                  "Couldn't load date list. ${jsonData['message']}",
                  Colors.red);
            },
          );
        }
      } else {
        Future.delayed(
          const Duration(milliseconds: 100),
              () {
            AppConstants.showSnackBar(
                context, "Couldn't load date list.", Colors.red);
          },
        );
      }
    } catch (e) {
      Future.delayed(
        const Duration(milliseconds: 100),
            () {
          AppConstants.showSnackBar(
              context, "Couldn't load date list due to $e", Colors.red);
        },
      );
    }
  }

// get First name according to the division
  static Future<List<Datum>> getName(BuildContext context, String division) async {
    var uri = '${AppConstants.baseURL}getFirstName';
    var postURL = Uri.parse(uri);

    Map<String, String> body = {"division": division};

    try {
      var response = await http.post(
        postURL,
        body: body,
      );

      if (response.statusCode == 200) {
        print("REsponseMessaage" + response.body);
        var jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true) {
          FirstNameModelResponse.list.clear();
          var tempBlockList = List.from(jsonData["data"])
              .map<Datum>((item) => Datum.fromJson(item))
              .toList();
          FirstNameModelResponse.list = tempBlockList;
          // for (var tempBlock in tempBlockList) {
          //   if (tempBlock.data. != "---") {
          //     FirstNameModelResponse.list.add(tempBlock);
          //   }
          // }
        } else {
          Future.delayed(
            const Duration(milliseconds: 100),
                () {
              AppConstants.showSnackBar(
                  context,
                  "Couldn't load Bus Stand list. ${jsonData['message']}",
                  Colors.red);
            },
          );
        }
      } else {
        Future.delayed(
          const Duration(milliseconds: 100),
              () {
            AppConstants.showSnackBar(
                context, "Couldn't load Bus Stand list.", Colors.red);
          },
        );
      }
    } catch (e) {
      Future.delayed(
        const Duration(milliseconds: 100),
            () {
          AppConstants.showSnackBar(
              context, "Couldn't load Bus Stand list due to $e", Colors.red);
        },
      );
    }
    return FirstNameModelResponse.list;
  }

  // get firstName, mobile no according to the mobile no
  static Future<List<DatumMobileno>> getFirstNAmeMobilenoDetail(BuildContext context, String mobileno) async {
    var uri = '${AppConstants.baseURL}getAttendanceNameMobile';
    var postURL = Uri.parse(uri);
    Map<String, String> body = {"mobileno": mobileno};
    try {
      var response = await http.post(
        postURL,
        body: body,
      );

      if (response.statusCode == 200) {
        print("ResponseMessaage" + response.body);
        var jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true) {
          AttendanceLoginDetailModelResponse.list.clear();
          var tempBlockList = List.from(jsonData["data"])
              .map<DatumMobileno>((item) => DatumMobileno.fromJson(item))
              .toList();
          AttendanceLoginDetailModelResponse.list = tempBlockList;
        } else {
          Future.delayed(
            const Duration(milliseconds: 100),
                () {
              AppConstants.showSnackBar(
                  context,
                  "Couldn't load User Detail list. ${jsonData['message']}",
                  Colors.red);
            },
          );
        }
      } else {
        Future.delayed(
          const Duration(milliseconds: 100),
              () {
            AppConstants.showSnackBar(
                context, "Couldn't load User Detail list.", Colors.red);
          },
        );
      }
    } catch (e) {
      Future.delayed(
        const Duration(milliseconds: 100),
            () {
          AppConstants.showSnackBar(
              context, "Couldn't load User Detail list due to $e", Colors.red);
        },
      );
    }
    return AttendanceLoginDetailModelResponse.list;
  }


  // get date,time according to the first_name
  static Future<List<DatumValue>> getUserDetail(BuildContext context, String first_name,String month) async {
    var uri = '${AppConstants.baseURL}getUserDataInfo';
    var postURL = Uri.parse(uri);

    Map<String, String> body = {"first_name": first_name,"month":month};
    print(body);

    try {
      var response = await http.post(
        postURL,
        body: body,
      );

      if (response.statusCode == 200) {
        print("ResponseMessaage" + response.body);
        var jsonData = jsonDecode(response.body);
        if (jsonData["status"] == true) {
          UserDetailModelResponse.list.clear();
          var tempBlockList = List.from(jsonData["data"])
              .map<DatumValue>((item) => DatumValue.fromJson(item))
              .toList();
          UserDetailModelResponse.list = tempBlockList;

        } else {
          Future.delayed(
            const Duration(milliseconds: 100),
                () {
              AppConstants.showSnackBar(
                  context,
                  "Couldn't load User Detail list. ${jsonData['message']}",
                  Colors.red);
              print("${jsonData['message']}");
            },
          );
        }
      } else {
        Future.delayed(
          const Duration(milliseconds: 100),
              () {
            AppConstants.showSnackBar(
                context, "Couldn't load User Detail list.", Colors.red);
          },
        );
      }
    } catch (e) {
      Future.delayed(
        const Duration(milliseconds: 100),
            () {
          AppConstants.showSnackBar(
              context, "Couldn't load User Detail list due to $e", Colors.red);
          print("$e");

            },
      );
    }
    return UserDetailModelResponse.list;
  }



  // get value5 according to the time
  static Future<List<Datum1>> getGeofence(BuildContext context, String time) async {
    var uri = '${AppConstants.baseURL}getResponse';
    var postURL = Uri.parse(uri);

    Map<String, String> body = {"time": time};
    try {
      var response = await http.post(
        postURL,
        body: body,
      );

      if (response.statusCode == 200) {
        print("Geofence ResponseMessaage" + response.body);
        var jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true) {
          GeofenceModelResponse.list.clear();
          var tempBlockList = List.from(jsonData["data"])
              .map<Datum1>((item) => Datum1.fromJson(item))
              .toList();
          GeofenceModelResponse.list = tempBlockList;

        } else {
          Future.delayed(
            const Duration(milliseconds: 100),
                () {
              AppConstants.showSnackBar(
                  context,
                  "Couldn't load value(true/false) list. ${jsonData['message']}",
                  Colors.red);
            },
          );
        }
      } else {
        Future.delayed(
          const Duration(milliseconds: 100),
              () {
            AppConstants.showSnackBar(
                context, "Couldn't load value(true/false) list.", Colors.red);
          },
        );
      }
    } catch (e) {
      Future.delayed(
        const Duration(milliseconds: 100),
            () {
          AppConstants.showSnackBar(
              context, "Couldn't load value(true/false) due to $e", Colors.red);
        },
      );
    }
    return GeofenceModelResponse.list;
  }
  ///////
  // static Future getGeofence(BuildContext context,String value5) async {
  //   var uri = '${AppConstants.baseURL}/getResponse';
  //   var getURL = Uri.parse(uri);
  //
  //   try {
  //     var response = await http.get(getURL);
  //
  //     if (response.statusCode == 200) {
  //       var jsonData = jsonDecode(response.body);
  //
  //       if (jsonData["status"] == true) {
  //         GeofenceResponse.list.clear();
  //         GeofenceResponse.list = List.from(jsonData["data"])
  //             .map<GeofenceModel>((item) => GeofenceModel.fromJson(item))
  //             .toList();
  //       } else {
  //         Future.delayed(
  //           const Duration(milliseconds: 100),
  //               () {
  //             AppConstants.showSnackBar(
  //                 context,
  //                 "Couldn't load date list. ${jsonData['message']}",
  //                 Colors.red);
  //           },
  //         );
  //       }
  //     } else {
  //       Future.delayed(
  //         const Duration(milliseconds: 100),
  //             () {
  //           AppConstants.showSnackBar(
  //               context, "Couldn't load date list.", Colors.red);
  //         },
  //       );
  //     }
  //   } catch (e) {
  //     Future.delayed(
  //       const Duration(milliseconds: 100),
  //           () {
  //         AppConstants.showSnackBar(
  //             context, "Couldn't load date list due to $e", Colors.red);
  //       },
  //     );
  //   }
  // }
//

}
