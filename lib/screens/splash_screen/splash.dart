import 'dart:async';
import 'dart:math';
import 'package:b_dep/b_dep.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trucker/global/global_class.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/requests/contacts_fetch.dart';
import 'package:trucker/screens/friends_screen/contacts.dart';
import "package:trucker/screens/navigation_screen/bottom.dart";
import 'package:trucker/screens/welcome_screen/welcome.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../profile_screen/profile.dart';



class GetCurrentLocation{
  // double? lat;
  // double? lng;

  ///Keep default [LatLng] value be 0,0.
  ///As it is required to it zero in multiple cases.
  static LatLng _startLocation = const LatLng(
     0,
     0,
  );

  Future<LatLng> fetch() async{
    if(_startLocation.latitude==0){
      Position data = await SplashState().determinePosition();
      _startLocation=LatLng(data.latitude, data.longitude);
      //print("BS: Inside Get Location Background0 > ${_startLocation}");
    }
    return _startLocation;
  }

}

double direction = 0;
double prevDirection = 0;

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    print("Going");
    GetCurrentLocation().fetch().then((value) async{
      // var startLocation=await GetCurrentLocation().fetch();
      // print("start -> $startLocation");
      loadData();
      print("contacts");
      ContactHelper.instance.fetchContactDetails();
      //getContactPermission(context: context);
    });
  }

  // // This Function is used to get the contact permission from the user.
  // void getContactPermission({required BuildContext context}) async {
  //   if (await Permission.contacts.isGranted) {
  //   } else {
  //     await Permission.contacts.request();
  //   }
  //   await containNumber(context);
  // }
  //
  // // This Function is used to load all that number to a list that was already in the trucker app and in the user contact book also.
  // Future<void> containNumber(BuildContext context) async {
  //   BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
  //     'client.blup.white.falcon@gmail.com',
  //     calledFrom: 'c21831c0-78c5-11ee-be85-19552980afde',
  //     context: context,
  //   );
  //   Map getJsonData() {
  //     Map<dynamic, dynamic> jsonData = {};
  //     return jsonData;
  //   }
  //
  //   bBlupSheetsApi.runDefaultBlupSheetApi(
  //       queryId: "c21831c0-78c5-11ee-be85-19552980afde",
  //       jsonData: getJsonData());
  //   bBlupSheetsApi.getJsonData = getJsonData;
  //   bBlupSheetsApi.onSuccess = (result) async {
  //     for (var res in result) {
  //       if (userNumber != res["PhoneNumber"]) {
  //         phoneStore.add(res["PhoneNumber"]);
  //       }
  //     }
  //
  //     fetchContacts(context);
  //   };
  //   bBlupSheetsApi.onFailure = (error) {
  //     if (error is http.Response) {
  //       print("error -> $error");
  //     }
  //   };
  // }
  //
  // void fetchContacts(BuildContext context) async {
  //   try {
  //     contacts = await ContactsService.getContacts();
  //   } catch (error) {
  //     print("FetchContacts -> $error");
  //   }
  //   for (Contact contact in contacts) {
  //     for (Item data in contact.phones ?? []) {
  //       String contactPersonNumber =
  //       (data.value ?? "").replaceAll(RegExp(r'[^\d\+]+|-'), '');
  //       if (!checkNumber.contains(contactPersonNumber) &&
  //           contactPersonNumber.length >= 7 &&
  //           contactPersonNumber != prefs.phoneNumber) {
  //         String lastSevenChars =
  //         contactPersonNumber.substring(contactPersonNumber.length - 7);
  //         for (String databaseNum in phoneStore) {
  //           if (databaseNum.contains(lastSevenChars)) {
  //             FinalDetails fDetails = FinalDetails(
  //               pName: contact.givenName ?? "No Name",
  //               pNumber: databaseNum,
  //             );
  //             finalDetailsList.add(fDetails);
  //           }
  //         }
  //       }
  //       checkNumber.add(contactPersonNumber);
  //     }
  //   }
  //   flagContacts = false;
  // }

  // This function is used to show the dialog box to open the location
  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'Allow "Trucker Link" to access your location while you are using the app?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('We need your locations Lat and Lng'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Allow'),
              onPressed: () {
                GetCurrentLocation().fetch();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  // This Function is used to get the user Latitude and Longitude details.
  // Future<void> getLatLong() async {
  //   Position data = await determinePosition();
  //   // lat = 33.7435513;
  //   // lng = -118.2918715;
  //   // startLocation = LatLng(33.7435513, -118.2918715);
  //   data.latitude;
  //   data.longitude;
  //   startLocation = LatLng(data.latitude, data.longitude);
  //   print("getLatLong -> $startLocation");
  // }
  // This function is used to set the position of the User in the google map.
  Future<Position> determinePosition() async {
    try {
      // print("_determinePosition");
      LocationPermission permission;

      permission = await Geolocator.checkPermission();
      // print("permission -> $permission");

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationDialog(context);
          throw ('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw ('Location permissions are LocationPermission.denied Forever we cannot request permissions.');
      }
      // Position x =  await Geolocator.getCurrentPosition(
      //     timeLimit: Duration(seconds: 60),
      //     desiredAccuracy: LocationAccuracy.high,
      //   ).then((value) {
      //     return value;
      //     print("value >> $value");
      //   }).onError((error, stackTrace) {
      //   Position y = Position(longitude: 0.0, latitude: 0.0);
      //     return LatLng(0, 0);
      //     print("error >>> $error");
      //   });

      // if(x == null){
      //   showDialog(
      //               context: context,
      //               builder: (BuildContext context) {
      //
      //                 return LocationPermissionDialog();
      //               },
      //             );
      // }

      return await Geolocator.getCurrentPosition(
        // timeLimit: Duration(seconds: 60),
        desiredAccuracy: LocationAccuracy.high,
      );

    } catch (e) {
      print("Error in _determinePosition: $e");
      return Future.error(e);
    }
  }


  // It is used to load the user location details to the google map and it was called in inilization of the app.
  Future<void> loadData() async {
    var startLocation = await GetCurrentLocation().fetch();
    if (startLocation.latitude == 0 && startLocation.latitude ==0) {
      try {
        Position data = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        startLocation = LatLng(data.latitude, data.longitude);
      } catch (error) {
        print("loadData -> $error");
      }
    }
    final user = FirebaseAuth.instance.currentUser;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedFirstName = prefs.getString('name');
    // print("storedFirstName -> $storedFirstName");
    if (user != null && storedFirstName != null) {
      Get.offAll(() => Bottom(selectedIndex: 0, newIndex: 0));
    } else {
      Get.offAll(() => Welcome());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: 361.95,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(79.18),
          ),
          child: Image.asset(
            'assets/image/splash_.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class LocationPermissionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Location Permission Issue'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialogContent(
            'Permissions:',
            'Ensure that your app has the necessary location permissions. On some devices, the user might need to manually grant location permissions in the device settings.',
          ),
          _buildDialogContent(
            'Network Connection:',
            'Ensure that your device has an active network connection, as some location services might rely on network assistance.',
          ),
          _buildDialogContent(
            'Location Services:',
            'Check if the device\'s location services are enabled. If not, prompt the user to enable them or guide them to the location settings.',
          ),
          _buildDialogContent(
            'Guidance: Restart Application Upon Issue Resolution:',
            'Kindly consider restarting the application subsequent to resolving the identified issue.',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  Widget _buildDialogContent(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(content),
        SizedBox(height: 16.0),
      ],
    );
  }
}
