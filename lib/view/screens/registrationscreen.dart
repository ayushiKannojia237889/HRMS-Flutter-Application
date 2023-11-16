import 'dart:convert';
import 'dart:io';
import 'package:attendence_geofence/view/model/designation_model.dart';
import 'package:attendence_geofence/view/model/division_model.dart';
import 'package:attendence_geofence/view/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/get/division.dart';
import '../../Services/post/authentication/registration_service.dart';
import '../../app_constants/appconstants.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var locationMessage = " ";
  LatLng? currentPosition;
  bool isLoading = true;
  bool isHidden = true;
  List<String> divisionNameList = [];
  List<String> tempdivisionNameList = [];
  final divisionNameController = TextEditingController();
  List<String> designationNameList = [];
  List<String> tempdesignationNameList = [];
  final designationNameController = TextEditingController();
  bool isDataUploading = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  bool _isValid = false;

  final districtController = TextEditingController();
  final postController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  List<String> districtNameList = [];
  List<String> tempDistrictNameList = [];
  File? pickedImage1;
  File? compressedImage;

  String? pickedImage1Base64;
  double? lat;
  double? long;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLatLong();
    getDivisionList();
    getDesignationList();
    requestPermissions();
  }

// request permission
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

  // get user permission
  Future getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    );
    currentPosition = LatLng(position.latitude, position.longitude);
  }

// get designation data from server
  getDesignationList() {
    DivisionServices.getDesignation(context).then(
      (value) {
        setState(
          () {
            designationNameList = DesignationResponse.list
                .map((e) => e.post_designation!)
                .toList();
            tempdesignationNameList.addAll(designationNameList);
            tempdesignationNameList.add("Other");
          },
        );
      },
    );
  }

  // get Division data from server
  getDivisionList() {
    DivisionServices.getDivision(context).then(
      (value) {
        setState(
          () {
            divisionNameList =
                DivisionResponse.list.map((e) => e.division!).toList();
            tempdivisionNameList.addAll(divisionNameList);
            tempdivisionNameList.add("Other");
          },
        );
      },
    );
  }

  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);

  // get latlong and user permission
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    //Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getLatLong() {
    Future<Position> data = _determinePosition();
    data.then((value) {
      print("value $value");
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });

      //getAddress(value.latitude, value.longitude);
    }).catchError((error) {
      print("Error $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppConstants.pageTransition(context, const LoginScreen());
        return true;
      },
      child: _widget(),
    );
  }

  Widget _widget() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff9a8ec4),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Register',
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
            AppConstants.pageTransition(context, const LoginScreen());
          },
        ),
      ),
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Employee Name",
                    style: TextStyle(fontSize: 18, color: Color(0xff5e4f9c)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: TextFormField(
                      style: const TextStyle(color: Color(0xff5e4f9c)),
                      controller: nameController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(),
                        prefixIcon:
                            Icon(Icons.perm_identity, color: Color(0xff5e4f9c)),
                        counterText: "",
                        hintText: "Enter Employee Name",
                        hintStyle: TextStyle(color: Color(0xff9a8ec4)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Email Id",
                    style: TextStyle(fontSize: 18, color: Color(0xff5e4f9c)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: TextFormField(
                      style: const TextStyle(color: Color(0xff5e4f9c)),
                      controller: emailController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email, color: Color(0xff5e4f9c)),
                        counterText: "",
                        hintText: "Enter Email id",
                        hintStyle: TextStyle(color: Color(0xff9a8ec4)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Division",
                          style:
                              TextStyle(fontSize: 18, color: Color(0xff5e4f9c)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          child: TextFormField(
                            style: const TextStyle(color: Color(0xff5e4f9c)),
                            controller: divisionNameController,
                            readOnly: true,
                            onTap: () {
                              SelectDialog.showModal<String>(
                                context,
                                label: "Select Division name",
                                searchBoxDecoration: const InputDecoration(
                                    hintText: 'Search...'),
                                items: tempdivisionNameList,
                                onChange: (String selected) async {
                                  setState(
                                    () {
                                      divisionNameController.text = selected;
                                    },
                                  );
                                },
                              );
                            },
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.all(15),
                              border: OutlineInputBorder(),
                              counterText: "",
                              hintText: "Select Division Name",
                              hintStyle: TextStyle(color: Color(0xff9a8ec4)),
                              suffixIcon: RotatedBox(
                                quarterTurns: 1,
                                child: Icon(
                                  Icons.navigate_next_outlined,
                                  color: Color(0xff5e4f9c),
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Post / Designation",
                          style:
                              TextStyle(fontSize: 18, color: Color(0xff5e4f9c)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          child: TextFormField(
                            style: const TextStyle(color: Color(0xff5e4f9c)),
                            controller: designationNameController,
                            readOnly: true,
                            onTap: () {
                              SelectDialog.showModal<String>(
                                context,
                                label: "Select Post / Designation",
                                searchBoxDecoration: const InputDecoration(
                                    hintText: 'Search...'),
                                items: tempdesignationNameList,
                                onChange: (String selected) async {
                                  setState(
                                    () {
                                      designationNameController.text = selected;

                                    },
                                  );
                                },
                              );
                            },
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.all(15),
                              border: OutlineInputBorder(),
                              counterText: "",
                              hintText: "Select Post / Designation Name",
                              hintStyle: TextStyle(color: Color(0xff9a8ec4)),
                              suffixIcon: RotatedBox(
                                quarterTurns: 1,
                                child: Icon(
                                  Icons.navigate_next_outlined,
                                  color: Color(0xff5e4f9c),
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mobile Number",
                    style: TextStyle(fontSize: 18, color: Color(0xff5e4f9c)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: TextFormField(
                      style: const TextStyle(color: Color(0xff5e4f9c)),
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      controller: mobileNumberController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.phone, color: Color(0xff5e4f9c)),
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(),
                        counterText: "",
                        hintText: "Enter Mobile Number",
                        hintStyle: TextStyle(color: Color(0xff9a8ec4)),
                      ),
                    ),
                  ),
                  //const SizedBox(height: 10),
                  //       Container(
                  //         padding: const EdgeInsets.all(12.0),
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(12),
                  //           color: Colors.white,
                  //         ),
                  //         child: Column(
                  //           children: [
                  //             const Align(
                  //               alignment: Alignment.centerLeft,
                  //               child: Text(
                  //                 'Location',
                  //                 style: TextStyle(
                  //                   color: Color(0xff5e4f9c),
                  //                   fontSize: 18,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //             ),
                  //       //       const SizedBox(height: 5),
                  //       //       Container(
                  //       //         padding:
                  //       //         const EdgeInsets.fromLTRB(4.0, 12.0, 4.0, 12.0),
                  //       //         decoration: BoxDecoration(
                  //       //           borderRadius: BorderRadius.circular(12),
                  //       //           color: Colors.grey.withOpacity(0.1),
                  //       //         ),
                  //       //         child: Column(
                  //       //           children: [
                  //       //             Row(
                  //       //               mainAxisAlignment:
                  //       //               MainAxisAlignment.spaceAround,
                  //       //               children: [
                  //       //                 Container(
                  //       //                   width: MediaQuery.of(context).size.width /
                  //       //                       3.5,
                  //       //                   padding: const EdgeInsets.all(4.0),
                  //       //                   decoration: BoxDecoration(
                  //       //                     border: Border.all(
                  //       //                       color: Color(0xff5e4f9c),
                  //       //                     ),
                  //       //                     borderRadius: const BorderRadius.all(
                  //       //                       Radius.circular(8),
                  //       //                     ),
                  //       //                   ),
                  //       //                   child: const Center(
                  //       //                     child: Text(
                  //       //                       "Latitude",
                  //       //                       style: TextStyle(
                  //       //                         fontSize: 15.0,
                  //       //                         color: Color(0xff5e4f9c),
                  //       //                         fontWeight: FontWeight.bold,
                  //       //                       ),
                  //       //                     ),
                  //       //                   ),
                  //       //                 ),
                  //       //                 Container(
                  //       //                   width: MediaQuery.of(context).size.width /
                  //       //                       2.5,
                  //       //                   padding: const EdgeInsets.all(4.0),
                  //       //                   decoration: BoxDecoration(
                  //       //                     border: Border.all(
                  //       //                       color: Color(0xff5e4f9c),
                  //       //                     ),
                  //       //                     borderRadius: const BorderRadius.all(
                  //       //                       Radius.circular(8),
                  //       //                     ),
                  //       //                   ),
                  //       //                   child: Center(
                  //       //                     child: Text(
                  //       //                       "$lat".toString(),
                  //       //                       style: const TextStyle(
                  //       //                         color: Color(0xff5e4f9c),
                  //       //                         fontSize: 15.0,
                  //       //                         fontWeight: FontWeight.bold,
                  //       //                       ),
                  //       //                     ),
                  //       //                   ),
                  //       //                 ),
                  //       //               ],
                  //       //             ),
                  //       //             const SizedBox(height: 10),
                  //       //             Row(
                  //       //               mainAxisAlignment:
                  //       //               MainAxisAlignment.spaceAround,
                  //       //               children: [
                  //       //                 Container(
                  //       //                   width: MediaQuery.of(context).size.width /
                  //       //                       3.5,
                  //       //                   padding: const EdgeInsets.all(4.0),
                  //       //                   decoration: BoxDecoration(
                  //       //                     border: Border.all(
                  //       //                       color: Color(0xff5e4f9c),
                  //       //                     ),
                  //       //                     borderRadius: const BorderRadius.all(
                  //       //                       Radius.circular(8),
                  //       //                     ),
                  //       //                   ),
                  //       //                   child: const Center(
                  //       //                     child: Text(
                  //       //                       "Longitude",
                  //       //                       style: TextStyle(
                  //       //                         color: Color(0xff5e4f9c),
                  //       //                         fontSize: 15.0,
                  //       //                         fontWeight: FontWeight.bold,
                  //       //                       ),
                  //       //                     ),
                  //       //                   ),
                  //       //                 ),
                  //       //                 Container(
                  //       //                   width: MediaQuery.of(context).size.width /
                  //       //                       2.5,
                  //       //                   padding: const EdgeInsets.all(4.0),
                  //       //                   decoration: BoxDecoration(
                  //       //                     border: Border.all(
                  //       //                       color: Color(0xff5e4f9c),
                  //       //                     ),
                  //       //                     borderRadius: const BorderRadius.all(
                  //       //                       Radius.circular(8),
                  //       //                     ),
                  //       //                   ),
                  //       //                   child: Center(
                  //       //                     child: Text(
                  //       //                       "$long".toString(),
                  //       //                       style: const TextStyle(
                  //       //                         color: Color(0xff5e4f9c),
                  //       //                         fontSize: 15.0,
                  //       //                         fontWeight: FontWeight.bold,
                  //       //                       ),
                  //       //                     ),
                  //       //                   ),
                  //       //                 ),
                  //       //               ],
                  //       //             ),
                  //       //           ],
                  //       //         ),
                  //       //       ),
                  //       //     ],
                  //       //   ),
                  //       // )
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 15),
                  const Text(
                    "Enter Pin",
                    style: TextStyle(fontSize: 18, color: Color(0xff5e4f9c)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: TextFormField(
                      style: const TextStyle(color: Color(0xff5e4f9c)),
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      controller: passwordController,
                      //autofillHints: [AutofillHints.password],
                      validator: (passwordController) =>
                          passwordController != null &&
                                  passwordController!.length < 5
                              ? 'Enter min 5 characters'
                              : null,
                      obscureText: isHidden,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(),
                        counterText: "",
                        suffixIcon: IconButton(
                          icon: isHidden
                              ? Icon(Icons.visibility_off,
                                  color: Color(0xff5e4f9c))
                              : Icon(Icons.visibility,
                                  color: Color(0xff5e4f9c)),
                          onPressed: togglePasswordVisibility,
                        ),
                        prefixIcon: Icon(Icons.lock, color: Color(0xff5e4f9c)),
                        hintText: "Enter your Pin",
                        hintStyle: TextStyle(color: Color(0xff9a8ec4)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  const Text(
                    "Confirm Pin",
                    style: TextStyle(fontSize: 18, color: Color(0xff5e4f9c)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: TextFormField(
                      style: const TextStyle(color: Color(0xff5e4f9c)),
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      controller: confirmpasswordController,
                      autofillHints: [AutofillHints.password],
                      // validator: (passwordController) =>
                      // passwordController != null &&
                      // passwordController!.length<5
                      // ? 'Enter min 5 characters':null,
                      obscureText: isHidden,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(),
                        counterText: "",
                        suffixIcon: IconButton(
                          icon: isHidden
                              ? Icon(Icons.visibility_off,
                                  color: Color(0xff5e4f9c))
                              : Icon(Icons.visibility,
                                  color: Color(0xff5e4f9c)),
                          onPressed: togglePasswordVisibility,
                        ),
                        prefixIcon: Icon(Icons.lock, color: Color(0xff5e4f9c)),
                        hintText: "Confirm Pin",
                        hintStyle: TextStyle(color: Color(0xff9a8ec4)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Container(
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
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 2,
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
                            const Text(
                              'Employee Image',
                              style: TextStyle(
                                  color: Color(0xff5e4f9c), fontSize: 15),
                            ),
                            clickImageButton("Image1"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  SizedBox(
                    height: 50.0,
                    child: GestureDetector(
                      onTap: () async {
                        // _isValid = EmailValidator.validate(emailController.text);
                        // if(_isValid){
                        //   AppConstants.showSnackBar(
                        //     context,
                        //     "check your email id.",
                        //     Colors.red,
                        //   );
                        //
                        // }
                        if (nameController.text.isEmpty) {
                          AppConstants.showSnackBar(
                            context,
                            "Please enter name.",
                            Colors.red,
                          );
                        } else if (divisionNameController.text.isEmpty) {
                          AppConstants.showSnackBar(
                            context,
                            "Please enter district.",
                            Colors.red,
                          );
                        } else if (emailController.text.isEmpty) {
                          AppConstants.showSnackBar(
                            context,
                            "Please enter email id.",
                            Colors.red,
                          );
                        } else if (mobileNumberController.text.isEmpty) {
                          AppConstants.showSnackBar(
                            context,
                            "Please enter mobile number.",
                            Colors.red,
                          );
                        } else if (mobileNumberController.text.isNotEmpty &&
                            mobileNumberController.text.length < 10) {
                          AppConstants.showSnackBar(
                            context,
                            "Mobile number should be 10 digits.",
                            Colors.red,
                          );
                        } else if (pickedImage1 == null) {
                          AppConstants.showSnackBar(
                            context,
                            "Please select an IMAGE.",
                            Colors.red,
                          );
                        } else if (passwordController.text.isEmpty) {
                          AppConstants.showSnackBar(
                            context,
                            "Please enter Pin.",
                            Colors.red,
                          );
                        } else if (passwordController.text.isNotEmpty &&
                            passwordController.text.length < 5) {
                          AppConstants.showSnackBar(
                            context,
                            "Password should be 5 digits.",
                            Colors.red,
                          );
                        } else if (confirmpasswordController.text.isEmpty) {
                          AppConstants.showSnackBar(
                            context,
                            "confirm Pin field is required.",
                            Colors.red,
                          );
                        } else if (confirmpasswordController.text !=
                            passwordController.text) {
                          AppConstants.showSnackBar(
                            context,
                            "your pin is not matched please match your pin.",
                            Colors.red,
                          );
                        } else {
                          setState(() => isDataUploading = true);
                          var prefs = await SharedPreferences.getInstance();
                          prefs.setString(AppConstants.name,
                              nameController.text.toString());
                          prefs.setString(AppConstants.mobileno,
                              mobileNumberController.text.toString());
                          RegistrationService.createUser(
                                  context,
                                  nameController.text,
                                  divisionNameController.text,
                                  designationNameController.text,
                                  mobileNumberController.text,
                                  emailController.text,
                                  pickedImage1Base64!,
                                  passwordController.text)
                              .then(
                            (value) => setState(
                              () => isDataUploading = false,
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    letterSpacing: 1,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
    // final pickedFile = await ImagePicker.platform
    //     .pickImage(source: ImageSource.camera, imageQuality: 50);
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      if (img == "Image1") {

        setState(() {
          pickedImage1 = File(pickedFile.path);
          //final compressedImage = FlutterImageCompress.compressWithFile(pickedImage1!.path);

          pickedImage1Base64 =
              base64Encode(File(pickedFile.path).readAsBytesSync());
        });
        print(pickedImage1!.length());
        //print(compressedImage!.length());
      }
    }
  }

  // Future _openCamera(String img) async {
  //   XFile? pickedFile = await ImagePicker()
  //       .pickImage(source: ImageSource.camera, imageQuality: 50);
  //   if (pickedFile != null) {
  //     if (img == "Image1") {
  //       setState(() async {
  //         pickedImage1 = File(pickedFile.path);
  //         // final compressedImage1 = await FlutterImageCompress.compressWithFile(pickedImage1!.path);
  //         // if(compressedImage1!=null){
  //         //     compressedImage = compressedImage1 as File?;
  //         // }
  //         //print(pickedImage1!.length());
  //         //print(compressedImage!.length());
  //         pickedImage1Base64 =
  //             base64Encode(File(pickedFile.path).readAsBytesSync());
  //         print("image:");
  //         print(pickedImage1Base64);
  //         // final image = imgm.decodeImage(File(pickedImage1!.path).readAsBytesSync());
  //         // final resized = imgm.copyResize(image!, width: 600, height: 800);
  //         // final compressed = File('${pickedFile.path}.compressed')
  //         //   ..writeAsBytesSync(imgm.encodeJpg(resized, quality: 90));
  //         // print("--------compressed---------------");
  //         // print(compressed);
  //
  //
  //
  //
  //       });
  //     }
  //   }
  // }
}
