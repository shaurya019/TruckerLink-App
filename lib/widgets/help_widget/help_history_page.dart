import 'package:b_dep/b_dep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trucker/requests/histroy_fetch.dart';
import 'package:trucker/screens/navigation_screen/bottom.dart';
import 'package:trucker/widgets/help_widget/help.dart';
import 'package:trucker/widgets/help_widget/help_accepted.dart';
import 'package:trucker/widgets/help_widget/help_timer.dart';
import 'help_other_accepted.dart';

List<int> timer = [];

class HistoryPage extends StatefulWidget {
  bool firstpage = true;
  HistoryPage({Key? key, required this.firstpage}) : super(key: key);
  VoidCallback? onRefresh;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool isRequestReceived = true;
  bool isRequestAccepted = true;
  String status = 'Accepted';
  double width = 91.0;
  Color bodyColor = const Color(0xFF238816);
  Color textColor = const Color(0xFFD6FFD8);

  bool isLoading_requestMade = false;
  bool isLoading_requestReceived = false;

  @override
  void initState() {
    super.initState();
    loadRequestHistory1(context: context);
    loadRequestHistory2(context: context);
    print("Called MEEEEe");
  }

  @override
  Widget build(BuildContext context) {
    // print("---build Called-0");
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                    ),
                    onPressed: () {
                      // Get.off(Bottom(
                      //   selectedIndex: 0,
                      //   newIndex: 0,
                      // ));
                      Get.back();
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
                  const SizedBox(
                    width: 12,
                  ),
                  const Text(
                    'Request History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                margin: const EdgeInsets.only(
                  bottom: 20.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAECF0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.firstpage = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: widget.firstpage   ? Colors.white : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          shadows: widget.firstpage
                              ? const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 3,
                              offset: Offset(0, 1),
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              color: Color(0x1E000000),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                              spreadRadius: 0,
                            )
                          ]
                              : [],
                        ),
                        child: const Text(
                          'Request Made',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF475466),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.firstpage = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: !widget.firstpage ? Colors.white : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          shadows: !widget.firstpage
                              ? const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 3,
                              offset: Offset(0, 1),
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              color: Color(0x1E000000),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                              spreadRadius: 0,
                            )
                          ]
                              : [],
                        ),
                        child: const Text(
                          'Request Received',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF475466),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: widget.firstpage
                    ? Center(
                  child: isRequestReceived
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF8D49)),
                    ),
                  )
                      : requestMade(),
                )
                    : isRequestAccepted
                    ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF8D49)),
                    ),
                  ),
                )
                    : requestReceived(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget requestReceived() {
    return requestAcceptedByUser.isNotEmpty
        ? ListView.builder(
      itemCount: requestAcceptedByUser.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, i) {
        String dateAndTime = dateFix(
            '${requestAcceptedByUser[i]
                .requestAcceptedAskedTime} -  ${requestAcceptedByUser[i]
                .requestAcceptedAskedDate}');
        if (requestAcceptedByUser[i].requestAcceptedStatus ==
            "Help Done") {
          status = "Fulfilled";
          width = 67;
          bodyColor = const Color(0xFFF0F0F0);
          textColor = const Color(0xFF667085);
        } else if (requestAcceptedByUser[i].requestAcceptedStatus ==
            "Help Not Available") {
          status = "Unfulfilled";
          width = 80;
          bodyColor = const Color(0xFFFFE3E3);
          textColor = const Color(0xFF475467);
        } else if (requestAcceptedByUser[i].requestAcceptedStatus ==
            "Cancelled") {
          status = "Cancelled";
          width = 75;
          bodyColor = const Color(0xFFFFE3E3);
          textColor = const Color(0xFF475467);
        } else if (requestAcceptedByUser[i].requestAcceptedStatus ==
            "Accepted") {
          status = 'Accepted';
          width = 91.0;
          bodyColor = const Color(0xFF238816);
          textColor = const Color(0xFFD6FFD8);
        }
        var nameX = capitalizeFirstWord(
            requestAcceptedByUser[i].requestAcceptedSubject);
        print("D -> ${requestAcceptedByUser[i]
            .requestAcceptedSubject} -> ${requestAcceptedByUser[i]
            .requestAcceptedStatus} -> ${requestAcceptedByUser[i]
            .requestAcceptedName}");
        return InkWell(
          onTap: () {
            Get.to(OtherAcceptedHelp(
              name: requestAcceptedByUser[i].requestAcceptedName,
              code: requestAcceptedByUser[i].requestAcceptedCode,
              phoneNumber: requestAcceptedByUser[i].requestAcceptedPhone,
              email: '',
              picLocation: requestAcceptedByUser[i].requestAcceptedPos,
              message: requestAcceptedByUser[i].requestAcceptedSubject,
              request: requestAcceptedByUser[i].requestAcceptedStatus,
              imageUrl: requestAcceptedByUser[i].requestAcceptedImage,
              pId: requestAcceptedByUser[i].requestAcceptedPID,
              userId: requestAcceptedByUser[i].requestAcceptedUserId,
              flag: false,
            ));
          },
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: double.infinity,
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    requestAcceptedByUser[i].requestAcceptedImage != "x" ?
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                      NetworkImage(
                          requestAcceptedByUser[i].requestAcceptedImage),
                    )
                        :
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2970FF),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: SvgPicture.asset(
                        'assets/image/person.svg',
                        height: 18.33,
                        width: 15,
                        color: Colors.white,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 170,
                          child: Text(
                            nameX,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF475467),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          dateAndTime,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF98A2B3),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Flexible(
                  child: requestAcceptedByUser[i].requestAcceptedStatus ==
                      "Accepted"
                      ? Container(
                      height: 22,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: bodyColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(right: 4.0),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ),
                          // SizedBox(height: 4,),
                          SvgPicture.asset(
                            'assets/image/arrowup.svg',
                            width: 13.0,
                            height: 13.0,
                          ),
                        ],
                      )
                  )
                      : Container(
                    height: 22,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: bodyColor,
                    ),
                    child: Center(
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        )),
                  ),
                )
              ],
            ),
          ),
        );
      },
    )
        : Center(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 68),
        child: Column(
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  'assets/image/rmarker.svg',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover, // You can adjust the fit as needed
                ),
                const SizedBox(
                  height: 18,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Seems like you have not',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475467),
                      ),
                    ),
                    Text(
                      'received any help request so far.',
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
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {},
                  child: Container(
                    height: 40,
                    width: 203,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xFFE3E3E3),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset(
                          'assets/image/plus.svg',
                          height: 18,
                          width: 18,
                          color: const Color(0xFF475467),
                        ),
                        const Text(
                          'Make a help safety',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF475467),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Do not forget to help the',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF667085),
                      ),
                    ),
                    Text(
                      'person in need!',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF667085),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget requestMade() {
    return requestMadeByUser.isNotEmpty
        ? ListView.builder(
      itemCount: requestMadeByUser.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, i) {
        String dateAndTime = dateFix(
            '${requestMadeByUser[i]
                .requestMadeAskedTime} -  ${requestMadeByUser[i]
                .requestMadeAskedDate}');
        if (requestMadeByUser[i].requestMadeStatus == "Help Done") {
          status = "Fulfilled";
          width = 67;
          bodyColor = const Color(0xFFF0F0F0);
          textColor = const Color(0xFF667085);
        } else if (requestMadeByUser[i].requestMadeStatus ==
            "Help Not Available") {
          status = "Unfulfilled";
          width = 80;
          bodyColor = const Color(0xFFFFE3E3);
          textColor = const Color(0xFF475467);
        } else if (requestMadeByUser[i].requestMadeStatus ==
            "Searching...") {
          status = "Searching...";
          width = 80;
          bodyColor = const Color(0xFFDBDBDB);
          textColor = const Color(0xFF464646);
        } else if (requestMadeByUser[i].requestMadeStatus ==
            "Cancelled") {
          status = "Cancelled";
          width = 75;
          bodyColor = const Color(0xFFFFE3E3);
          textColor = const Color(0xFF475467);
        } else if (requestMadeByUser[i].requestMadeStatus == "Accepted") {
          status = 'Accepted';
          width = 91.0;
          bodyColor = const Color(0xFF238816);
          textColor = const Color(0xFFD6FFD8);
        }
        var nameOf =
        capitalizeFirstWord(requestMadeByUser[i].requestMadeSubject);
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            if (requestMadeByUser[i].requestMadeStatus == "Help Done") {
              Get.to(AcceptedHelp(
                name: requestMadeByUser[i].requestMadeName,
                pId: requestMadeByUser[i].requestMadePID,
                code: requestMadeByUser[i].requestMadeCode,
                phoneNumber: requestMadeByUser[i].requestMadePhone,
                email: '',
                picLocation: requestMadeByUser[i].requestMadePos,
                message: requestMadeByUser[i].requestMadeSubject,
                request: requestMadeByUser[i].requestMadeStatus,
                imageUrl: requestMadeByUser[i].requestMadeImage,
                userId: requestMadeByUser[i].requestMadeUserId,
                flag: false,
              ))?.then(onChildNavigatorPop);
            }

            if (requestMadeByUser[i].requestMadeStatus ==
                "Searching...") {
              int min = diffTime(
                  requestMadeByUser[i].requestMadeAskedDate,
                  requestMadeByUser[i].requestMadeAskedTime);
              Get.to(
                HelpTimer(
                  value: requestMadeByUser[i].requestMadeSubject,
                  PID: requestMadeByUser[i].requestMadePID,
                  helpCode: requestMadeByUser[i].requestMadeCode,
                  timer: min,
                ),
              )?.then(onChildNavigatorPop);
            }

            if (requestMadeByUser[i].requestMadeStatus ==
                "Help Not Available" ||
                requestMadeByUser[i].requestMadeStatus == "Cancelled") {
              Get.to(HelpTimer(
                value: requestMadeByUser[i].requestMadeSubject,
                PID: requestMadeByUser[i].requestMadePID,
                helpCode: requestMadeByUser[i].requestMadeCode,
                timer: 0,
              ))?.then(onChildNavigatorPop);
            }

            if (requestMadeByUser[i].requestMadeStatus == "Accepted") {
              Get.to(AcceptedHelp(
                name: requestMadeByUser[i].requestMadeName,
                pId: requestMadeByUser[i].requestMadePID,
                code: requestMadeByUser[i].requestMadeCode,
                phoneNumber: requestMadeByUser[i].requestMadePhone,
                email: '',
                picLocation: requestMadeByUser[i].requestMadePos,
                message: requestMadeByUser[i].requestMadeSubject,
                request: requestMadeByUser[i].requestMadeStatus,
                imageUrl: requestMadeByUser[i].requestMadeImage,
                userId: requestMadeByUser[i].requestMadeUserId,
                flag: false,
                onRefresh: () {
                  setState(() {});
                },
              ))?.then(onChildNavigatorPop);
            }

            setState(() async {
              await HistoryFetch.instance.requestAccepted(context);
              await HistoryFetch.instance.requestMade(context);
            });
          },
          child: SizedBox(
            width: double.infinity,
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    requestMadeByUser[i].requestMadeImage == "x" ?
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2970FF),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: SvgPicture.asset(
                        'assets/image/person.svg',
                        height: 18.33,
                        width: 15,
                        color: Colors.white,
                        fit: BoxFit.scaleDown,
                      ),
                    )
                        :
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                      NetworkImage(requestMadeByUser[i].requestMadeImage),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 170,
                          child: Text(
                            nameOf,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF475467),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          dateAndTime,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF98A2B3),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Flexible(
                  child: requestMadeByUser[i].requestMadeStatus ==
                      "Accepted"
                      ? Container(
                      height: 22,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: bodyColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(right: 4.0),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ),
                          // SizedBox(height: 4,),
                          SvgPicture.asset(
                            'assets/image/arrowup.svg',
                            width: 13.0,
                            height: 13.0,
                          ),
                        ],
                      ))
                      : Container(
                    height: 22,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: bodyColor,
                    ),
                    child: Center(
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        )),
                  ),
                )
              ],
            ),
          ),
        );
      },
    )
        : Center(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 68),
        child: Column(
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  'assets/image/smarker.svg',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover, // You can adjust the fit as needed
                ),
                const SizedBox(
                  height: 18,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Seems like you have not made',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475467),
                      ),
                    ),
                    Text(
                      'any help request so far.',
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
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    // Get.to(()=> Contacts( onTap: (){}));
                  },
                  child: Container(
                    height: 40,
                    width: 203,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xFFE3E3E3),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset(
                          'assets/image/plus.svg',
                          height: 18,
                          width: 18,
                          color: const Color(0xFF475467),
                        ),
                        const Text(
                          'Make a help Request',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF475467),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Make a new help request with the',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF667085),
                      ),
                    ),
                    Text(
                      'fellow truckers!',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF667085),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void onChildNavigatorPop(isReloadData) async {
    if (isReloadData != null && isReloadData) {
      setState(() {
        isLoading_requestMade = true;
        isLoading_requestReceived = true;
        requestAcceptedByUser.clear();
      });

      await HistoryFetch.instance.requestAccepted(context);
      await HistoryFetch.instance.requestMade(context);
      setState(() {
        isLoading_requestMade = false;
        isLoading_requestReceived = false;
        print("FetchCompleted>>> ${requestAcceptedByUser.isNotEmpty}");
      });
    }
  }


  int diffTime(String date, String time) {
    DateTimeComponents dateTimeComponents = getCurrentDateTime();
    String time1 = dateTimeComponents.time;
    String date1 = dateTimeComponents.date;
    String dateTimeString1 = '$date $time';
    String dateTimeString2 = '$date1 $time1';
    DateFormat dateFormat = DateFormat('yyyy:MM:dd HH:mm:ss');
    DateTime dateTime1 = dateFormat.parse(dateTimeString1);
    DateTime dateTime2 = dateFormat.parse(dateTimeString2);
    Duration difference = dateTime2.difference(dateTime1);
    int min = 60 - difference.inMinutes;
    return min;
  }


  Future<void> loadRequestHistory1({required BuildContext context}) async {
    await HistoryFetch.instance.requestAccepted(context).then((value) =>
        setState(() {
          isRequestReceived = false;
        }));
  }

  Future<void> loadRequestHistory2({required BuildContext context}) async {
    await HistoryFetch.instance.requestMade(context).then((value) =>
        setState(() {
          isRequestAccepted = false;
        }));
  }
}
  String capitalizeFirstWord(String input) {
    if (input.isEmpty) {
      return input;
    }

    return input[0].toUpperCase() + input.substring(1);
  }

  String dateFix(String input) {
    List<String> parts = input.split(" - ");
    String timeString = parts[0];
    String dateString = parts[1];

    DateTime time = DateFormat.Hms().parse(timeString);

    // Parse date
    List<String> dateParts = dateString.split(":");
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);
    DateTime date = DateTime(year, month, day);

    // Format date and time with AM/PM
    String formattedDateTime = DateFormat("d MMM yyyy h:mm a").format(DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second,
    ));

    return formattedDateTime;
  }
