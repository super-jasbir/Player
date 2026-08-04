import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:player/common_widgets.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:player/data/modal/game/game_list_response.dart';
import 'package:player/data/network/api_endpoints.dart';
import 'package:player/game/game_controller.dart';

import '../data/modal/game/game_detail_response.dart';

class LocationMap extends StatefulWidget {

  final List<OutletDetail> outlets;
  final LatLng? currentLocation;
  final String markerImageUrl;
  final String gameUniqueId;


  const LocationMap({
    super.key,
    required this.outlets,
    this.currentLocation,
    required this.markerImageUrl,
    required this.gameUniqueId
  });

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  var controller = Get.put(GameController());
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  Future<void> _initializeMarkers() async {

    var outletList = widget.outlets.map((e) => LatLng(double.parse(e.lat.toString()).toDouble(), double.parse(e.long).toDouble())).toList();

    try {
      final newMarkers = <Marker>{};

      // Add outlet markers
      for (int i = 0; i < outletList.length; i++) {
        var image = ApiEndPoint.imageBaseUrl+"merchant/"+widget.outlets[i].initalImage.toString();
        print("imageUrl $image");

        final BitmapDescriptor customIcon = await _getNetworkImageMarker(image);
        newMarkers.add(
          Marker(
            markerId: MarkerId('location_$i'),
            position: widget.outlets.map((e) => LatLng(double.parse(e.lat), double.parse(e.long))).toList()[i],
            infoWindow: InfoWindow(title: 'Location ${i + 1}'),
            icon: customIcon,
            //   icon: await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            onTap: (){
              // controller.pickImage(camera: true, context: context);
              // controller.gameComplete( widget.gameUniqueId,
              //     widget.outlets[i]
              //     ,() {
              //   Navigator.pop(context);
              //   Fluttertoast.showToast(msg: "Game completed");
              // });
            }
            // icon: await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        );
      }

      // Add current location marker if available
      // if (widget.currentLocation != null) {
      //   newMarkers.add(
      //     Marker(
      //       markerId: const MarkerId('current_location'),
      //       position: widget.currentLocation!,
      //       infoWindow: const InfoWindow(title: 'Your Location'),
      //       icon: await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      //     ),
      //   );
      // }

      setState(() {
        _markers = newMarkers;
        _isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _adjustCameraToMarkers();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Error initializing markers: $e");
    }
  }

  Future<BitmapDescriptor> _getNetworkImageMarker(String imageUrl) async {
    try {
      final response = await Dio().get<Uint8List>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final Uint8List bytes = response.data!;

      // Resize the image to appropriate marker size
      final codec = await ui.instantiateImageCodec(bytes, targetWidth: 100,targetHeight: 100);
      final frameInfo = await codec.getNextFrame();
      final ByteData? byteData = await frameInfo.image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
    } catch (e) {
      debugPrint("Error loading custom marker: $e");
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    }
  }

  void _adjustCameraToMarkers() {
    if (_markers.isEmpty) return;

    final bounds = _calculateBounds();
    final cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);

    _mapController.animateCamera(cameraUpdate);
  }

  LatLngBounds _calculateBounds() {
    var latLngList = _markers.map((m) => m.position).toList();

    double? minLat, maxLat, minLng, maxLng;
    for (var latLng in latLngList) {
      minLat = (minLat == null || latLng.latitude < minLat)
          ? latLng.latitude
          : minLat;
      maxLat = (maxLat == null || latLng.latitude > maxLat)
          ? latLng.latitude
          : maxLat;
      minLng = (minLng == null || latLng.longitude < minLng)
          ? latLng.longitude
          : minLng;
      maxLng = (maxLng == null || latLng.longitude > maxLng)
          ? latLng.longitude
          : maxLng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(1.3521, 103.8198),
              zoom: 12,
            ),
            myLocationEnabled: widget.currentLocation == null,
            myLocationButtonEnabled: true,
            markers: _markers,
            // Keeps the map clear of the floating back button.
            padding: const EdgeInsets.only(top: 64),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          _backButton(),
        ],
      ),
    );
  }

  /// Floating back control, styled like the other new-UI screens instead of a
  /// Material app bar so the map stays full-bleed.
  Widget _backButton() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 12.w, top: 8.h),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const BackToLoginButton(text: 'Back'),
          ),
        ),
      ),
    );
  }
}