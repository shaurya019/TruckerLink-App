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

class PolyLineHelpWidget extends StatefulWidget {
  final LatLng? pos;
  String distance;

  PolyLineHelpWidget({Key? key,required this.pos,required this.distance})
      : super(key: key);
  @override
  _PolyLineHelpWidgetState createState() => _PolyLineHelpWidgetState();
}

class _PolyLineHelpWidgetState extends State<PolyLineHelpWidget> {
  BitmapDescriptor? customIcon;
  BitmapDescriptor? customIcon1;
  Map<PolylineId, Polyline> polyLines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  CameraPosition? _initialPosition;
  final Completer<GoogleMapController> controller = Completer();

  LatLng? startLocation;

  @override
  void initState() {
    super.initState();
    startLocationCalculate(false);

    _loadCustomIcon();
    _loadCustomIcon1();
  }

  void startLocationCalculate(bool isCallSetState) async{
    startLocation=await GetCurrentLocation().fetch();
    if(isCallSetState) {
      setState(() {});
    }
    _initialPosition = CameraPosition(
      target: LatLng(startLocation!.latitude,
          startLocation!.longitude),
      zoom: 10,
    );
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

  _getPolylinePos() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyDOVw6Rg-6LYKNsa-tVyrE4G56fWfwlIE0',
        PointLatLng(startLocation!.latitude,
            startLocation!.longitude),
        PointLatLng(widget.pos!.latitude, widget.pos!.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
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
    customIcon1 = await getResizedMarkerIcon('assets/image/greyErrorTruck.png',185, 75);
    setState(() {});
  }

  void checkZoomLevel(GoogleMapController control, LatLngBounds bounds, double zoomLevel) async {
    print("_zoomBasedOnDistance ***");
    control.animateCamera(CameraUpdate.zoomTo(zoomLevel));
  }

  Future<void> _zoomBasedOnDistance(GoogleMapController control) async {
    print("_zoomBasedOnDistance *");
    print("polylineCoordinates -> ${polylineCoordinates.length}");
    print("_zoomBasedOnDistance **");
    double distance = double.parse(widget.distance);
    double zoomLevel = _determineZoomLevel(distance);
    LatLngBounds bounds = MapUtils.boundsFromLatLngList(polylineCoordinates);
    control.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50)).then((void v) {
      checkZoomLevel(control, bounds, zoomLevel);
    });
  }

  double _determineZoomLevel(double distance) {
    if (distance < 2) return 15;
    if (distance < 5) return 13;
    return 10; // default zoom
  }



  @override
  Widget build(BuildContext context) {
    startLocationCalculate(false);
    Set<Marker> mapMarkers = {
      if(startLocation!=null)
      Marker(
        markerId: const MarkerId('startingPoint'),
        position: LatLng(startLocation!.latitude,
            startLocation!.longitude),
        icon: customIcon ?? BitmapDescriptor.defaultMarker,
        anchor: const Offset(0.5, 0.5),
      ),

      Marker(
        markerId: const MarkerId('endingPoint'),
        position: LatLng(widget.pos!.latitude, widget.pos!.longitude),
        icon: customIcon1 ?? BitmapDescriptor.defaultMarker,
        anchor: const Offset(0.5, 0.5),
      )

    };
    // print("Location -> ${startLocation.latitude} -> ${startLocation.longitude}");
    return  (_initialPosition!=null)?Padding(
      padding: const EdgeInsets.only(bottom:20.0),
      child:  SizedBox(
        height: 250,
        child: GoogleMap(
          polylines: Set<Polyline>.of(polyLines.values),
          initialCameraPosition: _initialPosition!,
          markers: Set.from(mapMarkers),
          onMapCreated: (GoogleMapController control) async{
            await _getPolylinePos();
            control.setMapStyle(googleMapsTheme);
              _zoomBasedOnDistance(control);
          },
        ),
      ),
    ):const SizedBox.shrink();
  }
}