// ignore_for_file: avoid_print

import 'dart:async';
import 'package:b_dep/b_dep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as getX;
import 'package:google_place/google_place.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/widgets/navigate_widget/main_navigation.dart';
import 'package:dio/dio.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  _SearchScreenState createState() => _SearchScreenState();
  static final lmKey = GlobalKey();
}

class _SearchScreenState extends State<SearchScreen> {
  final _endSearchFieldController = TextEditingController();
  DetailsResult? endPosition;
  late FocusNode endFocusNode;
  bool loadingMap = false;
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    super.initState();
    String apiKey = 'AIzaSyDOVw6Rg-6LYKNsa-tVyrE4G56fWfwlIE0';
    googlePlace = GooglePlace(apiKey);
    endFocusNode = FocusNode();
    _endSearchFieldController.clear();
  }

  @override
  void dispose() {
    endFocusNode.dispose();
    super.dispose();
  }

  // This function is use to auto complete the search field or give suggestion to the user for the search field.
  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  // An API call to find the location and the user is trting to search.
  final dio = Dio();
  final String apiKey = 'AIzaSyCWO_OjMQ5weq00puKyGj47Umf2DJUetp0';
  String duration = '';
  Future<void> fetchData() async {
    try {
      var startLocation=await GetCurrentLocation().fetch();
      Response response = await dio.get(
          "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${startLocation.latitude},${startLocation.longitude}&destinations=${endPosition!.geometry!.location!.lat},${endPosition!.geometry!.location!.lng}&key=$apiKey");

      duration = response.data['rows'][0]['elements'][0]['duration']['text']
          .toString();
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/image/circle.svg',
                      ),
                      SvgPicture.asset(
                        'assets/image/line1.svg',
                        height: 35,
                      ),
                      SvgPicture.asset('assets/image/pin.svg'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      Container(
                        width: 325,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(43),
                          border: Border.all(
                              width: 1, color: const Color(0xFFD0D5DD)),
                        ),
                        child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Your Location',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      color: Color(0xFF475467),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 325,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(43),
                          border: Border.all(
                              width: 1, color: const Color(0xFFD0D5DD)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  cursorColor: Colors.black,
                                  textCapitalization: TextCapitalization.words,
                                  controller: _endSearchFieldController,
                                  autofocus: false,
                                  focusNode: endFocusNode,
                                  style: const TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFF475467),
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Destination',
                                    hintStyle: TextStyle(
                                      fontFamily: 'SF Pro',
                                      color: Color(0xFF475467),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      autoCompleteSearch(value);
                                    } else {
                                      setState(() {
                                        predictions = [];
                                        endPosition = null;
                                      });
                                    }
                                  },
                                ),
                              ),
                              Visibility(
                                visible:
                                _endSearchFieldController.text.isNotEmpty,
                                child: loadingMap
                                    ? const SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                        Color(0xFFFF8D49),
                                      ),
                                    ),
                                  ),
                                )
                                    : InkWell(
                                  onTap: () {
                                    setState(() {
                                      predictions = [];
                                      _endSearchFieldController.clear();
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'assets/image/cross.svg',
                                    height: 24,
                                    width: 24,
                                    color: const Color(0xFF475467),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEAECF0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/image/search.svg'),
                                const SizedBox(
                                  width: 18,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        predictions[index]
                                            .structuredFormatting
                                            ?.mainText
                                            ?.toString() ??
                                            ' ',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF475467),
                                          fontFamily: "SF Pro",
                                        ),
                                        overflow: TextOverflow.visible,
                                      ),
                                      const SizedBox(height: 2),
                                      Visibility(
                                        visible: predictions[index]
                                            .structuredFormatting
                                            ?.secondaryText
                                            ?.isNotEmpty ==
                                            true,
                                        child: Text(
                                          predictions[index]
                                              .structuredFormatting
                                              ?.secondaryText
                                              ?.toString() ??
                                              ' ',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF98A2B3),
                                            fontFamily: "SF Pro",
                                          ),
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            final placeId = predictions[index].placeId!;
                            final details =
                            await googlePlace.details.get(placeId);
                            if (details != null &&
                                details.result != null &&
                                mounted) {
                              if (true) {
                                setState(() {
                                  endPosition = details.result;
                                  _endSearchFieldController.text =
                                  details.result!.name!;
                                  predictions = [];
                                });
                              }

                              if (endPosition != null) {
                                setState(() {
                                  loadingMap = true;
                                });
                                await fetchData();
                                addUserStartandEnd();
                              }
                            }
                          },
                        ),
                        if (index != predictions.length - 1)
                          Divider(
                            thickness: 1,
                            color: Colors.grey.shade400,
                          ),
                        if (index == predictions.length - 1)
                          const SizedBox(
                            height: 8,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // This will add the user search location to the BLUP database.
  void addUserStartandEnd() async{
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '1bb886f0-6cc1-11ee-a4b8-b9f65c159d37',
      context: context,
    );

    var startLocation=await GetCurrentLocation().fetch();

    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "startPosition": "Your Location",
        "endPosition": endPosition!.name,
        "startLat": startLocation.latitude,
        "startLng": startLocation.longitude,
        "endLat": endPosition!.geometry!.location!.lat,
        "endLng": endPosition!.geometry!.location!.lng,
      };

      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "1bb886f0-6cc1-11ee-a4b8-b9f65c159d37",
        jsonData: getJsonData());

    bBlupSheetsApi.getJsonData = getJsonData;

    bBlupSheetsApi.onSuccess = (result) {
      getX.Get.to(NavigateSet(endPosition: endPosition, duration: duration));
      setState(() {
        loadingMap = false;
      });
    };
    bBlupSheetsApi.onFailure = (error) {
      print("error>>>>$error");
    };
  }
}
