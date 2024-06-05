import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/widgets/maps_widget/map_theme.dart';

GoogleMapController? mapController;
MapType currentMapType = MapType.normal;

class MainMaps extends StatefulWidget {
  MainMaps({super.key});

  @override
  State<MainMaps> createState() => _MainMapsState();
  static final gKey = GlobalKey();
}

class _MainMapsState extends State<MainMaps> {
  int selectedCarId = 1;
  bool backButtonVisible = true;
  Set<Marker> markers = {};
  LatLng? startLocation;


  @override
  void initState() {
    super.initState();
    startLocationCalculate(true);
    updateMarker();
  }

  @override
  void dispose() {
    super.dispose();
  }



  Future<BitmapDescriptor> getResizedMarkerIcon(String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? resizedData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(resizedData!.buffer.asUint8List());
  }

  Future<void> updateMarker() async {
    var startLocation=await GetCurrentLocation().fetch();
    BitmapDescriptor customIcon = await getResizedMarkerIcon('assets/image/truck.png', 185,75);
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('startLocation'),
        position: startLocation,
        infoWindow: const InfoWindow(
          title: 'Start Location',
        ),
        anchor: const Offset(0.5, 0.5),
        icon: customIcon,
        rotation: direction,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    startLocationCalculate(false);
    print("startLoca> $startLocation");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom:45.0),
        child: startLocation!=null?(GoogleMap(
          markers: markers,
          zoomGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            target: startLocation!,
            zoom: 15.0,
          ),
          mapType: currentMapType, //map type
          onMapCreated: (GoogleMapController controller) {
            controller.setMapStyle(googleMapsTheme);
            setState(() {
              mapController = controller;
            });
          },
        )):const SizedBox.shrink(),
      ),
    );
  }

  void startLocationCalculate(bool isCallSetState) async{
    startLocation=await GetCurrentLocation().fetch();
    if(isCallSetState) {
      setState(() {});
    }
  }

}
