import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_constants/appconstants.dart';

class USerAttendence extends StatefulWidget {
  const USerAttendence({super.key});

  @override
  State<USerAttendence> createState() => _USerAttendenceState();
}

class _USerAttendenceState extends State<USerAttendence> {
  LatLng? currentPosition;
  bool isLoading = true;

  Set<Marker> markers = HashSet<Marker>();
  int markerIDCounter = 1;

  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    clearSavedLatLng();
    requestPermissions();
  }

  Future clearSavedLatLng() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    //pref.remove(AppConstants.latitude);
    //pref.remove(AppConstants.longitude);
  }

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
  }

  void _setMarker(LatLng point) {
    final String markerIDVal = 'marker_id_$markerIDCounter';
    markerIDCounter++;
    markers.add(Marker(markerId: MarkerId(markerIDVal), position: point));
    currentPosition = LatLng(point.latitude, point.longitude);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: _buildWidget(),
      onWillPop: () async {
        AppConstants.pageTransition(context,  USerAttendence());
        return true;
      },
    );
  }

  Widget _buildWidget() {
    return isLoading
        ? Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Select Location",
          style: TextStyle(color: Colors.white),
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
                    title: 'Hello its me (: !',
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
              _setMarker(point);
            },
          ),
          SizedBox(
            height: 84,
            child: AppBar(
              title: const Text("Select Location",
                style: TextStyle(color: Colors.white),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 36.0,
                    width: 124.0,
                    child: GestureDetector(
                      onTap: () {
                        AppConstants.pageTransition(
                          context,
                          USerAttendence(),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  letterSpacing: 1,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 36.0,
                    width: 124.0,
                    child: GestureDetector(
                      onTap: () async {
                        await saveLatLng();
                        Future.delayed(
                          const Duration(milliseconds: 100),
                              () {
                            // AppConstants.pageTransition(
                            //   context,
                            //   widget.formScreen,
                            // );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Text(
                                "Select",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
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
    // pref.setString(
    //   AppConstants.latitude,
    //   currentPosition!.latitude.toStringAsFixed(8),
    // );
    // pref.setString(
    //   AppConstants.longitude,
    //  currentPosition!.longitude.toStringAsFixed(8),
    // );
  }
}
