import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:b_dep/b_dep.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:trucker/main.dart';
import 'package:trucker/requests/alert_fetch.dart';
import 'package:trucker/requests/calculate_distance.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/widgets/help_widget/help_safety_page.dart';
import 'package:trucker/widgets/maps_widget/map_theme.dart';
import 'package:trucker/widgets/maps_widget/main_map.dart';

class NearbyPerson {
  String name;
  String image;
  String phoneNumber;
  String userId;
  String compassPoint;
  String status;
  String pastTime;
  NearbyPerson(this.name,this.image, this.phoneNumber, this.userId,this.compassPoint,this.status,this.pastTime);
  // NearbyPerson(this.name,this.image, this.phoneNumber, this.userId);
}


bool flag = false;
bool compassDir = false;
bool flagDir = false;
GoogleMapController? helpMapController;
LatLng posLocation = const LatLng(28.612894, 77.229446);
bool getContacts = false;
Set<String> numberWanted = {};
List<NearbyPerson> peopleAround = [];
double compassDirection = 0.0;
StreamSubscription<CompassEvent>? compassSubscription;
Set<Marker> allMarkers = {};

class HelpMaps extends StatefulWidget {
  // final GlobalKey<helpMapController> globalKey;
  // const HelpMaps({super.key,required this.globalKey});
  @override
  State<HelpMaps> createState() => _HelpMapsState();
  static final hKey = GlobalKey();
}


class _HelpMapsState extends State<HelpMaps> {
  final Completer<GoogleMapController> _controller = Completer();
  late final LocationSettings locationSettings;
  StreamSubscription<Position>? positionStreamSubscription;
  LatLng positionLatLng = const LatLng(28.612894, 77.229446);
  String positionData = 'Unknown';
  int selectedCarId = 1;
  BitmapDescriptor? customIcon;
  BitmapDescriptor? customTruck;
  bool isFirstTimeCalled = false;
  bool f = false;
  late Timer _timer;
  LatLng? startLocation;

  @override
  void initState() {
    super.initState();

    FlutterCompass.events!.listen((CompassEvent event) {
      updateCompassDir(event);
    });

    getSafetyAlertNotify(context: context);

    containLocation();

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      numberWanted.clear();
      getSafetyAlertNotify(context: context);
      // print("Change in containLocation");
      containLocation();
    });
    locationSettings = const LocationSettings(accuracy: LocationAccuracy.best);
    startLocationCalculate(true);
  }

  void startLocationCalculate(bool isCallSetState) async{
    startLocation=await GetCurrentLocation().fetch();
    if(isCallSetState) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    positionStreamSubscription?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // print("Map change");
    startLocationCalculate(false);
    // print("startLocal> $startLocation");
    return Scaffold(
      body: startLocation!=null?(GoogleMap(
        markers: Set.from(allMarkers),
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: startLocation!,
          zoom: 10.0,
        ),
        circles: {
          Circle(
              circleId: const CircleId("1"),
              strokeWidth: 5,
              radius: 16093.4,
              strokeColor: const Color(0xFFFF8D49),
              fillColor: const Color(0xFFFF8D49).withOpacity(0.1),
              center:  startLocation!),
        },
        mapType: currentMapType,
        //map type
        onMapCreated: (controller) async {
          if (flag == false) {
            flag = true;
            await requestLocationPermission();
          }
          controller.setMapStyle(googleMapsTheme);
          setState(() {
            helpMapController = controller;
          });
          _controller.complete(controller);
        },
      )): const SizedBox.shrink(),
    );
  }

  Timer? timer;

  void updateCompassDir (CompassEvent event) {
    if(mounted){
      double x = - event.heading!;
      if(flagDir==false){
        flagDir = true;
        direction = x;
      }
        direction = x;
      var newDirection = direction.abs();
      var diff = (newDirection - prevDirection).abs();
        if(diff > 2){
          prevDirection = newDirection.toDouble();
          // timer?.cancel();
          // timer = Timer(const Duration(milliseconds: 100), () {
          //   updateMarkerHelp(startLocation);
          //   changeCompassPoints(direction.toString());
          // });
          updateMarkerHelp(startLocation!);
          changeCompassPoints(direction.toString());
        }
      // }
    }
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      print("positionStreamSubscription >>>");
      positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position? position) {
        if (position != null) {
          positionLatLng = LatLng(position.latitude, position.longitude);
        }
        //print("positionLatLng >>> $positionLatLng");
        positionData = position == null
            ? 'Unknown'
            : '${position.latitude.toString()}, ${position.longitude.toString()}';
        startLocation = LatLng(position!.latitude, position.longitude);
        //print("Function startLocation >>> $startLocation");
        if(mounted){
          updateMapLocation(startLocation!);
        }
      });
    } else {
      setState(() {
        positionData = 'Location permission denied';
      });
    }
  }

  Future<void> getSafetyAlertNotify({required BuildContext context}) async {
    // print("going here!!");
    await AlertFetch.instance.getSafetyAlertNotification(true,context: context);
  }

  void updateMapLocation(LatLng newPosition) {
    if (isFirstTimeCalled) {
      isFirstTimeCalled = true;
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target:  startLocation!, zoom: 15)));
      MainMaps.gKey.currentState?.setState(() {});
    }
    updateMarkerHelp( startLocation!);
    changeLatLng();
  }

  Future<void> alertMarkers() async {
    for (AlertData alert in alertPinMarker) {
      await updateMarkerAlert(alert.uuid, alert.position);
    }
  }

  Future<BitmapDescriptor> getResizedMarkerIcon(
      String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? resizedData =
    await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(resizedData!.buffer.asUint8List());
  }

  void updateMarkerHelp(LatLng updatedLocation,) async {
    // print("MARKERS LENGTH -> 1 ${allMarkers.length}");
    Marker newMarker = const Marker(
      markerId: MarkerId('x'),
    );
    if(compassDir) {
      compassDir = false;
      BitmapDescriptor customIcon = await getResizedMarkerIcon(
          'assets/image/truck.png', 185, 75);
       newMarker = Marker(
          markerId: const MarkerId('startLocation1'),
          position: updatedLocation,
          icon: customIcon,
          anchor: const Offset(0.5, 0.5),
          zIndex: 2,
          rotation: direction
      );
      if(allMarkers.isNotEmpty){
        removeMarker('startLocation2');
      }
    }
    else
    {
      compassDir = true;
      BitmapDescriptor customIcon = await getResizedMarkerIcon(
          'assets/image/truck.png', 185, 75);
      newMarker = Marker(
          markerId: const MarkerId('startLocation2'),
          position: updatedLocation,
          icon: customIcon,
          anchor: const Offset(0.5, 0.5),
          zIndex: 2,
          rotation: direction
      );
      if(allMarkers.isNotEmpty){
        removeMarker('startLocation1');
      }
    }
    if(mounted) {
      setState(() {
        allMarkers.add(newMarker);
      });
    }
    // print("MARKERS LENGTH -> 2 ${allMarkers.length}");
  }

  void removeMarker(String markerIdToRemove) {
    if(mounted) {
      setState(() {
        allMarkers.removeWhere((marker) =>
        marker.markerId.value == markerIdToRemove);
      });
    }
  }


  Future<void> changeCompassPoints(String direction) async {
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '8c087010-e8d4-1e48-8231-1fef91049a06',
      context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "compass":direction,
        "UserId": prefs.userId,
      };
      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "8c087010-e8d4-1e48-8231-1fef91049a06",
        jsonData: getJsonData());
    bBlupSheetsApi.getJsonData = getJsonData;

    bBlupSheetsApi.onSuccess = (result) async {};
    bBlupSheetsApi.onFailure = (error) {
      print("Blup Error is changeCompassPoints> ${error}");
    };
  }


  Future<void> changeLatLng() async {
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: 'ef109940-7949-11ee-be85-19552980afde',
      context: context,
    );
    var startLocation=await GetCurrentLocation().fetch();
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "lat": startLocation.latitude,
        "lng": startLocation.longitude,
        "UserId": prefs.userId,
      };
      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "ef109940-7949-11ee-be85-19552980afde",
        jsonData: getJsonData());
    bBlupSheetsApi.getJsonData = getJsonData;

    bBlupSheetsApi.onSuccess = (result) async {};
    bBlupSheetsApi.onFailure = (error) {
      if(error is Response) {
        print("Blup Error is [help_direction.dart]> ${error.body}");
      }else{
        print("Blup Error-0 is [help_direction.dart]> ${error}");
      }
    };
  }

  Future<void> containLocation() async {
    // print("containLocation *");
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '392fc5f0-7954-11ee-be85-19552980afde',
      context: context,
    );
    Map getJsonData() {
      Map<dynamic, dynamic> jsonData = {};
      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "392fc5f0-7954-11ee-be85-19552980afde",
        jsonData: getJsonData());
    bBlupSheetsApi.getJsonData = getJsonData;
    bBlupSheetsApi.onSuccess = (result) async {
      numberWanted.clear();
      peopleAround.clear();
      allMarkers.clear();
      var startLocation=await GetCurrentLocation().fetch();
      updateMarkerHelp(startLocation);
      await alertMarkers();
      for (var res in result) {
        // print("latitude1 -> ${res['lat']} - ${res['lng']}");
        double latitude1 = double.parse(res['lat']);
        double longitude1 = double.parse(res['lng']);
        double x = CalculateDistance.instance.calculateDistance(latitude1, longitude1, startLocation.latitude, startLocation.longitude);
        if (x > 0 && x <= 16) {
          String dateTimeString = '${res["date"]} ${res["time"]}';
          DateFormat dateFormat = DateFormat('yyyy:MM:dd HH:mm:ss');
          DateTime dateTime = dateFormat.parse(dateTimeString);
          String rem = '';
          Duration difference = DateTime.now().difference(dateTime);
          if (difference.inDays >= 365) {
            int number = int.parse('${difference.inDays}');
            int res = number ~/ 365;
            String years = res.toString();
            rem =  '$years years ago';
          } else if (difference.inDays > 30) {
            int number = int.parse('${difference.inDays}');
            int res = number ~/ 30;
            String days = res.toString();
            if(days=="1"){
              rem =  '$days month ago';
            } else{
              rem =  '$days months ago';
            }
          } else if (difference.inDays > 1) {
            rem =  '${difference.inDays} days ago';
          } else if (difference.inHours >= 24) {
            int number = int.parse('${difference.inHours}');
            int res = number ~/ 24;
            String inHours = res.toString();
            rem =  '$inHours days ago';
          } else if (difference.inHours > 1) {
            rem =  '${difference.inHours} hours ago';
          }
          else if (difference.inMinutes >= 60) {
            int number = int.parse('${difference.inMinutes}');
            int res = number ~/ 60;
            String inMinutes = res.toString();
            rem =  '$inMinutes hours ago';
          } else if (difference.inMinutes > 1) {
            rem =  '${difference.inMinutes} minutes ago';
          } else {
            rem =  'Just now';
          }
          if (res["UserId"] != prefs.userId) {
              NearbyPerson person = NearbyPerson(
              res["Name"],
              res["profilePic"],
              res["PhoneNumber"],
              res["UserId"],
              res["compass"],
              res["status"],
                  rem
            );
            updateTruckMarker(LatLng(latitude1, longitude1),res["compass"]);
            // print("Change in peopleAround");
            peopleAround.add(person);
            numberWanted.add(res['PhoneNumber']);
          }
        }
      }
    };
    bBlupSheetsApi.onFailure = (error) {
      if (error is http.Response) {
        print("error is ${error.body}");
      }
    };
  }

  Future<void> updateTruckMarker(LatLng updatedLocation,String compassPoint) async {
    BitmapDescriptor customIcon = await getResizedMarkerIcon('assets/image/trucko.png', 145, 55);
    allMarkers.add(
      Marker(
        markerId: MarkerId('${updatedLocation.latitude}'),
        position: updatedLocation,
        icon: customIcon,
        anchor: const Offset(0.5, 0.5),
        zIndex: 1,
        rotation: double.parse(compassPoint),
      ),
    );
    // print("MARKERS LENGTH -> 3 ${allMarkers.length}");
    if(mounted) {
      setState(() {

      });
    }
  }


  void onCallback() {
    setState(() {
      print("CALLED");
    });
  }


  Future<void> updateMarkerAlert(String id, LatLng updatedLocation) async {
    bool isMarkerPresent = allMarkers.any((marker) => marker.markerId == MarkerId(id));
    if (isMarkerPresent) {
      allMarkers.removeWhere((marker) => marker.markerId.value == id);
    }
    BitmapDescriptor customIcon =
    await getResizedMarkerIcon('assets/image/safe.png', 150, 150);

    allMarkers.add(
    Marker(
    markerId: MarkerId(id),
    position: updatedLocation,
    icon: customIcon,
    anchor: const Offset(0.5, 0.5),
    zIndex: 0,
    onTap: () {
    alertMarkerDialog(id); // Call the dialog function
    },
    ));

  }

  void alertMarkerDialog(String id) {
    if (!navigatorKey.currentContext!.mounted) {
      return;
    }
    bool flag = false;
    AlertData? foundAlert = alertsMadeByOthers.firstWhereOrNull(
          (alert) => alert.uuid == id,
    );
    if (foundAlert == null) {
      flag = true;
      foundAlert = alertsMadeByYou.firstWhereOrNull(
            (alert) => alert.uuid == id,
      );
    }
    print("foundAlert - $foundAlert");

    flag
        ? showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          insetPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 40),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // safety header
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              child: const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.shield_outlined,
                                        size: 24,
                                        color: Color(0xFF475467),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Safety',
                                        style: TextStyle(
                                          color: Color(0xFF475466),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Notification',
                                    style: TextStyle(
                                      color: Color(0xFF98A1B2),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
// List of image
                            if (foundAlert!.images.isEmpty)
                              const SizedBox(
                                height: 406,
                                child: Center(
                                  child: Text(
                                    'No image attached',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            if (foundAlert.images.length == 1)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(1.0),
                                child: Image.network(
                                  foundAlert.images[0],
                                  fit: BoxFit.cover,
                                  height: 406,
                                ),
                              ),
                            if (foundAlert.images.length == 2)
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Image.network(
                                        foundAlert.images[0],
                                        fit: BoxFit.cover,
                                        height: 406,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Image.network(
                                        foundAlert.images[1],
                                        fit: BoxFit.cover,
                                        height: 406,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (foundAlert.images.length == 3)
                              SizedBox(
                                height: 406,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding:
                                              const EdgeInsets.all(
                                                  1.0),
                                              child: Image.network(
                                                foundAlert.images[0],
                                                fit: BoxFit.cover,
                                                height: 200,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets
                                                  .fromLTRB(0, 1, 1, 1),
                                              child: Image.network(
                                                foundAlert.images[1],
                                                fit: BoxFit.cover,
                                                height: 200,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 200,
                                      padding: const EdgeInsets.all(1.0),
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                      child: Image.network(
                                        foundAlert.images[2],
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            if (foundAlert.images.length == 4)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding:
                                          const EdgeInsets.all(1.0),
                                          child: Image.network(
                                            foundAlert.images[0],
                                            fit: BoxFit.cover,
                                            height: 200,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding:
                                          const EdgeInsets.all(1.0),
                                          child: Image.network(
                                            foundAlert.images[1],
                                            fit: BoxFit.cover,
                                            height: 200,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding:
                                          const EdgeInsets.all(1.0),
                                          child: Image.network(
                                            foundAlert.images[0],
                                            fit: BoxFit.cover,
                                            height: 200,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding:
                                          const EdgeInsets.all(1.0),
                                          child: Image.network(
                                            foundAlert.images[1],
                                            fit: BoxFit.cover,
                                            height: 200,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                            Container(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor:
                                        Color(0xFF2970FF),
                                        child: Icon(
                                          Icons.person,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        foundAlert.name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Color(0xFF475466),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFF2F3F6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      foundAlert.subject,
                                      style: const TextStyle(
                                        color: Color(0xFF1D2838),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            remove(foundAlert.uuid, onCallback),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.1,
                      right: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF238816),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Active',
                              style: TextStyle(
                                color: Color(0xFFD6FFD8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.launch_outlined,
                              color: Colors.white,
                              size: 13,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    )
        : showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          insetPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 40),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Column(
                        children: [
                          // safety header
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: const Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.shield_outlined,
                                      size: 24,
                                      color: Color(0xFF475467),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Safety',
                                      style: TextStyle(
                                        color: Color(0xFF475466),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Notification',
                                  style: TextStyle(
                                    color: Color(0xFF98A1B2),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                          // List of image
                          if (foundAlert!.images.isEmpty)
                            const SizedBox(
                              height: 406,
                              child: Center(
                                child: Text(
                                  'No image attached',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (foundAlert.images.length == 1)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(1.0),
                              child: Image.network(
                                foundAlert.images[0],
                                fit: BoxFit.cover,
                                height: 406,
                              ),
                            ),
                          if (foundAlert.images.length == 2)
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Image.network(
                                      foundAlert.images[0],
                                      fit: BoxFit.cover,
                                      height: 406,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Image.network(
                                      foundAlert.images[1],
                                      fit: BoxFit.cover,
                                      height: 406,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (foundAlert.images.length == 3)
                            SizedBox(
                              height: 406,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 200,
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding:
                                            const EdgeInsets.all(1.0),
                                            child: Image.network(
                                              foundAlert.images[0],
                                              fit: BoxFit.cover,
                                              height: 200,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding:
                                            const EdgeInsets.fromLTRB(
                                                0, 1, 1, 1),
                                            child: Image.network(
                                              foundAlert.images[1],
                                              fit: BoxFit.cover,
                                              height: 200,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 200,
                                    padding: const EdgeInsets.all(1.0),
                                    width:
                                    MediaQuery.of(context).size.width,
                                    child: Image.network(
                                      foundAlert.images[2],
                                      fit: BoxFit.fitWidth,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          if (foundAlert.images.length == 4)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding:
                                        const EdgeInsets.all(1.0),
                                        child: Image.network(
                                          foundAlert.images[0],
                                          fit: BoxFit.cover,
                                          height: 200,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding:
                                        const EdgeInsets.all(1.0),
                                        child: Image.network(
                                          foundAlert.images[1],
                                          fit: BoxFit.cover,
                                          height: 200,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding:
                                        const EdgeInsets.all(1.0),
                                        child: Image.network(
                                          foundAlert.images[0],
                                          fit: BoxFit.cover,
                                          height: 200,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding:
                                        const EdgeInsets.all(1.0),
                                        child: Image.network(
                                          foundAlert.images[1],
                                          fit: BoxFit.cover,
                                          height: 200,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          // pop main content
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Color(0xFF2970FF),
                                      child: Icon(
                                        Icons.person,
                                        size: 36,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      foundAlert.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF475466),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFF2F3F6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    foundAlert.subject,
                                    style: const TextStyle(
                                      color: Color(0xFF1D2838),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.1,
                      right: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF0F0F0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Active'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> updateStatus(String uuid) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '12626ec0-1d91-1ddd-a911-592cec524104',
      context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "uid": uuid,
        "Status": "Removed",
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "12626ec0-1d91-1ddd-a911-592cec524104",
          jsonData: getJsonData());
      print("UPDATED Removed");
      setState(() {});
    } catch (es, st) {
      print("Error in InsertIntoAlert>> $es $st");
    }
  }

  Widget remove(
      String id,
      void Function() onCallback,
      ) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: const Color(0xFFFFDBCA),
            child: InkWell(
              onTap: () {
                allMarkers.removeWhere((e) => e.markerId == MarkerId(id));
                alertPinMarker.removeWhere((alertData) => alertData.uuid == id);
                updateStatusForId(id);
                onCallback.call();
                updateStatus(id);
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(25),
              child: const TextButton(
                onPressed: null,
                child: Text(
                  'Remove Marker',
                  style: TextStyle(
                    color: Color(0xFF331200),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
