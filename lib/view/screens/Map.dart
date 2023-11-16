import 'dart:async';
import 'dart:collection';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:attendence_geofence/view/screens/attendence_form.dart';
import 'package:attendence_geofence/view/screens/useradminscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/get/division.dart';
import '../../Services/post/location_service.dart';
import '../../app_constants/appconstants.dart';
import '../basics/dashboardscreen.dart';
import '../model/attendanceLogindetail.dart';
import '../model/geofence_model.dart';

class MapScreen extends StatefulWidget {
  final String mobileno;
  const MapScreen(this.mobileno,{super.key});


  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  bool locationValue = false;
  bool nameValue = false;
  bool timeValue = false;
  bool mobilenoValue = false;

  LatLng? currentPosition;
  bool showAlert = false;
  bool isLoading = true;
  bool isDataUploading = false;
  String location = " ";
  var name = "no value saved ";
  var mobileno = "no value saved ";

  Set<Marker> markers = HashSet<Marker>();
  int markerIDCounter = 1;
  final latlongController = TextEditingController();
  String latitude = "";
  String longitude = "";
  final Completer<GoogleMapController> _controller = Completer();
  String time = DateFormat("hh:mm a").format(DateTime.now());
  List<Datum1> valueList = [];
  List<Datum1> tempvalueList = [];
  //bool _buttonEnabled = false;
  Color buttonColor = Colors.grey;
  bool isActive  = false;
  List<DatumMobileno> valueMobileList = [];
  List<DatumMobileno> tempvalueMobileList = [];
  String NameValue=" ";


  @override
  void initState() {
    super.initState();
    // clearSavedLatLng();
    requestPermissions();
    getValue();
    //getUSerMobileNoValue();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _ifLoaded();
    });
  //   Timer.periodic(Duration(seconds: 2), (timer) {
  //     //_checkTime();
  //     var now = DateTime.now();
  //     var startTime = DateTime(now.year,now.month,now.day,15);
  //     var endTime = DateTime(now.year,now.month,now.day,16);
  //     print(startTime);
  //     print(endTime);
  //     print(now.isAfter(startTime));
  //     print(now.isBefore(endTime));
  //
  //     // bool reult = DateTime.now().hour>=3 ;
  //     // print("time greater then 3");
  //     // print(reult);
  //     // bool time = DateTime.now().hour>=4;
  //     // print("time less then 4");
  //     //
  //     // print(time );
  //
  //   });
   }

  // getUSerMobileNoValue() {
  //   //print(widget.mobileno);
  //   getLoginValueResponse(widget.mobileno);
  //
  // }
  //
  // Future<List<DatumMobileno>> getLoginValueResponse(String mobileno) async {
  //   valueMobileList = await DivisionServices.getFirstNAmeMobilenoDetail(context, mobileno);
  //   setState(() {
  //     tempvalueMobileList.addAll(valueMobileList);
  //   });
  //   return tempvalueMobileList;
  // }

  // _checkTime() {
  //   if(DateTime.now().hour>=3 && DateTime.now().hour<=4){
  //       setState(() {
  //         _buttonEnabled = true;
  //       });
  //   }else{
  //       setState(() {
  //         _buttonEnabled = false;
  //       });
  //   }
  //
  // }


  // _checkTime(){
  //   var now = DateTime.now();
  //   //4 pm
  //   var startTime = DateTime(now.year,now.month,now.day,12);
  //   // 5 pm
  //   var endTime = DateTime(now.year,now.month,now.day,16);
  //   if(now.isAfter(startTime) && now.isBefore(endTime)){
  //     setState(() {
  //               _buttonEnabled = true;
  //               isActive = true;
  //
  //             });
  //   }else{
  //     setState(() {
  //       _buttonEnabled = false;
  //       isActive = false;
  //
  //
  //     });
  //   }
  // }

  _ifLoaded() async {
    userRegisteredSuccessfullyDialog(context);
    //showLoaderDialog(context);
  }

  Future<Object?> userRegisteredSuccessfullyDialog(BuildContext context) {
    return ArtSweetAlert.show(
      context: context,
      barrierDismissible: false,
      artDialogArgs: ArtDialogArgs(
        onCancel: () {
          AppConstants.pageTransition(context, DashBoardScreen());
        },

        showCancelBtn: true,
        confirmButtonColor: Colors.green,
        confirmButtonText: 'Yes',
        cancelButtonText: 'No',
        cancelButtonColor: Colors.red,
        type: ArtSweetAlertType.question,
        title: "your location?.",

      ),
    );
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alertDialog =   AlertDialog(
      content:  Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text(" Please wait...."),
          ),
        ],
      ),
    );
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return alertDialog;
        });
    
  }

  Future<List<Datum1>> getValueResponse(String value5) async {
    valueList = await DivisionServices.getGeofence(context, value5);
    setState(() {
      tempvalueList.addAll(valueList);
    });
    return tempvalueList;
  }

  // Future clearSavedLatLng() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.remove(AppConstants.latitude);
  //   pref.remove(AppConstants.longitude);
  // }

  Future requestPermissions() async {
    final locationStatus = await Permission.location.request();

    if (locationStatus == PermissionStatus.granted) {
      getUserLocation().then((value) => setState(() => isLoading = false));
    } else if (locationStatus == PermissionStatus.denied) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
              'Please allow Location Services. The app will not function properly without it.'),
          backgroundColor: Colors.red,
        ),
      );
      Future.delayed(const Duration(seconds: 2), () => requestPermissions());
    } else if (locationStatus == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
  }

  Future getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    );
    currentPosition = LatLng(position.latitude, position.longitude);
    latitude = currentPosition!.latitude.toString();
    longitude = currentPosition!.longitude.toString();
    location = "POINT(" + longitude + "   " + latitude + ")";
  }

  // void _setMarker(LatLng point) {
  //   final String markerIDVal = 'marker_id_$markerIDCounter';
  //   markerIDCounter++;
  //   markers.add(Marker(markerId: MarkerId(markerIDVal), position: point));
  //   currentPosition = LatLng(point.latitude, point.longitude);
  //   latitude = currentPosition!.latitude.toString();
  //   longitude = currentPosition!.longitude.toString();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: _buildWidget(),
      onWillPop: () async {
        AppConstants.pageTransition(context, MapScreen(AppConstants.mobileno));
        return true;
      },
    );
  }

  Widget _buildWidget() {
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              title: const Text(
                "Select Location",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  AppConstants.pageTransition(context, DashBoardScreen());
                },
              ),
              backgroundColor: const Color(0xff4141BA),
              centerTitle: true,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
              ),
            ),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFadingCircle(color: Color(0xff4141BA), size: 36),
                  SizedBox(height: 5),
                  Text(
                    "Fetching Location...",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  padding: const EdgeInsets.only(top: 84.0),
                  initialCameraPosition: CameraPosition(
                    target: currentPosition!,
                    zoom: 18.5,
                  ),
                  mapType: MapType.hybrid,
                  markers: markers,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    markers.add(
                      Marker(
                        markerId: const MarkerId('0'),
                        position: currentPosition!,
                        infoWindow: const InfoWindow(
                          title: 'Hello its destination (: !',
                          snippet: 'You are here',
                        ),
                      ),
                    );
                    setState(() {});
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onTap: (point) {
                    markers.clear();
                    //_setMarker(point);
                  },
                ),
                SizedBox(
                  height: 84,
                  child: AppBar(
                    title: const Text(
                      "Select Location",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        AppConstants.pageTransition(context, UserScreen());
                      },
                    ),
                    backgroundColor: const Color(0xff4141BA),
                    centerTitle: true,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Visibility(
                  visible: locationValue,
                  child: SizedBox(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 200.0),
                        child: Text(
                          location.toString(),
                          style:
                              const TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 400.0),
                      child: Text(
                        NameValue.toString(),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Visibility(
                  visible: timeValue,
                  child: SizedBox(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 600.0),
                        child: Text(
                          time.toString(),
                          style:
                              const TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Visibility(
                  visible: mobilenoValue,
                  child: SizedBox(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 600.0),
                        child: Text(
                          mobileno.toString(),
                          style:
                          const TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   height: 36.0,
                        //   width: 100.0,
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       AppConstants.pageTransition(
                        //         context,
                        //         MapScreen(),
                        //       );
                        //     },
                        //     child: Container(
                        //       padding: const EdgeInsets.only(
                        //         left: 9.0,
                        //         right: 9.0,
                        //       ),
                        //       decoration: BoxDecoration(
                        //         color: Colors.red,
                        //         borderRadius: BorderRadius.circular(15.0),
                        //       ),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: <Widget>[
                        //           Center(
                        //             child: GestureDetector(
                        //               onTap: () {
                        //                 AppConstants.pageTransition(
                        //                     context, const UserScreen());
                        //               },
                        //               child: const Text(
                        //                 "Cancel",
                        //                 style: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 15,
                        //                   letterSpacing: 1,
                        //                 ),
                        //               ),
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        //const SizedBox(width: 10),
                        SizedBox(
                          height: 40.0,
                          width: 200.0,
                          child: GestureDetector(
                            onTap:()  async{
                                await saveLatLng();
                                setState(() => isDataUploading = true
                                );

                                // var prefs = await SharedPreferences.getInstance();
                                // //prefs.setString(AppConstants.name, nameController.text.toString());
                                // prefs.setString(AppConstants.mobileno, mobileNumberController.text.toString());
                                // post request
                                int n = tempvalueMobileList.length;
                                for(int i = 0;i<n;i++){
                                  NameValue = tempvalueMobileList[i].firstName;
                                }
                                LocationService.postUser(
                                    context,
                                    location.toString(),
                                    name.toString(),
                                    time.toString(),
                                  mobileno.toString()
                                ).then(
                                      (value) =>
                                      setState(
                                            () => isDataUploading = false,
                                      ),
                                );
                                await getValueResponse(time);

                                setState(() => isLoading = true);
                                 n = tempvalueList.length;
                                for (int i = 0; i < n; i++) {
                                  String check = tempvalueList[i].value5;
                                  Future.delayed(const Duration(
                                      milliseconds: 32000),
                                          () {
                                        CircularProgressIndicator();
                                      }
                                  );
                                  if (check == "true") {
                                    AppConstants.pageTransition(
                                        context, AttendenceForm(mobileno));
                                  }
                                  else {
                                    setState(() => isDataUploading = true
                                    );
                                    Future.delayed(
                                        const Duration(milliseconds: 32000),
                                            () {
                                          CircularProgressIndicator();
                                        }
                                    );
                                    AppConstants.pageTransition(
                                        context, DashBoardScreen());
                                    AppConstants.showSnackBar(context,
                                        "You are not in a correct Position :)",
                                        Colors.red);
                                  }
                                }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Container(
                                padding: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 12.0,
                                ),
                                decoration: BoxDecoration(
                                  //color:isActive? Colors.green :Colors.grey,
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
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
                                              "Confirm your position",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Future saveLatLng() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(
      AppConstants.latitude,
      currentPosition!.latitude.toStringAsFixed(8),
    );
    pref.setString(
      AppConstants.longitude,
      currentPosition!.longitude.toStringAsFixed(8),
    );
  }

  void getValue() async {
    var pref = await SharedPreferences.getInstance();
    var getName = pref.getString(AppConstants.name);
    name = getName != null ? getName : "No value saved";
    var getMobileno = pref.getString(AppConstants.mobileno);
    mobileno = getMobileno != null ? getMobileno: "No value saved";

    setState(() {});
  }
}
