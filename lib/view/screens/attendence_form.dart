import 'dart:convert';
import 'dart:io';

import 'package:attendence_geofence/Services/post/authentication/attendence_service.dart';
import 'package:attendence_geofence/view/basics/dashboardscreen.dart';
import 'package:attendence_geofence/view/model/attendanceLogindetail.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/get/division.dart';
import '../../app_constants/appconstants.dart';



class AttendenceForm extends StatefulWidget {
  final String mobileno;
  const AttendenceForm(this.mobileno,{super.key});

  @override
  State<AttendenceForm> createState() => _AttendenceFormState();
}

class _AttendenceFormState extends State<AttendenceForm> {
  bool initialPosition = true;

  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String tdata = DateFormat("hh:mm a").format(DateTime.now());
  String cdate2 = DateFormat("MMMM yyyy").format(DateTime.now());
  final nameController = TextEditingController();
  final mobileNumberController = TextEditingController();

  var nameValue = "no value saved ";
  var mobilenoValue = "no mobileno saved ";
  bool isDataUploading = false;
  //String present = "Present";
 // String absent = "Absent";


  bool monthValue = false;
  bool timeValue = false;
  bool dateValue = false;


  bool presentValue = false;
  bool absentValue = false;

  File? pickedImage1;
  String? pickedImage1Base64;
  List<DatumMobileno> valueMobileList = [];
  List<DatumMobileno> tempvalueMobileList = [];
  String NameValue=" ";
  // String valueChexk =" ";
   late final List<bool> isSelected  ;
   bool isSwitched = false;
  var textValue = 'Check In';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //isSelected = [true,false];
    getValue();
    getUSerMobileNoValue();

  }
  void toggleSwitch(bool value) {

    if(isSwitched == false)
    {
      setState(() {
        isSwitched = true;
        textValue = 'check out';
      });
     // print('Switch Button is ON');
    }
    else
    {
      setState(() {
        isSwitched = false;
        textValue = 'check in';
      });
     // print('Switch Button is OFF');
    }
  }
  getUSerMobileNoValue() {
    getLoginValueResponse(widget.mobileno);

  }

  Future<List<DatumMobileno>> getLoginValueResponse(String mobileno) async {
    valueMobileList = await DivisionServices.getFirstNAmeMobilenoDetail(context, mobileno);
    setState(() {
      tempvalueMobileList.addAll(valueMobileList);
    });
    return tempvalueMobileList;

  }


  @override
  Widget build(BuildContext context) {
    int n = tempvalueMobileList.length;
    for(int i = 0;i<n;i++){
      NameValue = tempvalueMobileList[i].firstName;
      print(NameValue);
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff9a8ec4),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Attendance',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: Colors.white),
          onPressed: () {
            AppConstants.pageTransition(context, const DashBoardScreen());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 900,
          width: 500,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:40.0,left: 130.0),
                    child: Center(
                      child: Container(
                        height: 50,
                        child: Switch(
                          activeColor: Colors.deepPurple,
                          value: isSwitched,
                          onChanged: toggleSwitch
                          //     (value){
                          //   setState(() {
                          //     isSwitched =value;
                          //   });
                          // },
                          // borderColor: Colors.deepPurple,
                          // fillColor: Color(0xff9a8ec4),
                          // borderWidth: 2,
                          //  selectedBorderColor: Colors.deepPurple,
                          //  selectedColor:  Colors.white,
                          //   borderRadius: BorderRadius.circular(0),
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Text(
                          //         'Check-In',
                          //         style: TextStyle(fontSize: 16),
                          //       ),
                          //     ),
                          //     Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Text(
                          //         'Check-Out',
                          //         style: TextStyle(fontSize: 16),
                          //       ),
                          //     ),
                          //   ],
                          //    onPressed: (int index){
                          //   print(index);
                          //     setState(() {
                          //       for (int i = 0; i < isSelected.length; i++) {
                          //         if(i==0){
                          //           valueChexk = "check-in";
                          //           print(valueChexk);
                          //         }
                          //         else if(i==1){
                          //           valueChexk = "check-out";
                          //           print(valueChexk);
                          //         }
                          //       }
                          //     });
                          //    },
                          //    isSelected: isSelected,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Text('$textValue',style: TextStyle(fontSize: 20)),
                  ),
                  Visibility(
                    visible: dateValue,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 50.0, right: 15.0, left: 25.0, bottom: 0.0),
                      child: SizedBox(
                        width: 350,
                        height: 100,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Color(0xff9a8ec4),
                          child: Center(
                            child: Text(
                              "      Date" + "\n" + "$cdate",
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: timeValue,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 50.0, right: 15.0, left: 10.0, bottom: 0.0),
                      child: SizedBox(
                        width: 170,
                        height: 100,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Color(0xff9a8ec4),
                          child: Center(
                            child: Text(
                              "       Time" + "\n" + "$tdata",
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Visibility(
                    visible: monthValue,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0),
                          child: SizedBox(
                            width: 350,
                            height: 90,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Color(0xff9a8ec4),
                              child: Center(
                                child: Text(
                                  "      Month" + "\n" + "$cdate2",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, top: 0.0, bottom: 0.0),
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 400,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Text(
                                 "   Employee Name :    " +  NameValue,
                                  style: const TextStyle(
                                      color: Color(0xff5e4f9c),
                                      fontSize: 20,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, top: 0.0, bottom: 0.0),
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 400,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  // color: Colors.grey.withOpacity(0.1),
                                ),
                                child: Text(
                                  "  Mobile number :   " + mobilenoValue,
                                  style: const TextStyle(
                                      color: Color(0xff5e4f9c),
                                      fontSize: 20,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible:presentValue ,
                          child: const SizedBox(height: 15)),
                      Visibility(
                        visible: presentValue,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 20.0, left: 20.0, top: 0.0, bottom: 0.0),
                          child: Container(
                            height: 60,
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 400,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    // color: Colors.grey.withOpacity(0.1),
                                  ),
                                  child: Text(
                                    '$textValue',
                                    style: const TextStyle(
                                        color: Color(0xff5e4f9c),
                                        fontSize: 20,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Visibility(
                      //   visible: absentValue,
                      //     child: SizedBox(height: 15)),
                      // Visibility(
                      //   visible: absentValue,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(
                      //         right: 20.0, left: 20.0, top: 0.0, bottom: 0.0),
                      //     child: Container(
                      //       height: 60,
                      //       padding: const EdgeInsets.all(12.0),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(12),
                      //         color: Colors.white,
                      //       ),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Container(
                      //             width: 400,
                      //             height: 30,
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(12),
                      //               // color: Colors.grey.withOpacity(0.1),
                      //             ),
                      //             child: Text(
                      //               absent,
                      //               style: const TextStyle(
                      //                   color: Color(0xff5e4f9c),
                      //                   fontSize: 20,
                      //                   fontStyle: FontStyle.normal),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 10),
                      Container(
                        width: 370,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            pickedImage1 != null
                                ? Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F6F7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                             // width: MediaQuery.of(context).size.width,
                              width: 370,
                              height: 200,
                              // height:
                              // MediaQuery.of(context).size.height / 2,
                              child: Image.file(
                                pickedImage1!,
                                fit: BoxFit.fill,
                              ),
                            )
                                : Container(),
                            pickedImage1 == null
                                ? Container()
                                : const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text('User Image',
                                  style: TextStyle(
                                      color: Color(0xff5e4f9c),
                                      fontSize: 15
                                  ),
                                ),
                                clickImageButton("Image1"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 48,
                        child: GestureDetector(
                          onTap: () async {
                            if (pickedImage1 == null) {
                              AppConstants.showSnackBar(
                                context,
                                "Please select an IMAGE.",
                                Colors.red,
                              );
                            }else {
                              setState(() => isDataUploading = true);
                              AttendanceService.attendUser(
                                  context,
                                  NameValue.toString(),
                                  mobilenoValue.toString(),
                                  //cdate2.toString(),
                                 // tdata.toString(),
                                  //cdate.toString(),
                                  '$textValue'.toString(),
                                  pickedImage1Base64!
                              ).then(
                                    (value) =>
                                    setState(
                                          () => isDataUploading = false,
                                    ),
                              );
                            }

                          },
                          child: Container(
                            width: 370,
                            height: 50,
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              color: const Color(0xff9a8ec4),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(
                              child: isDataUploading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      "Submit",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontStyle: FontStyle.italic,
                                        letterSpacing: 1,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void getValue() async {
    var pref = await SharedPreferences.getInstance();
    // var getName = pref.getString(AppConstants.name);
    // nameValue = getName != null ? getName : "No value saved";
    var getMobileno = pref.getString(AppConstants.mobileno);
    mobilenoValue = getMobileno != null ? getMobileno : "No mobileno saved";
    setState(() {});
  }

  clickImageButton(String img) {
    return ElevatedButton.icon(
      icon: const Icon(
        Icons.camera_alt_outlined,
        size: 24,
      ),
      label: const Text('Click Image'),
      onPressed: () {
        _openCamera(img);
      },
    );
  }

  Future _openCamera(String img) async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      if (img == "Image1") {
        setState(() {
          pickedImage1 = File(pickedFile.path);
          pickedImage1Base64 =
              base64Encode(File(pickedFile.path).readAsBytesSync());
        });
      }
    }
  }
}
