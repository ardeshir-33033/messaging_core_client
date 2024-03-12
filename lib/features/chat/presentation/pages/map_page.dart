import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late GoogleMapController mapController;

  LocationData? currentLocation;
  PermissionStatus? _permissionGranted;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    Location location = Location();
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }

    if (currentLocation != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 15,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            key: const Key('GoogleMap'),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: const CameraPosition(
              target: LatLng(
                48.796566,
                9.208445,
              ),
              zoom: 5,
            ),
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
              mapController = controller;
              setState(() {});
            },
          ),
          const IconWidget(
            icon: Icons.location_on,
            size: 35,
            iconColor: Colors.red,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton(
                child: const SizedBox(
                  width: 100,
                  height: 50,
                  child: Center(child: Text("Select")),
                  // color: Colors.red,
                ),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<LatLng> getCenter() async {
    LatLngBounds visibleRegion = await mapController.getVisibleRegion();
    LatLng centerLatLng = LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) /
          2,
    );

    return centerLatLng;
  }
}
