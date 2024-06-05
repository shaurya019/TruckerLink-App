import 'package:flutter/material.dart';
import 'package:trucker/global/global_variables.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/widgets/home_widget/bottom_sheet.dart';
import 'package:trucker/widgets/help_widget/help_focus.dart';
import 'package:trucker/widgets/home_widget/horizontal_sheet.dart';
import 'package:trucker/widgets/maps_widget/map_setting.dart';
import 'package:trucker/widgets/maps_widget/main_map.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geocoding/geocoding.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.onTap, required this.onRefresh, this.onOpenFriendsTabCalled});
  final VoidCallback onTap;
  final VoidCallback onRefresh;
  final VoidCallback? onOpenFriendsTabCalled;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isChecked = false;
  int screenIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchAndPrintCountry();
    getReverseGeocoding();
  }

  Future<void> fetchAndPrintCountry() async {
    var startLocation=await GetCurrentLocation().fetch();
    String country = await getCountryFromLatLng(
        startLocation.latitude, startLocation.longitude) ??
        "";
    countrySelected = country;
  }

  Future<String> getReverseGeocoding() async {
    try {
      var startLocation=await GetCurrentLocation().fetch();
      List<Placemark> placeMarks = await placemarkFromCoordinates(
          startLocation.latitude, startLocation.longitude);
      Placemark place = placeMarks[0];
      address =
      "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      address = cleanUpString(address);
      return address;
    } catch (e) {
      return "Failed to get address: $e";
    }
  }

  String cleanUpString(String str) {
    String trimmedString = str.trim();
    while (trimmedString.isNotEmpty &&
        !trimmedString[0].contains(RegExp(r'[A-Za-z0-9]'))) {
      trimmedString = trimmedString.substring(1);
    }
    return trimmedString;
  }

  // This function is used to get the country name from user latitude and longitude.
  Future<String?> getCountryFromLatLng(
      double latitude, double longitude) async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: latitude,
          longitude: longitude,
          googleMapApiKey: 'AIzaSyCWO_OjMQ5weq00puKyGj47Umf2DJUetp0');
      return data.country; // Returns the country name
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        MainMaps(
          key: MainMaps.gKey,
        ),
        const HorizontalSheet(),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.34,
          left: MediaQuery.of(context).size.width * 0.02,
          child: MapSetting(
            key: MapSetting.staticKey,
            onChange: ({required int indexNumber}) {
              if (indexNumber == 1) {
                screenIndex = 1;
              } else if (indexNumber == 2) {
                screenIndex = 2;
              }
              Drag.Dragkey.currentState?.refresh.call(screenIndex);
            },
          ),
        ),
        Positioned(
            bottom: MediaQuery.of(context).size.height * 0.34,
            right: MediaQuery.of(context).size.width * 0.02,
            child: HelpDir()),
        Drag(
          key: Drag.Dragkey,
          screenIndex: 0,
          onTap: widget.onTap,
          onReferesh: () {
            setState(() {});
          },
          onOpenFriendsTabCalled: widget.onOpenFriendsTabCalled,
        ),
      ]),
    );
  }
}
