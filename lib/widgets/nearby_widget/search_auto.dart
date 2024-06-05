import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trucker/Lists/list.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/widgets/home_widget/near_by_search.dart';
import 'package:trucker/widgets/maps_widget/map_theme.dart';
import 'package:trucker/widgets/maps_widget/main_map.dart';
import 'package:trucker/widgets/nearby_widget/move_back.dart';
import 'package:trucker/widgets/nearby_widget/response.dart';
import 'package:url_launcher/url_launcher.dart';

class AutoNear extends StatefulWidget {
  final String value;
  AutoNear({super.key, required this.value});

  @override
  State<AutoNear> createState() => _AutoNearState();
}

class _AutoNearState extends State<AutoNear> {
  List<Marker> allMarkers = [];
  String apiKey = "AIzaSyCWO_OjMQ5weq00puKyGj47Umf2DJUetp0";
  late final LocationSettings locationSettings;
  late StreamSubscription<Position> positionStreamSubscription;
  String positionData = 'Unknown';
  GoogleMapController? mapController;
  BitmapDescriptor? customIcon;
  BitmapDescriptor? customIcon1;
  LatLng? startLocation;
  List<List<bool>> clickedItemsList = List.generate(
      nearByTabItems.length, (index) => List.filled(stuff.length, false));
  @override
  void initState() {
    super.initState();
    startLocationCalculate(true);
    initializeLocation();
    locationSettings = const LocationSettings(accuracy: LocationAccuracy.best);
    _loadCustomIcon();
    _loadCustomIcon1();
  }
  Future<BitmapDescriptor> getResizedMarkerIcon(String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? resizedData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(resizedData!.buffer.asUint8List());
  }


  Future<void> initializeLocation() async {
    await getNearbyPlaces();
  }

  int selectedIndex = 5;

  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  @override
  Widget build(BuildContext context) {
    startLocationCalculate(false);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: startLocation!,
              zoom: 5.0,
            ),
            minMaxZoomPreference: const MinMaxZoomPreference(13, 22),
            markers: Set.from(allMarkers),
            mapType: currentMapType, //map type
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(googleMapsTheme);
              setState(() {
                mapController = controller;
              });
            },
          ),
          const Positioned(top: 57, right: 50, child: MoveBack()),
          DraggableScrollableSheet(
            initialChildSize: 0.27,
            minChildSize: 0.27,
            maxChildSize: .92,
            snapSizes: const [0.27, .92],
            snap: true,
            builder: (BuildContext context, scrollSheetController) {
              int count = nearbyPlacesResponse.results?.length ?? 0;
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: ListView.builder(
                  itemCount: 1,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  controller: scrollSheetController,
                  itemBuilder: (BuildContext context, int i) {
                    return searchNearBy(count);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void startLocationCalculate(bool isCallSetState) async{
    startLocation=await GetCurrentLocation().fetch();
    if(isCallSetState) {
      setState(() {});
    }
  }

  Future<void> _loadCustomIcon() async {
    customIcon =  await getResizedMarkerIcon('assets/image/truck.png', 185, 75);
    setState(() {});
  }

  Future<void> _loadCustomIcon1() async {
    customIcon1 = await getResizedMarkerIcon('assets/image/vector.png',100, 100);
    setState(() {});
  }

  Future<void> getNearbyPlaces() async {
    if (stuff.length > 0) {
      for (int i = 0; i < stuff.length; i++) {
        double? latitude = stuff[i].geometry?.location!.lat ?? 0.0;
        double? longitude = stuff[i].geometry?.location!.lng ?? 0.0;
        LatLng newLatLng = LatLng(latitude, longitude);
        String val = stuff[i].name ?? "No";
        String pinmake = val + i.toString();
        allMarkers.add(Marker(
          markerId: const MarkerId('Own'),
          draggable: false,
          position: startLocation!,
          icon: customIcon ?? BitmapDescriptor.defaultMarker,
          anchor: const Offset(0.5, 0.5),
        ));
        allMarkers.add(Marker(
            markerId: MarkerId(pinmake),
            draggable: false,
            icon: customIcon1 ?? BitmapDescriptor.defaultMarker,
            position: newLatLng));
      }
    }
    setState(() {});
  }

  Widget searchNearBy(int count) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 36,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.5),
              color: const Color(0xFFD0D5DD),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 24),
              width: double.infinity,
              height: 56,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(43),
                color: const Color(0xFFf2f4f7),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/image/search.svg',
                    height: 18,
                    width: 18,
                    color: const Color(0xFF475467),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.value,
                      style: const TextStyle(
                        color: Color(0xFF475467),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    color: Color(0xFF98A2B3),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 700,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  stuff.length,
                      (index) {
                    return Column(
                      children: [
                        SizedBox(height: 24,),
                        nearBy(index,stuff.length),
                        if (index < stuff.length - 1)
                          const Divider(thickness: 3),
                        if (index == stuff.length - 1)
                          const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nearBy(int i,int count) {
    int countPics = stuff[i].photos?.length ?? 0;
    String nameValue = stuff[i].name ?? "No";
    String vinValue = stuff[i].vicinity ?? "No";
    double x = 320;
    if (countPics == 0) {
      x = 130;
    }
    if(i==count-1 && countPics == 0){
      x = 180;
    }

    if(i==count-1 && countPics != 0){
      x = 360;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: x,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // place name
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              nameValue,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475467),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // place address
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              overflow: TextOverflow.ellipsis,
              vinValue,
              style: const TextStyle(
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF98A2B3)),
            ),
          ),
          const SizedBox(height: 4),
          //open or close
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  widget.value.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF98A2B3),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  "|",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF98A2B3),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  stuff[i].openingHours != null ? "OPEN" : "CLOSED",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF98A2B3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: Center(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: nearByTabItems.length,
                itemBuilder: (context, int horizontalIndex) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: clickedItemsList[horizontalIndex][i]
                          ? Color(0xFFFF8D49)
                          : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        side: !clickedItemsList[horizontalIndex][i]
                            ? const BorderSide(
                          width: 1,
                          color: Color(0xFFCFD4DC),
                        )
                            : BorderSide.none,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        print("horizontalIndex  ^_^ $horizontalIndex");
                        if(horizontalIndex==0){
                          gotoMap(stuff[i].geometry!.location!.lat!,stuff[i].geometry!.location!.lng!);
                        }
                        if(horizontalIndex==1){
                        }
                        if(horizontalIndex==2){
                          Share.share('Searched Location - ${stuff[i].name}');
                        }
                        if (horizontalIndex == 3) {
                          print("Exit Number - Not Available");
                        }
                        setState(() {
                          for (int rowIndex = 0;
                          rowIndex < clickedItemsList.length;
                          rowIndex++) {
                            for (int colIndex = 0;
                            colIndex < clickedItemsList[rowIndex].length;
                            colIndex++) {
                              clickedItemsList[rowIndex][colIndex] =
                                  (rowIndex == horizontalIndex) &&
                                      (colIndex == i);
                            }
                          }
                        });
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            color: !clickedItemsList[horizontalIndex][i]
                                ? Color(0xFF475466)
                                : Colors.white,
                            nearByTabIcons[horizontalIndex],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            nearByTabItems[horizontalIndex],
                            style: TextStyle(
                              color: clickedItemsList[horizontalIndex][i]
                                  ? Colors.white
                                  : Colors.green,
                                  // : Color(0xFF475466),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (countPics != 0) showList(i, countPics),
        ],
      ),
    );
  }

  Widget showList(int i, int countPics) {
    return SizedBox(
      height: 158,
      width: double.infinity,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: countPics,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemBuilder: (context, int index) {
          return Container(
            height: 158,
            width: 158,
            margin: const EdgeInsets.only(right: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://maps.googleapis.com/maps/api/place/photo?maxwidth=300&photo_reference=${stuff[i].photos?[index].photoReference}&key=AIzaSyCWO_OjMQ5weq00puKyGj47Umf2DJUetp0',
                fit: BoxFit.fill,
              ),
            ),
          );
        },
      ),
    );
  }

  gotoMap(double? lat, double? lng) {
    try {
      var url =
          "https://www.google.com/maps/dir/?api=1&destination=${lat},${lng}";
      final Uri _url = Uri.parse(url);
      launchUrl(_url);
    } catch (_) {
      print("Error launch Map");
    }
  }

}
