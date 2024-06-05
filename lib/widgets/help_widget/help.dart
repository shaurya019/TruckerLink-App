import 'dart:io';
import 'dart:math';
import 'package:b_dep/b_dep.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trucker/lists/list.dart';
import 'package:trucker/widgets/help_widget/help_direction.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;
import 'package:trucker/widgets/help_widget/help_history_page.dart';
import 'package:trucker/widgets/help_widget/help_safety_page.dart';
import 'package:trucker/widgets/help_widget/help_timer.dart';
import 'package:trucker/widgets/help_widget/take_image.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:camera/camera.dart';

class DateTimeComponents {
  final String date;
  final String time;

  DateTimeComponents(this.date, this.time);
}

DateTimeComponents getCurrentDateTime() {
  DateTime now = DateTime.now();
  String time = "${now.hour}:${now.minute}:${now.second}";
  String date = "${now.year}:${now.month}:${now.day}";
  return DateTimeComponents(date, time);
}

class Help extends StatefulWidget {
  final CameraDescription camera;
  bool isHelpLoading = false;
  Help({super.key, required this.camera});
  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> with WidgetsBindingObserver {
  speechToText.SpeechToText speech = speechToText.SpeechToText();
  String textString = "";
  bool isListen = false;
  bool isButtonEnabledHelp = false;
  var uuid = "trucker";
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();
  File? image;
  int selectedIndex = -1;
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController helpController = TextEditingController();
  final TextEditingController alertController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    speech = speechToText.SpeechToText();
    helpController.addListener(updateButtonState);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _draggableController.dispose();
    super.dispose();
    print("DISPOSE");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      resetClickedItemsList();
    }
  }

  void resetClickedItemsList() {
    setState(() {
      selectedIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _draggableController,
      initialChildSize: isButtonEnabledHelp ? 0.87 : 0.35,
      minChildSize: 0.35,
      maxChildSize: .87,
      snapSizes: const [0.35, .87],
      snap: true,
      builder: (BuildContext context, scrollSheetController) {
        return GestureDetector(
          onTap: () {
            resetClickedItemsList();
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: ListView.builder(
              itemCount: 1,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              controller: scrollSheetController,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    const SizedBox(height: 8),
                    // top part
                    Container(
                      width: 36,
                      height: 5,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFCFD4DC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.50),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 18),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFE4E4E4),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/image/shield.svg',
                                          width: 24,
                                          height: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Request Help',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF475466),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(HistoryPage(firstpage: true,));
                                        resetClickedItemsList();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 15,right: 15,top: 5, bottom: 5),
                                        child: Text(
                                          'History',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Color(0xFFEC6A00),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'What help do you need?',
                                  style: TextStyle(
                                    color: Color(0xFF475466),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Container(
                                    width: 329,
                                    height: 114,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF2F3F6),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: helpController,
                                                  cursorColor: Colors.black,
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  decoration:
                                                      const InputDecoration(
                                                    fillColor:
                                                        Color(0xFFF2F3F6),
                                                    filled: true,
                                                    hintText:
                                                        "I need help with...",
                                                    hintStyle: TextStyle(
                                                      color: Color(0xFF98A1B2),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      child: SvgPicture.asset(
                                                        'assets/image/mic.svg',
                                                        width: 24,
                                                        height: 24,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 18,
                                        ),
                                        SizedBox(
                                          height: 32,
                                          child: ListView.builder(
                                            itemCount: truckItems.length,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              
                                              return InkWell(
                                                onTap: () {
                                                  helpController.text =
                                                      'I need help with ${truckItems[i]}';
                                                  setState(() {
                                                    selectedIndex = i;
                                                  });
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(42),
                                                child: Container(
                                                  height: 32,
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  padding: const EdgeInsets.only(left: 10,right: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            42),
                                                    color: selectedIndex == i
                                                        ? const Color(
                                                            0xFFFF8D49)
                                                        : Colors.white,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      truckItems[i],
                                                      style: TextStyle(
                                                        color:
                                                            selectedIndex == i
                                                                ? Colors.white
                                                                : const Color(
                                                                    0xFF667084),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                InkWell(
                                  onTap: isButtonEnabledHelp
                                      ? widget.isHelpLoading
                                          ? null
                                          : () async {
                                              setState(() {
                                                widget.isHelpLoading = true;
                                                selectedIndex = -1;
                                              });
                                              insertIntoHelpDetails();
                                            }
                                      : null,
                                  child: Container(
                                      width: double.infinity,
                                      height: 40,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: isButtonEnabledHelp
                                            ? const Color(0xFFFF8D49)
                                            : const Color(0xFFF9FAFB),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        shadows: const [
                                          BoxShadow(
                                            color: Color(0x1C000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      child: isButtonEnabledHelp
                                          ? widget.isHelpLoading
                                              ? const Center(
                                                  child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: Colors.white),
                                                ))
                                              : Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.search,
                                                        color:
                                                            isButtonEnabledHelp
                                                                ? Colors.white
                                                                : const Color(
                                                                    0xFF98A2B3),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        'Search help',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              isButtonEnabledHelp
                                                                  ? Colors.white
                                                                  : const Color(
                                                                      0xFF98A2B3),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                          : Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.search,
                                                    color: isButtonEnabledHelp
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF98A2B3),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Search help',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: isButtonEnabledHelp
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFF98A2B3),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAECF0),
                              border: Border.all(
                                color: const Color(0xFFEAECF0),
                                width: 1,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAECF0),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.shield_outlined,
                                          size: 24,
                                          color: Color(0xFF475467),
                                        ),
                                        SizedBox(width: 8.0),
                                        Text(
                                          'Safety',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF475466),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(
                                            SafetyPage(camera: widget.camera));
                                        resetClickedItemsList();
                                      },
                                      child: const SizedBox(
                                        width: 55,
                                        child: Text(
                                          'History',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Color(0xFFEC6A00),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                const Text(
                                  'Help truckers navigate better.',
                                  style: TextStyle(
                                    color: Color(0xFF667084),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 24.0),
                                const Text(
                                  '1. This starts by opening the camera.',
                                  style: TextStyle(
                                    color: Color(0xFF667084),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                const Text(
                                  '2. Take photos of the accident or mishap \n on the road & add a description for others’ safety.',
                                  style: TextStyle(
                                    color: Color(0xFF667084),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                const Text(
                                  '3. Now, safety marker will be displayed on the \n map with current location to assist truckers.',
                                  style: TextStyle(
                                    color: Color(0xFF667084),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 24.0),
                                const Text(
                                  'Note: The marker will stay upto 8hrs until it is removed automatically.',
                                  style: TextStyle(
                                    color: Color(0xFF667084),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 24.0),
                                InkWell(
                                  onTap: () {
                                    Get.to(TakePictureScreen(
                                        camera: widget.camera));
                                    resetClickedItemsList();
                                  },
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x14000000),
                                          blurRadius: 6,
                                          offset: Offset(0, 2),
                                          spreadRadius: 2,
                                        ),
                                        BoxShadow(
                                          color: Color(0x1E000000),
                                          blurRadius: 2,
                                          offset: Offset(0, 1),
                                          spreadRadius: 0,
                                        )
                                      ],
                                    ),
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.report_problem_outlined,
                                            size: 18.0,
                                            color: Color(0xFF475467),
                                          ),
                                          SizedBox(width: 8.0),
                                          Text(
                                            'Add Safety marker at this location.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF344053),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24.0),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void updateButtonState() {
    bool previousState = isButtonEnabledHelp;
    setState(() {
      isButtonEnabledHelp = helpController.text.isNotEmpty;
    });

    if (isButtonEnabledHelp &&
        !widget.isHelpLoading &&
        isButtonEnabledHelp != previousState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _draggableController.animateTo(
          0.87,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void updateTextField(String value) {
    setState(() {
      _textEditingController.text = value;
    });
  }

  void listenToUser() async {
    if (!isListen) {
      bool avail = await speech.initialize();
      if (avail) {
        setState(() {
          isListen = true;
        });
        speech.listen(onResult: (value) {
          setState(() {
            helpController.text = value.recognizedWords;
            textString = value.recognizedWords;
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

  Future pickImageFromGallery() async {
    final selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedImage == null) return;
    setState(() {
      image = File(selectedImage.path);
    });
  }

  directCall() async {
    await FlutterPhoneDirectCaller.callNumber('8383867619');
  }

  void insertIntoHelpAskDetails(String number, String pid, String x) {
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '5bde00a0-8514-11ee-bbc1-715aa4713bb3',
      context: context,
    );

    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "PID": pid,
        "helpUserNo": prefs.phoneNumber,
        "helperNumber": number,
        "helpCode": x
      };
      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "5bde00a0-8514-11ee-bbc1-715aa4713bb3",
        jsonData: getJsonData());

    bBlupSheetsApi.getJsonData = getJsonData;

    bBlupSheetsApi.onSuccess = (result) {
      print("Navigated");
    };
    bBlupSheetsApi.onFailure = (error) {
      print("Blup Error is Help: ${error.body}");
    };
  }

  String generateBackendCode() {
    Random random = Random();
    int backendCodeNumber = random.nextInt(9000) + 1000;
    String backendCode = backendCodeNumber.toString();
    return backendCode;
  }

  void insertIntoHelpDetails() {
    DateTimeComponents dateTimeComponents = getCurrentDateTime();
    String times = dateTimeComponents.time;
    String date = dateTimeComponents.date;
    // "${now.hour}:${now.minute}:${now.second}";
    // "${now.year}:${now.month}:${now.day}";
    String codeHelp = generateBackendCode();
    print('Random Number >>> $codeHelp');
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '002fd940-8514-11ee-bbc1-715aa4713bb3',
      context: context,
    );

    var pid = const Uuid().v1();
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "PID": pid,
        "userMobileNo": prefs.phoneNumber,
        "helpStatus": "Searching...",
        "helpSubject": helpController.text,
        "helpAskedTime": times,
        "helpAskedDate": date,
        "assignedHelperNo": prefs.phoneNumber,
        "helpCode": codeHelp
      };
      print(
          "Data Provided to >>>> ${prefs.phoneNumber} >>> ${helpController.text} >>>> $times >>>> $date");
      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "002fd940-8514-11ee-bbc1-715aa4713bb3",
        jsonData: getJsonData());

    bBlupSheetsApi.getJsonData = getJsonData;

    bBlupSheetsApi.onSuccess = (result) {
      for (int i = 0; i < numberWanted.length; i++) {
        insertIntoHelpAskDetails(numberWanted.elementAt(i), pid, codeHelp);
      }
      setState(() {
        widget.isHelpLoading = false;
      });
      Get.to(HelpTimer(
        value: helpController.text,
        PID: pid,
        helpCode: codeHelp,
        timer: 60,
      ));
      helpController.clear();
    };
    bBlupSheetsApi.onFailure = (error) {
      print("Blup Error is 1 ${error.body}");
    };
  }
}
