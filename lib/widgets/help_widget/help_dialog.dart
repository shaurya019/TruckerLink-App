import 'package:b_dep/b_dep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trucker/MyNotificationResponse.dart';
import 'package:trucker/Notification.dart';
import 'package:trucker/global/global_variables.dart';
import 'package:trucker/main.dart';
import 'package:trucker/screens/navigation_screen/bottom.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:trucker/widgets/help_widget/help_other_accepted.dart';
import 'package:trucker/widgets/help_widget/help_polyline_map.dart';
import 'package:trucker/widgets/navigate_widget/map_polyline.dart';

class HelpDialog extends StatefulWidget {
  String userID;
  String helpID;
  String userNumber;
  String userRequestName;
  LatLng userRequestLatLng;
  String userRequestEmail;
  String userSubject;
  String userCode;
  String userRequestImage;
  String distance;
  HelpDialog(
      {super.key,
      required this.userID,
      required this.helpID,
      required this.userRequestName,
      required this.userRequestLatLng,
      required this.userRequestEmail,
      required this.userNumber,
      required this.userSubject,
      required this.userCode,
      required this.userRequestImage,
      required this.distance});

  @override
  State<HelpDialog> createState() => _HelpDialogState();
}

class _HelpDialogState extends State<HelpDialog> {
  @override
  void initState() {
    super.initState();
    dialogPresent = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Dialog -> ${widget.userRequestName} ${widget.userSubject} ${widget.userRequestLatLng} ${widget.distance}");
    return IntrinsicHeight(
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
                SizedBox(
                  height: 64,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/image/shield.svg',
                              width: 24.0,
                              height: 24.0,
                              color: const Color(0xFF475466),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Help Required',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF475466),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${widget.distance} miles',
                          style: const TextStyle(
                            color: Color(0xFF9C4400),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PolyLineHelpWidget(
                  distance:widget.distance,
                  pos: widget.userRequestLatLng,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor:
                                Color(0xFF2970FE),
                                child: Icon(
                                  Icons.person,
                                  size: 24,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                widget.userRequestName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF475466),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          Container(
                            child: const Icon(
                              Icons.report_problem_outlined,
                              color: Colors.red,
                              size: 30.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.userSubject,
                        style: const TextStyle(
                          color: Color(0xFF475466),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Would you like to help ${widget.userRequestName}? ',
                              style: const TextStyle(
                                color: Color(0xFF98A1B2),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: const Color(0xFFF2F3F6),
                        child: InkWell(
                          onTap: () {
                            print("NO>>>>TextButton");
                            dialogPresent = false;
                            MyNotificationResponse().onHelpRejected(
                                widget.helpID,
                                widget.userNumber,
                                widget.userCode);
                            Navigator.pop(context);
                          },
                          child: const TextButton(
                            onPressed: null,
                            child: Text(
                              'Decline',
                              style: TextStyle(
                                color: Color(0xFF98A1B2),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: const Color(0xFFEAECF0),
                        child: InkWell(
                          onTap: () {
                            print("YES >> TextButton| >> ${userRequestImage}");
                            dialogPresent = false;
                            // pressYes();
                            String jsonString =
                                MyNotificationResponse().getUserDataStr(
                              "tap_outside_id",
                              helpID,
                              userRequestName,
                              userCode,
                              userRequestPhoneNumber,
                              userRequestEmail,
                              userSubject,
                              userRequestLatLng,
                              userRequestImage,
                              widget.userID,
                            );
                            MyNotificationResponse().onHelpAccepted(jsonString);
                            Navigator.pop(context);
                          },
                          child: const TextButton(
                            onPressed: null,
                            child: Text(
                              'Accept',
                              style: TextStyle(
                                color: Color(0xFF475466),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getNameData() async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '9cf8a770-8929-11ee-aba4-61a7eb2406d8',
      context: navigatorKey.currentContext!,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "helperNumber": prefs.phoneNumber,
        "helpCode": widget.userCode,
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "9cf8a770-8929-11ee-aba4-61a7eb2406d8",
          jsonData: getJsonData());
      print("Rsssss >>>> ${response}");
    } catch (es, st) {
      print("Error in AcceptedHelp>> $es $st");
    }
  }
}
