import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/widgets/custom_widget/map_utils.dart';
import 'package:trucker/widgets/help_widget/help_direction.dart';
import 'package:trucker/widgets/maps_widget/map_theme.dart';
import 'package:trucker/widgets/maps_widget/main_map.dart';

class NavigateMapScreen extends StatefulWidget {
  final DetailsResult? endPosition;

   NavigateMapScreen({Key? key,this.endPosition})
      : super(key: key);
  @override
  _NavigateMapScreenState createState() => _NavigateMapScreenState();
}

class _NavigateMapScreenState extends State<NavigateMapScreen> {
  BitmapDescriptor? customIcon;
  BitmapDescriptor? customIcon1;
  Map<PolylineId, Polyline> polyLines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  int selectedCarId = 1;
  bool backButtonVisible = true;
  LatLng? startLocation;

  late CameraPosition _initialPosition;
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    startLocationCalculate(true);
    _initialPosition = CameraPosition(
      target: LatLng(startLocation!.latitude,
          startLocation!.longitude),
      zoom: 18,
    );
    _loadCustomIcon();
    _loadCustomIcon1();
  }
  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 5);
    polyLines[id] = polyline;
    setState(() {});
  }

  _getPolylineEndPos() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyDOVw6Rg-6LYKNsa-tVyrE4G56fWfwlIE0',
        PointLatLng(startLocation!.latitude,
            startLocation!.longitude),
        PointLatLng(widget.endPosition!.geometry!.location!.lat!,
            widget.endPosition!.geometry!.location!.lng!),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  _getPolylinePos() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyDOVw6Rg-6LYKNsa-tVyrE4G56fWfwlIE0',
        PointLatLng(startLocation!.latitude,
            startLocation!.longitude),
        PointLatLng(widget.endPosition!.geometry!.location!.lat!,
            widget.endPosition!.geometry!.location!.lng!),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  Future<BitmapDescriptor> getResizedMarkerIcon(String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? resizedData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(resizedData!.buffer.asUint8List());
  }


  Future<void> _loadCustomIcon() async {
      customIcon =  await getResizedMarkerIcon('assets/image/truck.png', 185, 75);
      setState(() {});
  }

  Future<void> _loadCustomIcon1() async {
    customIcon1 = await getResizedMarkerIcon('assets/image/vector.png',100, 100);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    startLocationCalculate(false);
    Set<Marker> _markers = {
      Marker(
          markerId: MarkerId('start'),
          position: LatLng(startLocation!.latitude,
              startLocation!.longitude),
        icon: customIcon ?? BitmapDescriptor.defaultMarker,
        anchor: const Offset(0.5, 0.5),
      ),

      Marker(
          markerId: MarkerId('end'),
          position: LatLng(widget.endPosition!.geometry!.location!.lat!,
              widget.endPosition!.geometry!.location!.lng!),
        icon: customIcon1 ?? BitmapDescriptor.defaultMarker,
        anchor: const Offset(0.5, 0.5),
        )

    };

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
          children: [
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    height: constraints.maxHeight,
                    child: GoogleMap(
                      polylines: Set<Polyline>.of(polyLines.values),
                      initialCameraPosition: _initialPosition,
                      markers: Set.from(_markers),
                      onMapCreated: (GoogleMapController controller) {
                        controller.setMapStyle(googleMapsTheme);
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          controller.animateCamera(CameraUpdate.newLatLngBounds(
                              MapUtils.boundsFromLatLngList(
                                  _markers.map((loc) => loc.position).toList()),
                              1));
                         _getPolylinePos();
                        });
                      },
                    ),
                  );
                }),
          ]),
    );
  }

  void startLocationCalculate(bool isCallSetState) async{
    startLocation=await GetCurrentLocation().fetch();
    if(isCallSetState) {
      setState(() {});
    }
  }


}