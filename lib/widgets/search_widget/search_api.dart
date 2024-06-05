// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:b_dep/b_dep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as getX;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/global/global_variables.dart';
import 'package:trucker/requests/message_api.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:trucker/screens/search_screen/search_screen.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;
import 'package:dio/dio.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/widgets/help_widget/help.dart';
import 'package:trucker/widgets/home_widget/bottom_sheet_item.dart';

class SearchApiScreen extends StatefulWidget {
  const SearchApiScreen({super.key});

  @override
  _SearchApiScreenState createState() => _SearchApiScreenState();
}

class _SearchApiScreenState extends State<SearchApiScreen> {
  final _startSearchFieldController = TextEditingController();

  DetailsResult? startPosition;

  late FocusNode startFocusNode;
  String apiKey = 'AIzaSyDOVw6Rg-6LYKNsa-tVyrE4G56fWfwlIE0';
  List<AutocompletePrediction> predictions = [];
  Timer? _debounce;
  speechToText.SpeechToText speech = speechToText.SpeechToText();
  String textString = "";
  bool isListen = false;
  bool loadingMaps = false;
  void updateTextField(String value) {
    setState(() {
      _startSearchFieldController.text = value;
    });
  }

  String duration = '';
  final dio = Dio();
  Future<void> fetchData() async {
    try {
      var startLocation=await GetCurrentLocation().fetch();
      Response response = await dio.get(
          "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${startLocation.latitude},${startLocation.longitude}&destinations=${startPosition!.geometry!.location!.lat},${startPosition!.geometry!.location!.lng}&key=$apiKey");
      duration = response.data['rows'][0]['elements'][0]['duration']['text']
          .toString();
    } catch (e) {
      print("Error: $e");
    }
  }

  void listen() async {
    if (!isListen) {
      bool avail = await speech.initialize();
      if (avail) {
        setState(() {
          isListen = true;
        });
        speech.listen(onResult: (value) {
          setState(() {
            _startSearchFieldController.text = value.recognizedWords;
            textString = value.recognizedWords;
            updateSearchSuggestions(textString);
          });
        });
      }
    } else {
      setState(() {
        isListen = false;
      });
      speech.stop();
    }
  }

  void updateSearchSuggestions(String query) {
    if (query.isNotEmpty) {
      autoCompleteSearch(query);
    } else {
      setState(() {
        predictions = [];
        startPosition = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    String apiKey = 'AIzaSyDOVw6Rg-6LYKNsa-tVyrE4G56fWfwlIE0';
    googlePlace = GooglePlace(apiKey);
    startFocusNode = FocusNode();
    speech = speechToText.SpeechToText();
  }

  @override
  void dispose() {
    startFocusNode.dispose();
    super.dispose();
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(43),
                color: const Color(0xFFD0D5DD),
              ),
            ),
            Container(
              width: double.infinity,
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(43),
                color: const Color(0xFFf2f4f7),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      dragindex = 0;
                      DragItem.DKey.currentState?.setState(() {});
                    },
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: SvgPicture.string('''<svg width="24" height="24" viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <path d="M19.2422 12H5.24219M5.24219 12L12.2422 19M5.24219 12L12.2422 5" stroke="#667085" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                              </svg>'''
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Center(
                      child: TextField(
                        cursorColor: Colors.black,
                        textCapitalization: TextCapitalization.words,
                        controller: _startSearchFieldController,
                        autofocus: true,
                        focusNode: startFocusNode,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Color(0xFF475467),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Where to go?',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Color(0xFF475467).withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            autoCompleteSearch(value);
                          } else {
                            setState(() {
                              predictions = [];
                              startPosition = null;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _startSearchFieldController.text.isEmpty,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          predictions = [];
                          _startSearchFieldController.clear();
                        });
                      },
                      child: isListen
                          ? AvatarGlow(
                              glowColor: const Color(0xFFFF8D49),
                              glowCount: 2,
                              duration: const Duration(milliseconds: 8000),
                              repeat: true,
                              glowRadiusFactor: 0.8,
                              child: InkWell(
                                onTap: () {},
                                child: SvgPicture.asset(
                                  'assets/image/mic.svg',
                                  height: 24,
                                  width: 24,
                                  color: const Color(0xFF475467),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                listen();
                              },
                              child: SvgPicture.asset(
                                'assets/image/mic.svg',
                                height: 24,
                                width: 24,
                                color: const Color(0xFF475467),
                              ),
                            ),
                    ),
                  ),
                  Visibility(
                    visible: _startSearchFieldController.text.isNotEmpty,
                    child: loadingMaps
                        ? const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFFF8D49)),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                predictions = [];
                                _startSearchFieldController.clear();
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
            const SizedBox(height: 18),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEAECF0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/image/search.svg'),
                              const SizedBox(
                                width: 18,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          fontFamily: "SF Pro",
                                          color: Color(0xFF98A2B3),
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
                                startPosition = details.result;
                                _startSearchFieldController.text =
                                    details.result!.name!;
                                predictions = [];
                              });
                            }

                            if (startPosition != null) {
                              dbr = details.result!.rating ?? 0;
                              ratings = dbr.toString();
                              var x = details.result!.userRatingsTotal ?? 0;
                              length = x.toString();
                              formattedAddress =
                                  details.result?.formattedAddress ??
                                      "Not Available";
                              formattedPhoneNumber =
                                  details.result!.internationalPhoneNumber ??
                                      "Not Available";
                              name = details.result!.name ?? "";
                              arr = details.result!.photos!;
                              pos = LatLng(
                                  startPosition!.geometry!.location!.lat!,
                                  startPosition!.geometry!.location!.lng!);
                              setState(() {
                                loadingMaps = true;
                              });
                              await fetchData();
                              addUserStart();
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
    );
  }

  void addUserStart() async{
    DateTimeComponents dateTimeComponents = getCurrentDateTime();
    String times = dateTimeComponents.time;
    String date = dateTimeComponents.date;

    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '1bb886f0-6cc1-11ee-a4b8-b9f65c159d37',
      context: context,
    );
    var startLocation=await GetCurrentLocation().fetch();
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "startPosition": address,
        "endPosition": startPosition!.name,
        "startLat": startLocation.latitude,
        "startLng": startLocation.longitude,
        "endLat": startPosition!.geometry!.location!.lat!,
        "endLng": startPosition!.geometry!.location!.lng!,
        "UserId": prefs.userId,
        "Date": date,
        "Time": times,
      };
      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "1bb886f0-6cc1-11ee-a4b8-b9f65c159d37",
        jsonData: getJsonData());

    bBlupSheetsApi.getJsonData = getJsonData;

    bBlupSheetsApi.onSuccess = (result) {
      getX.Get.to(
        SearchScreen(
          startPosition: startPosition,
          duration: duration,
        ),
      );
      setState(() {
        loadingMaps = false;
      });
    };
    bBlupSheetsApi.onFailure = (error) {
      print("error>>>>$error");
    };
  }
}
