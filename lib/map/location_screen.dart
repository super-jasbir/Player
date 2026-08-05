import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import '../app_controller.dart';
import '../utils/app_color.dart';
import '../utils/app_components.dart';
import '../utils/app_fonts.dart';
import 'package:player/core/services/tap_sound.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapState();
}

class _MapState extends State<Maps> {
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  int _markerIdCounter = 0;
  var basePosition = const LatLng(28.7041, 77.1025); // Temporary initial position
  LatLng? currentPosition;
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? googleMapController;

  var appC = Get.find<AppController>();

  var localityC = TextEditingController();
  var shopC = TextEditingController();
  var streetC = TextEditingController();
  var localityN = FocusNode();
  var shopN = FocusNode();
  var streetN = FocusNode();
  double bottomSheetSize = 470;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    var _currentLocation = await _determinePosition();
    LatLng newPosition = LatLng(_currentLocation.latitude, _currentLocation.longitude);
    setState(() {
      currentPosition = newPosition;
    });

    // Move camera to the current location
    if (googleMapController != null) {
      googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: newPosition, zoom: 14.0),
      ));
    }
  }

  Future<void> _moveToCurrentLocation() async {
    var _currentLocation = await _determinePosition();
    LatLng newPosition = LatLng(_currentLocation.latitude, _currentLocation.longitude);
    setState(() {
      currentPosition = newPosition;
    });

    googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: newPosition, zoom: 14.0),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                GoogleMap(
                  markers: Set<Marker>.of(_markers.values),
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: currentPosition ?? basePosition,
                    zoom: 12.0,
                  ),
                  myLocationEnabled: false,
                  onTap: (LatLng position) {},
                  onCameraMove: _onCameraMove,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Container(
                      height: 60,
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 18,
                          ),
                          NoTapSound(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(Icons.arrow_back_ios_new_outlined)),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: AppComponents.text("Location",
                                color: AppColors.black, size: 16),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 40,
                          )
                        ],
                      )),
                ),
                Center(
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.appColor,
                      size: 50,
                    )),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 200,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(10),
                            child: Padding(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: Column(children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          AppComponents.text("Select Location",
                                              size: 16, color: Colors.black),
                                          Spacer(),
                                          InkWell(
                                              onTap: _moveToCurrentLocation,
                                              child: AppComponents.text(
                                                  "Use Current Location",
                                                  color: AppColors.appColor,
                                                  size: 12,
                                                  fontWeight: FontWeight.w700,
                                                  enableUnderLine: true))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 19,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_rounded,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: AppComponents.text(
                                                "${appC.locationLatLng}",
                                                size: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: AppComponents.appButton("Proceed")),
                                SizedBox(
                                  height: 8,
                                )
                              ]),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  void _onCameraMove(CameraPosition position) {
    currentPosition = position.target;
    getAddress(position);
  }

  getAddress(CameraPosition position) async {
    position;
    placemarkFromCoordinates(
        position.target.latitude, position.target.longitude)
        .then((placemarks) {
      var output = 'No results found.';
      if (placemarks.isNotEmpty) {
        var locality = placemarks[0].locality ?? "Locality";
        var street = placemarks[0].street ?? "";
        var postalCode = placemarks[0].postalCode ?? "";
        var country = placemarks[0].country ?? "";
        var sublocality = placemarks[0].subLocality ?? "";

        localityC.text = locality;
        streetC.text = street;

        setState(() {
          currentPosition =
              LatLng(position.target.latitude, position.target.longitude);

          var sub = sublocality.isNotEmpty ? "$sublocality," : "";
          appC.locationLatLng =
          "$locality , $street , $postalCode  $sublocality ";
          appC.currentLoc.value = locality;
        });
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    googleMapController = controller;
    _mapController.complete(controller);

    // Move to current location when the map is created
    await getCurrentLocation();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
