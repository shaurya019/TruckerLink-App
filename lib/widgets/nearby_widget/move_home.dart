import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:trucker/Lists/list.dart';
import 'package:trucker/requests/calculate_distance.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/widgets/maps_widget/map_theme.dart';
import 'package:trucker/widgets/maps_widget/main_map.dart';
import 'package:trucker/widgets/nearby_widget/move_back.dart';
import 'package:trucker/widgets/nearby_widget/response.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class Move extends StatefulWidget {
  final String value;
  final String head;
  LatLng? position;
  Move({super.key, required this.value, required this.head, LatLng? position});

  bool isLoading = false;

  @override
  State<Move> createState() => _MoveState();
}

class _MoveState extends State<Move> with WidgetsBindingObserver {
  List<Marker> allMarkers = [];
  List<String> existNumber = [];
  String apiKey = "AIzaSyCWO_OjMQ5weq00puKyGj47Umf2DJUetp0";
  String radius = "1500";
  late final LocationSettings locationSettings;
  late StreamSubscription<Position> positionStreamSubscription;
  String positionData = 'Unknown';
  GoogleMapController? mapController;
  List<LatLng> latLngList = [];
  BitmapDescriptor? customIcon1;
  BitmapDescriptor? customIcon;
  List<List<bool>> clickedItemsList = [[]];
  int labelIndex = 0;
  LatLng? startLocation;

  @override
  void initState() {
    super.initState();
    startLocationCalculate(true).then((value) {
      initializeLocation();
    });
    locationSettings = const LocationSettings(accuracy: LocationAccuracy.best);
    _loadCustomIcon();
    _loadCustomIcon1();
    WidgetsBinding.instance.addObserver(this);
  }

  int selectedIndex = 5;
  late Uri dialNumber;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      resetClickedItemsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    startLocationCalculate(false);
    return Scaffold(
      body: Stack(
        children: [
          if((widget.position??startLocation)!=null)
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.position??startLocation!,
              zoom: 10.0,
            ),
            markers: Set.from(allMarkers),
            mapType: currentMapType, //map type
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(googleMapsTheme);
              setState(() {
                mapController = controller;
              });
            },
          ),
          Positioned(
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.05,
              right: MediaQuery
                  .of(context)
                  .size
                  .width * 0.05,
              child: const MoveBack()),
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
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child:ListView.builder(
                    itemCount: 1,
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    controller: scrollSheetController,
                    itemBuilder: (BuildContext context, int i) {
                      return searchNearBy(count);
                    },
                  )
                  // SingleChildScrollView(
                  //     child: searchNearBy(count)
                  // )
              );
                // ListView.builder(
                //     itemCount: 1,
                //     padding: EdgeInsets.zero,
                //     physics: const BouncingScrollPhysics(),
                //     controller: scrollSheetController,
                //     itemBuilder: (BuildContext context, int i) {
                //       return searchNearBy(count);
                //     },
                //   ));
            },
          ),
        ],
      ),
    );
  }

  Future<void> startLocationCalculate(bool isCallSetState) async{
    startLocation=await GetCurrentLocation().fetch();
    if(isCallSetState) {
      setState(() {});
    }
  }

  Widget searchNearBy(int count) {
    return Column(
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
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
          child: Container(
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
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.head.toUpperCase(),
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
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Search radius in meters:",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475467)),
              ),
              const SizedBox(
                height: 10,
              ),
              ToggleSwitch(
                minWidth: MediaQuery
                    .of(context)
                    .size
                    .width - 10,
                minHeight: 30.0,
                fontSize: 10.0,
                initialLabelIndex: labelIndex,
                borderColor: const [Colors.transparent],
                dividerColor: Colors.grey,
                activeBgColor: const [Color(0xFFFF8D49)],
                activeFgColor: Colors.white,
                inactiveBgColor: const Color(0xFFF2F4F7),
                inactiveFgColor: const Color(0xFF475467),
                totalSwitches: 5,
                labels: const ['1500', '5000', '10000', '20000', '50000'],
                onToggle: (index) {
                  if (index == 0) {
                    labelIndex = 0;
                    radius = "1500";
                  } else if (index == 1) {
                    labelIndex = 1;
                    radius = "5000";
                  } else if (index == 2) {
                    labelIndex = 2;
                    radius = "10000";
                  } else if (index == 3) {
                    labelIndex = 3;
                    radius = "20000";
                  } else if (index == 4) {
                    labelIndex = 4;
                    radius = "50000";
                  }
                  allMarkers.clear();
                  getNearbyPlaces();
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          width: double.maxFinite,
          height: 0.5,
            child: ColoredBox(color: Color(0x2F000000),)
        ),
        widget.isLoading
            ? count > 0
            ? SizedBox(
          height: 700,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 10,bottom: 80),
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              double distance = double.parse(
                  CalculateDistance.instance.calculateDistance(
                      nearbyPlacesResponse
                          .results![index].geometry!.location!.lat,
                      nearbyPlacesResponse
                          .results![index].geometry!.location!.lng,
                      widget.position?.latitude??startLocation!.latitude,
                      widget.position?.longitude??startLocation!.longitude)
                      .toStringAsFixed(2));
              return Column(
                children: [
                  nearByPlaces(
                      index,
                      nearbyPlacesResponse.results![index],
                      distance,
                      count),
                  if (index < count - 1)
                    const Divider(
                      thickness: 2,
                      color: Color(0xFFEAECF0),
                    ),
                ],
              );
            },
          ),
        )
            : Center(
          child: Container(
            padding:
            const EdgeInsets.only(left: 16, right: 16, top: 68),
            child: Column(
              children: [
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/image/nonearby.svg',
                      width: 64,
                      height: 64,
                      fit: BoxFit
                          .cover, // You can adjust the fit as needed
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Seems like we couldnot find',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF475467),
                          ),
                        ),
                        Text(
                          'the place you are looking for.',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF475467),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text(
                      'Try to search again with different keywords.',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF667085),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        )
            : const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget nearByPlaces(int i, Results results, double distance, int count) {
    int countPics = results.photos?.length ?? 0;
    // double screenHeight = MediaQuery
    //     .of(context)
    //     .size
    //     .height;
    // double calculatedHeight;
    //
    // if (countPics == 0) {
    //   calculatedHeight = screenHeight * 0.23;
    // } else {
    //   calculatedHeight = screenHeight * 0.5;
    // }
    //
    // if (i == count - 1 && countPics == 0) {
    //   calculatedHeight = screenHeight * 0.25;
    // }
    //
    // if (i == count - 1 && countPics != 0) {
    //   calculatedHeight = screenHeight * 0.55;
    // }

    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: const EdgeInsets.only(top: 25,bottom: 25,left: 15,right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              results.name!,
              style: const TextStyle(
                  fontSize: 18,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF475467)),
            ),

            Row(
              children: [
                Text(
                  widget.value,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF98A2B3)),
                ),
                const SizedBox(
                  width: 4,
                ),
                results.openingHours?.openNow == null
                    ? const Text(
                  "|",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF98A2B3)),
                )
                    : Container(),
                const SizedBox(
                  width: 4,
                ),
                results.openingHours?.openNow == null
                    ? Text(
                  results.openingHours?.openNow == true
                      ? 'OPEN'
                      : 'CLOSED',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF98A2B3)),
                )
                    : Container(),

              ],
            ),
            const SizedBox(
              height: 10,
            ),

            Text('Address',
              maxLines: 3,
              style: const TextStyle(
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF98A2B3)),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              results.formattedAddress ??
                  nearbyPlacesResponse.results![i].vicinity ??
                  '',
              maxLines: 3,
              style: const TextStyle(
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF98A2B3)),
            ),
            const SizedBox(
              height: 10,
            ),
            (results.userRatingsTotal != null && results.rating > 0)
                ? Row(
              children: [
                const Text(
                  'Ratings - ',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF98A2B3)),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  results.rating.toString(),
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF98A2B3)),
                ),
                SvgPicture.asset(
                  'assets/image/star.svg',
                  width: 15,
                  height: 15,
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text(
                  "|",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF98A2B3)),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text(
                  'Reviews -',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF98A2B3)),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  results.userRatingsTotal.toString(),
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF98A2B3)),
                ),
              ],
            )
                : Container(),
            const SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(existNumber[i],style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFF8D49))),
                Text('$distance Miles',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF8D49))),
              ],
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,

                // padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: 3,
                itemBuilder: (context, int horizontalIndex) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: clickedItemsList[horizontalIndex][i]
                          ? const Color(0xFFFF8D49)
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
                      onTap: () async {
                        //print("horizontalIndex  ^_^ $horizontalIndex");
                        if (horizontalIndex == 0) {
                          gotoMap(results.geometry?.location!.lat,
                              results.geometry?.location!.lng);
                        }
                        if (horizontalIndex == 1) {
                          String formattedPhoneNumber = '';
                          var x = Uri.parse(
                              'https://maps.googleapis.com/maps/api/place/details/json?place_id=${nearbyPlacesResponse
                                  .results![i]
                                  .placeId}&fields=formatted_phone_number&key=AIzaSyDOVw6Rg-6LYKNsa-tVyrE4G56fWfwlIE0');
                          var res = await http.post(x);
                          var parsedJson = json.decode(res.body);
                          if (parsedJson['result'] != null &&
                              parsedJson['result']
                              ['formatted_phone_number'] !=
                                  null) {
                            formattedPhoneNumber = parsedJson['result']
                            ['formatted_phone_number'];
                            nearbyPlacesResponse
                                .results![i].formattedPhoneNumber =
                                formattedPhoneNumber;
                          } else {
                            nearbyPlacesResponse.results![i]
                                .formattedPhoneNumber = "Not";
                          }
                          if (formattedPhoneNumber != '') {
                            dialNumber = Uri(
                                scheme: 'tel',
                                path: results.formattedPhoneNumber);
                            callNumber(dialNumber);
                          }
                        }
                        if (horizontalIndex == 2) {
                          print("Search Location");
                          Share.share(
                              'Location shared via TruckerLink: ${getMapUrl(results.geometry?.location!.lat,
                                  results.geometry?.location!.lng)}');
                          resetClickedItemsList();
                        }

                        setState(() {
                          for (int rowIndex = 0;
                          rowIndex < clickedItemsList.length;
                          rowIndex++) {
                            for (int colIndex = 0;
                            colIndex <
                                clickedItemsList[rowIndex].length;
                            colIndex++) {
                              clickedItemsList[rowIndex][colIndex] =
                                  (rowIndex == horizontalIndex) &&
                                      (colIndex == i);
                            }
                          }
                          selectedIndex = 5;
                        });
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            color: !clickedItemsList[horizontalIndex][i]
                                ? const Color(0xFF475466)
                                : Colors.white,
                            nearByTabIcons[horizontalIndex],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            nearByTabItems[horizontalIndex],
                            style: TextStyle(
                              color: clickedItemsList[horizontalIndex]
                              [i]
                                  ? Colors.white
                                  : const Color(0xFF475466),
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
            if(countPics>0)
            const SizedBox(height: 18),
            showList(i, countPics, results),
          ],
        ));
  }

  Widget showList(int i, int countPics, Results results) {
    return countPics>0?SizedBox(
      height: 198,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=300&photo_reference=${results
              .photos?[0]
              .photoReference}&key=AIzaSyCWO_OjMQ5weq00puKyGj47Umf2DJUetp0',
          fit: BoxFit.cover,
        ),
      ),
    ):const SizedBox.shrink();
  }

  gotoMap(double? lat, double? lng) {
    try {
      var url = getMapUrl(lat, lng);
      final Uri _url = Uri.parse(url);
      launchUrl(_url);
    } catch (_) {
      print("Error launch Map");
    }
  }

  getMapUrl(double? lat, double? lng) {
    return
        "https://www.google.com/maps/dir/?api=1&destination=${lat},${lng}";
  }

  void resetClickedItemsList() {
    setState(() {
      clickedItemsList = List.generate(
        nearByTabItems.length,
            (index) =>
            List.filled(nearbyPlacesResponse.results?.length ?? 0, false),
      );
    });
  }

  Future<BitmapDescriptor> getResizedMarkerIcon(String path, int width,
      int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? resizedData =
    await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(resizedData!.buffer.asUint8List());
  }

  Future<void> initializeLocation() async {
    await getNearbyPlaces();
  }

  callNumber(Uri dialNumber) async {
    await launchUrl(dialNumber);
  }

  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  Future<void> _loadCustomIcon() async {
    customIcon = await getResizedMarkerIcon('assets/image/truck.png', 185, 75);
    setState(() {});
  }

  Future<void> _loadCustomIcon1() async {
    customIcon1 =
    await getResizedMarkerIcon('assets/image/vector.png', 85, 100);
    await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(0, 0)),
      'assets/image/vector.png',
    );
    setState(() {});
  }

  Future<void> getNearbyPlaces() async {
    // startLocation=LatLng(34.1047201,-118.1043193);
    var url;

    switch (widget.head) {
      case "Pilot & Flying J Travel Centers":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query="Pilot+Travel+Center" OR "Flying+J+Travel+Center"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "TA & Petro Travel Centers":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query="TA+Travel+Center" OR "Petro+Travel+Center"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Loves Stations":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query="Love\'s+Travel+Center" OR "Love\'s+Travel+Stop"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Truck Stops":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query="Truck Stop"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Kwik Trip Centers":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=Kwik+Trip&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Hotels":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=hotels with "truck parking"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Gas Stations":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=gas+station&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Parkings":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query="truck Parking"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Walmarts":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query="Walmarts"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Atm":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword="Atm"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Laundry Shops":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query="Laundry Shop"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Stores":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query=Stores with "truck parking"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "WIFI":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query=WIFI with "truck parking"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Gyms":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query="Gym" or"fitness"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Restaurants":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query="Restaurants"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Truck Washes":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query="Truck Wash"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Repair Shops":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query="truck Repair Shop"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Tire Care Shops":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query="truck repair shop"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Rest Areas":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query=Rest areas with "truck parking"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Fuels":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query="truck fuel"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Showers":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query=restroom with "truck parking"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Scales":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query=Scales truck with "truck parking"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "Weigh Stations":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query="weigh+station"+Truck&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
      case "RV Parks":
        url = Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query="RV Park"&location=${widget.position
                ?.latitude??startLocation!.latitude},${widget.position
                ?.longitude??startLocation!.longitude}&radius=$radius&key=$apiKey');
        break;
    }
    var response;
    try {
      response = await http.get(url);
      // print("Body - ${response.body}");
    } catch (e) {
      print("err> ${e}");
    }
    nearbyPlacesResponse = NearbyPlacesResponse.fromJson(jsonDecode(response.body));
    int count = nearbyPlacesResponse.results?.length ?? 0;
    clickedItemsList = List.generate(
        nearByTabItems.length, (index) => List.filled(count, false));
    for (int i = 0; i < count; i++) {
      double? latitude =
          nearbyPlacesResponse.results![i].geometry?.location!.lat ?? 0.0;
      double? longitude =
          nearbyPlacesResponse.results![i].geometry?.location!.lng ?? 0.0;
      String vin = nearbyPlacesResponse.results![i].vicinity ?? '';
      LatLng newLatLng = LatLng(latitude, longitude);
      latLngList.add(newLatLng);
      String existLat = latitude.toString();
      String existLng = longitude.toString();
      latLngList.add(newLatLng);
      print("Here Home>>>>");
      var urlForExitNumber = Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.position?.latitude??startLocation!.latitude},${widget.position?.longitude??startLocation!.longitude}&destination=$existLat,$existLng&key=AIzaSyCWO_OjMQ5weq00puKyGj47Umf2DJUetp0');
      var responseForExitNumber = await http.post(urlForExitNumber);
      var parsedJsonForExitNumber = jsonDecode(responseForExitNumber.body);
      print("parsedJsonForExitNumber ^_^ $parsedJsonForExitNumber");
      String exitInstruction = "";
      RegExp regExp = RegExp(r'Take exit .+?(?=<|$)');
      var steps = parsedJsonForExitNumber['routes'][0]['legs'][0]['steps'];
      print("Step ^_^ $steps");
      for (var step in steps) {
        if (step.containsKey('html_instructions')) {
          var match = regExp.firstMatch(step['html_instructions']);
          print("Match ^_^ $match");
          if (match != null) {
            exitInstruction = match.group(0)!;
            print("exitInstruction ^_^ $exitInstruction");
            // break;
          }
        }
      }
      if (exitInstruction.isEmpty) {
        existNumber.add('Exit number unavailable');
      }else{
        var document = parse(exitInstruction);
        String plainText = document.body!.text;
        existNumber.add(plainText);
      }
      print('Exit Instruction: $exitInstruction : ${existNumber.length}');
      allMarkers.add(Marker(
        markerId: const MarkerId('Own'),
        draggable: false,
        position: widget.position??startLocation!,
        icon: customIcon ?? BitmapDescriptor.defaultMarker,
        anchor: const Offset(0.5, 0.5),
      ));
      allMarkers.add(Marker(
          markerId: MarkerId(
              nearbyPlacesResponse.results![i].formattedAddress ?? vin),
          draggable: false,
          icon: customIcon1 ?? BitmapDescriptor.defaultMarker,
          position: newLatLng));
    }
    widget.isLoading = true;
    setState(() {});
  }
}