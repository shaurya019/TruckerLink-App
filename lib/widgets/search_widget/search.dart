import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:trucker/widgets/maps_widget/map_theme.dart';
import 'package:trucker/widgets/maps_widget/main_map.dart';


class MapSearchScreen extends StatefulWidget {
  final DetailsResult? startPosition;
  const MapSearchScreen({Key? key, this.startPosition})
      : super(key: key);
  @override
  _MapSearchScreenState createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  BitmapDescriptor? customIcon;
  int selectedCarId = 1;
  bool backButtonVisible = true;


  late CameraPosition _initialPosition;
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _initialPosition = CameraPosition(
      target: LatLng(widget.startPosition!.geometry!.location!.lat!,
          widget.startPosition!.geometry!.location!.lng!),
      zoom: 14.4746,
    );
    _loadCustomIcon();
  }

  Future<BitmapDescriptor> getResizedMarkerIcon(String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? resizedData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(resizedData!.buffer.asUint8List());
  }


  Future<void> _loadCustomIcon() async {
    customIcon = await getResizedMarkerIcon('assets/image/vector.png',100, 100);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (customIcon == null) {
      return const CircularProgressIndicator(); }

    Set<Marker> _markers = {
      Marker(
        markerId: const MarkerId('start'),
        icon: customIcon!,
        position: LatLng(
          widget.startPosition!.geometry!.location!.lat!,
          widget.startPosition!.geometry!.location!.lng!,
        ),
      ),
    };

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(42.0),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x4D000000),
                  offset: Offset(0, 1),
                  blurRadius: 3,
                ),
                BoxShadow(
                  color: Color(0x26000000),
                  offset: Offset(0, 4),
                  blurRadius: 8,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Stack(
          children: [
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    height: constraints.maxHeight,
                      child: GoogleMap(
                      initialCameraPosition: _initialPosition,
                      markers: Set.from(_markers),
                        mapType: currentMapType, //map type
                        onMapCreated: (GoogleMapController controller) {
                          controller.setMapStyle(googleMapsTheme);
                        },
                  ),
                  );
                }),
          ]),
    );
  }
}

