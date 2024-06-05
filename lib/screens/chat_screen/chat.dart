// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trucker/global/global_class.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/global/global_variables.dart';
import 'package:trucker/requests/groups_fetch.dart';
import 'package:trucker/requests/message_api.dart';
import 'package:trucker/screens/chat_screen/chat_info.dart';
import 'package:trucker/screens/friends_screen/add_participants.dart';
import 'package:trucker/screens/navigation_screen/bottom.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:trucker/share_preferences/shared_preferences_service.dart';
import 'package:trucker/widgets/chat_widget/send.dart';
import 'package:trucker/widgets/chat_widget/simple_recieve.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:intl/intl.dart';
import 'package:trucker/modals/message_modals.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;
import 'package:trucker/widgets/custom_widget/image_pos.dart';
import 'package:fluttertoast/fluttertoast.dart';

// var prefs = SharedPreferencesService.getInstance();

class ChatScreen extends StatefulWidget {
  GroupDetails groupDetails;
  GetIndividualData? userData;
  ChatScreen({Key? key, required this.groupDetails, this.userData});
  VoidCallback? onRefresh;
  var prefs = SharedPreferencesService.getInstance();
  speechToText.SpeechToText speech = speechToText.SpeechToText();
  String textString = "";
  bool isListen = false;

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  bool isInitialLoad = true;
  TextEditingController messageController = TextEditingController();
  TextEditingController updateNameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<GroupMessage> allMessagesList = [];
  bool shouldScrollToLastMessage = true;
  bool getCompanyDetails = false;
  bool isUpdateNameLoading = false;
  bool isUpDateNameButtonEnabled = false;
  String id = '';
  @override
  void initState() {
    super.initState();
    widget.speech = speechToText.SpeechToText();
    updateNameController.addListener(updateButtonState);
    WidgetsBinding.instance.addObserver(this);
    if(dataMap[widget.groupDetails.groupID]!=null) {
      dataMap[widget.groupDetails.groupID]?.isNewMessage = false;
    }
  }

  Future<Set<FinalDetails>> getNonParticipants() async {
    print("Individual Data: $individualData");
    print("Final Details List: $finalDetailsList");
    Set<String> individualNumbers =
        individualData.map((ind) => ind.pNumber).toSet();
    nonParticipants = finalDetailsList
        .where((detail) => !individualNumbers.contains(detail.pNumber))
        .toSet();
    print("Non-participants: $nonParticipants");
    return nonParticipants;
  }

  void displayNonParticipants() async {
    nonParticipants = await getNonParticipants();
    print("Non-participants are: $nonParticipants");
  }

  void updateButtonState() {
    setState(() {
      isUpDateNameButtonEnabled = updateNameController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 72,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFD0D5DD), Color(0xFFEAECF0)],
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              !getCompanyDetails
                  ?
              widget.groupDetails.groupMembers == '2'
              ?
              Flexible(
                child: Row(
                  children: [
                    Container(
                      width: 48.0,
                      height: 48.0,
                      margin: const EdgeInsets.only(right: 12.0),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFCFD4DC),
                          ),
                          borderRadius: BorderRadius.circular(43),
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(43),
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: Color(0xFF475467),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Container(
                      width: 1.5,
                      height: 56,
                      color: const Color(0xFFD0D5DD),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          await GroupHelper().getAllPName(
                              widget.groupDetails.groupID,false);
                          // setState(() {
                          //   getCompanyDetails = true;
                          // });
                          Get.to(()=>ChatInfoScreen(groupDetails: widget.groupDetails,userData: widget.userData,));
                        },
                        child: Row(
                          children: [
                            const SizedBox(width: 12.0),
                            (widget.userData?.pImage??"x") == "x"
                                ? ImagePos(length: 1)
                                : CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  widget.userData!.pImage),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    widget.groupDetails.groupName,
                                    style: const TextStyle(
                                      color: Color(0xFF475466),
                                      fontSize: 18,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if(widget.userData?.pRem!=null)
                                  Text(
                                    (widget.userData?.pStatus??"").toLowerCase() == "online"
                                        ? (widget.userData?.pStatus??"offline") : 'Last seen at ${widget.userData?.pRem??"NA"}',
                                    style: const TextStyle(
                                      color: Color(0xFF98A1B2),
                                      fontSize: 12,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
                  :
              Flexible(
                      child: Row(
                        children: [
                          Container(
                            width: 48.0,
                            height: 48.0,
                            margin: const EdgeInsets.only(right: 12.0),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFCFD4DC),
                                ),
                                borderRadius: BorderRadius.circular(43),
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(43),
                              onTap: () => Get.back(),
                              child: const Icon(
                                Icons.arrow_back,
                                size: 24,
                                color: Color(0xFF475467),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Container(
                            width: 1.5,
                            height: 56,
                            color: const Color(0xFFD0D5DD),
                          ),
                          Flexible(
                            child: InkWell(
                              onTap: () async {
                                await GroupHelper().getAllPName(
                                    widget.groupDetails.groupID,false);
                                // setState(() {
                                //   getCompanyDetails = true;
                                // });
                                // print("on click");
                                Get.to(()=>ChatInfoScreen(groupDetails: widget.groupDetails,userData: widget.userData,));
                              },
                              child: Row(
                                children: [
                                  const SizedBox(width: 12.0),
                                  ImagePos(
                                    length: int.parse(widget.groupDetails.groupMembers),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.groupDetails.groupName,
                                          style: const TextStyle(
                                            color: Color(0xFF475466),
                                            fontSize: 18,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${widget.groupDetails.groupMembers} members',
                                          style: const TextStyle(
                                            color: Color(0xFF98A1B2),
                                            fontSize: 12,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Flexible(
                      child: Row(
                        children: [
                          Container(
                            width: 48.0,
                            height: 48.0,
                            margin: const EdgeInsets.only(right: 12.0),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFCFD4DC),
                                ),
                                borderRadius: BorderRadius.circular(43),
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(43),
                              onTap: () {
                                setState(() {
                                  getCompanyDetails = false;
                                });
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                size: 24,
                                color: Color(0xFF475467),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Container(
                            width: 1.5,
                            height: 56,
                            color: const Color(0xFFD0D5DD),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.groupDetails.groupMembers == '2'?
                                  'User Information':"Group Information",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF475466),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  widget.groupDetails.groupName,
                                  style: const TextStyle(
                                    color: Color(0xFF98A1B2),
                                    fontSize: 12,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
              widget.groupDetails.groupMembers == '2'
                  ? InkWell(
                      onTap: () {
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            MediaQuery.of(context).size.width,
                            80,
                            22.0,
                            10.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          items: [
                            PopupMenuItem(
                              padding: const EdgeInsets.fromLTRB(
                                  12, 12, 40, 12),
                              onTap: () async {
                                if (prefs.userId ==
                                    widget.groupDetails.createBy) {
                                  deleteGroup();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: TOAST_MESSAGE_ONLY_ADMIN_CAN_DELETE_A_GROUP,
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              child: const Text(
                                "Delete group",
                                style: TextStyle(
                                  color: Color(0xFF475466),
                                  fontSize: 16,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      child: const Icon(
                        Icons.more_vert_outlined,
                        color: Color(0xFF344054),
                      ),
                    )
                  : !getCompanyDetails
                      ? InkWell(
                          onTap: () {
                            prefs.userId == widget.groupDetails.createBy
                                ? showMenu(
                                    context: context,
                                    position: RelativeRect.fromLTRB(
                                      MediaQuery.of(context).size.width,
                                      80,
                                      22.0,
                                      10.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    items: [
                                      PopupMenuItem(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 12, 40, 12),
                                        onTap: () {
                                          print("Mute notification");
                                        },
                                        child: const Text(
                                          "Mute notification",
                                          style: TextStyle(
                                            color: Color(0xFF475466),
                                            fontSize: 16,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 12, 40, 12),
                                        onTap: () async {
                                          if (prefs.userId ==
                                              widget.groupDetails.createBy) {
                                            deleteGroup();
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: TOAST_MESSAGE_ONLY_ADMIN_CAN_DELETE_A_GROUP,
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        },
                                        child: const Text(
                                          "Delete group",
                                          style: TextStyle(
                                            color: Color(0xFF475466),
                                            fontSize: 16,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 12, 40, 12),
                                        onTap: () {
                                          print("clear chat");
                                        },
                                        child: const Text(
                                          "Clear chat",
                                          style: TextStyle(
                                            color: Color(0xFF475466),
                                            fontSize: 16,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : showMenu(
                                    context: context,
                                    position: RelativeRect.fromLTRB(
                                      MediaQuery.of(context).size.width,
                                      80,
                                      22.0,
                                      10.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    items: [
                                      PopupMenuItem(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 12, 40, 12),
                                        onTap: () {
                                          print("Mute notification");
                                        },
                                        child: const Text(
                                          "Mute notification",
                                          style: TextStyle(
                                            color: Color(0xFF475466),
                                            fontSize: 16,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 12, 40, 12),
                                        onTap: () async {
                                          int currentMembers = int.parse(
                                              widget.groupDetails.groupMembers);
                                          currentMembers -= 1;
                                          widget.groupDetails.groupMembers =
                                              currentMembers.toString();
                                          await GroupHelper.getSingleUser(
                                              context,
                                              widget.groupDetails.groupID,
                                              prefs.userId);
                                          await GroupHelper.updateTotalMember(
                                            context,
                                            -1,
                                            widget.groupDetails.groupID,
                                          );
                                          individualData.removeWhere((data) =>
                                              data.pName == prefs.name);
                                          setState(() {});
                                          Get.back();
                                          // Get.off(Bottom(
                                          //   selectedIndex: 1,
                                          //   newIndex: 1,
                                          // ));
                                          Fluttertoast.showToast(
                                            msg: TOAST_MESSAGE_GROUP_EXITED_BY_YOU,
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        },
                                        child: const Text(
                                          "Exit group",
                                          style: TextStyle(
                                            color: Color(0xFF475466),
                                            fontSize: 16,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          },
                          child: const Icon(
                            Icons.more_vert_outlined,
                            color: Color(0xFF344054),
                          ),
                        )
                      : prefs.userId == widget.groupDetails.createBy
                          ? InkWell(
                              onTap: () {
                                showMenu(
                                  context: context,
                                  position: RelativeRect.fromLTRB(
                                    MediaQuery.of(context).size.width,
                                    80,
                                    22.0,
                                    10.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  items: [
                                    PopupMenuItem(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 12, 40, 12),
                                      onTap: () {
                                        changeName();
                                      },
                                      child: const Text(
                                        "Rename Group",
                                        style: TextStyle(
                                          color: Color(0xFF475466),
                                          fontSize: 16,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 12, 40, 12),
                                      onTap: () {
                                        if (prefs.userId ==
                                            widget.groupDetails.createBy) {
                                          deleteGroup();
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: TOAST_MESSAGE_ONLY_ADMIN_CAN_DELETE_A_GROUP,
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      },
                                      child: const Text(
                                        "Delete Group",
                                        style: TextStyle(
                                          color: Color(0xFF475466),
                                          fontSize: 16,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 12, 40, 12),
                                      onTap: () {
                                        // widget.onRefresh?.call();
                                        setState(() {
                                          print(
                                              "calling set state delete groups");
                                        });
                                        displayNonParticipants();
                                        Get.to(
                                          () => AddParticipant(
                                            groupDetail: widget.groupDetails,
                                            onTap: () {
                                              setState(() {
                                                print("SetState Called *");
                                              });
                                            },
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Add New Member",
                                        style: TextStyle(
                                          color: Color(0xFF475466),
                                          fontSize: 16,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              child: const Icon(
                                Icons.more_vert_outlined,
                                color: Color(0xFF344054),
                              ),
                            )
                          : PopupMenuButton<String>(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              itemBuilder: (BuildContext context) {
                                return [
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Text(
                                          "Exit Group",
                                          style: TextStyle(
                                            color: Color(0xFF475466),
                                            fontSize: 16,
                                            fontFamily: 'SF Pro',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                              onSelected: (String value) async {
                                if (value == 'delete') {
                                  print('Delete the participant');
                                  int currentMembers = int.parse(
                                      widget.groupDetails.groupMembers);
                                  currentMembers -= 1;
                                  widget.groupDetails.groupMembers =
                                      currentMembers.toString();
                                  await GroupHelper.getSingleUser(
                                      context,
                                      widget.groupDetails.groupID,
                                      prefs.userId);
                                  await GroupHelper.updateTotalMember(
                                    context,
                                    -1,
                                    widget.groupDetails.groupID,
                                  );
                                  individualData.removeWhere(
                                      (data) => data.pName == prefs.name);
                                  setState(() {});
                                  Get.back();
                                  // Get.off(Bottom(
                                  //   selectedIndex: 1,
                                  //   newIndex: 1,
                                  // ));
                                  Fluttertoast.showToast(
                                    msg: TOAST_MESSAGE_GROUP_EXITED_BY_YOU,
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              child: const Icon(
                                Icons.more_vert_outlined,
                                color: Color(0xFF344054),
                              ),
                            )
            ],
          ),
        ),
        body: !getCompanyDetails
            ? Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: StreamBuilder(
                        stream: MessageApi.allmessages(widget.groupDetails),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              isInitialLoad) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFF8D49),
                              ),
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data?.docs.isEmpty == true) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/image/message-zero.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 18),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'No messages here yet...',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'SF Pro',
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF475467),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      InkWell(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        onTap: () {
                                          MessageApi.sendMessage(
                                              widget.groupDetails,
                                              "Hi",
                                              MessageType.text);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 10, 16, 10),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  width: 1,
                                                  color: Color(0xFFCFD4DC)),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                          child: const Text(
                                            'Say”Hi”',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF475466),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                          if (isInitialLoad) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                isInitialLoad = false;
                              });
                            });
                          }
                          final data = snapshot.data?.docs;
                          allMessagesList = data
                                  ?.map((e) => GroupMessage.fromJson(e.data()))
                                  .toList() ??
                              [];
                          if (allMessagesList.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              controller: _scrollController,
                              itemCount: allMessagesList.length,
                              itemBuilder: (context, index) {
                                return whichMessage(allMessagesList[index]);
                              },
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(2, 2, 16, 2),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFEAECF0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: messageController,
                              maxLines: null,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 12, 0, 12),
                                border: InputBorder.none,
                                hintText: "Message",
                                hintStyle: const TextStyle(
                                  color: Color(0xFF98A1B2),
                                  fontSize: 18,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        listenToUser();
                                      },
                                      child: widget.isListen
                                          ? AvatarGlow(
                                              animate: widget.isListen,
                                              glowColor:
                                                  const Color(0xFFFF8D49),
                                              duration: const Duration(
                                                  milliseconds: 2000),
                                              repeat: true,
                                              child: SvgPicture.asset(
                                                'assets/image/mic.svg',
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.scaleDown,
                                              ),
                                            )
                                          : SvgPicture.asset(
                                              'assets/image/mic.svg',
                                              width: 20,
                                              height: 20,
                                              fit: BoxFit.scaleDown,
                                            ),
                                    ),
                                    const SizedBox(width: 12.0),
                                    InkWell(
                                      onTap: () {
                                        _pickImageToSend();
                                      },
                                      child: SvgPicture.asset(
                                        'assets/image/camera.svg',
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        InkWell(
                          onTap: () {
                            if (messageController.text.isNotEmpty) {
                              DateTime now = DateTime.now();
                              String formattedTime =
                              DateFormat('h:mm a').format(now);
                              log("at $formattedTime");
                              setState(() {
                                widget.isListen = false;
                              });
                              MessageApi.sendMessage(widget.groupDetails,
                                  messageController.text, MessageType.text);
                              messageController.clear();
                            }
                          },
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFF8D49),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(43),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 24.0,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : widget.groupDetails.groupMembers == '2'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(individualData.length, (index) {
                      return individualData[index].pNumber == prefs.phoneNumber
                          ? const SizedBox()
                          : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 50.0),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  individualData[index].pImage == "x"
                                      ? Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF98A2B3),
                                            borderRadius:
                                                BorderRadius.circular(43),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/image/person.svg',
                                            color: Colors.white,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 55,
                                          backgroundImage: NetworkImage(
                                              individualData[index].pImage),
                                        ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 12.0),
                                                child: Text(
                                                  individualData[index].pName,
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color(0xFF475466),
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 12.0),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset('assets/image/call.svg',
                                                      width: 18,
                                                      height: 18,
                                                    ),
                                                    SizedBox(width: 8,),
                                                    Text(
                                                      individualData[index].pNumber,
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Color(0xFF475466),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ),
                                              const SizedBox(width: 22),
                                              individualData[index].pNumber ==
                                                      prefs.phoneNumber
                                                  ? const SizedBox()
                                                  : individualData[index]
                                                              .pStatus ==
                                                          "Online"
                                                      ? Text(
                                                          individualData[index]
                                                              .pStatus,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF238816),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        )
                                                      : ((individualData[index].pRem!=null)?Text(
                                                          "Last seen at ${individualData[index].pRem}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF98A2B3),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )):SizedBox.shrink()
                                                        ),
                                            ],
                                          ),
                                          const SizedBox(width: 8),
                                          int.parse(widget.groupDetails.groupMembers) == 2
                                              ?
                                          const SizedBox()
                                              :
                                          individualData[index].pId ==
                                                  widget.groupDetails.createBy
                                              ? const Text(
                                                  "Admin",
                                                  style: TextStyle(
                                                    color: Color(0xFFFF8D49),
                                                    fontSize: 12,
                                                    fontFamily: 'SF Pro',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                    }))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                individualData.length,
                                (index) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [
                                              individualData[index].pImage ==
                                                      "x"
                                                  ? Container(
                                                      width: 35.0,
                                                      height: 35.0,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFF98A2B3),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(43),
                                                        border: Border.all(
                                                          color: Colors.white,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      child: SvgPicture.asset(
                                                        'assets/image/person.svg',
                                                        color: Colors.white,
                                                        fit: BoxFit.scaleDown,
                                                      ),
                                                    )
                                                  : CircleAvatar(
                                                      radius: 15,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              individualData[
                                                                      index]
                                                                  .pImage),
                                                    ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          individualData[index]
                                                              .pName,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF475466),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        individualData[index]
                                                                    .pNumber ==
                                                                prefs
                                                                    .phoneNumber
                                                            ? const SizedBox()
                                                            : individualData[
                                                                            index]
                                                                        .pStatus ==
                                                                    "Online"
                                                                ? Text(
                                                                    individualData[
                                                                            index]
                                                                        .pStatus,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color(
                                                                          0xFF238816),
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    "Last seen at ${individualData[index].pRem}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color(
                                                                          0xFF98A2B3),
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 8),
                                                     individualData[index].pId ==
                                                         widget.groupDetails
                                                             .createBy
                                                         ? const Text(
                                                       "Admin",
                                                       style: TextStyle(
                                                         color: Color(
                                                             0xFFFF8D49),
                                                         fontSize: 12,
                                                         fontFamily:
                                                         'SF Pro',
                                                         fontWeight:
                                                         FontWeight
                                                             .w500,
                                                       ),
                                                     )
                                                         :
                                                     const SizedBox()
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        prefs.userId ==
                                                widget.groupDetails.createBy
                                            ? PopupMenuButton<String>(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                ),
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return [
                                                    const PopupMenuItem<String>(
                                                      value: 'delete',
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Remove User",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF475466),
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'SF Pro',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ];
                                                },
                                                onSelected:
                                                    (String value) async {
                                                  if (value == 'delete') {
                                                    print(
                                                        'Delete the participant');
                                                    if (prefs.userId ==
                                                        widget.groupDetails
                                                            .createBy) {
                                                      if (individualData[index]
                                                              .pId ==
                                                          widget.groupDetails
                                                              .createBy) {
                                                        Fluttertoast.showToast(
                                                          msg: "Admin cannot be removed from the group.",
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0,
                                                        );
                                                      } else {
                                                        int currentMembers =
                                                            int.parse(widget
                                                                .groupDetails
                                                                .groupMembers);
                                                        currentMembers -= 1;
                                                        widget.groupDetails
                                                                .groupMembers =
                                                            currentMembers
                                                                .toString();
                                                        await GroupHelper
                                                            .getSingleUser(
                                                                context,
                                                                widget
                                                                    .groupDetails
                                                                    .groupID,
                                                                individualData[
                                                                        index]
                                                                    .pId);
                                                        await GroupHelper
                                                            .updateTotalMember(
                                                          context,
                                                          -1,
                                                          widget.groupDetails
                                                              .groupID,
                                                        );
                                                        individualData
                                                            .removeWhere((data) =>
                                                                data.pName ==
                                                                individualData[
                                                                        index]
                                                                    .pName);
                                                        setState(() {});
                                                        Fluttertoast.showToast(
                                                          msg:
                                                              "User removed successfully.",
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0,
                                                        );
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: TOAST_MESSAGE_ONLY_ADMIN_CAN_DELETE_A_GROUP,
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    }
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons.more_vert_outlined,
                                                  color: Color(0xFF344054),
                                                ),
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      prefs.userId == widget.groupDetails.createBy
                          ? Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      print("Add new member button pressed");
                                      displayNonParticipants();
                                      Get.to(
                                        () => AddParticipant(
                                          groupDetail: widget.groupDetails,
                                          onTap: () {
                                            setState(() {
                                              print("SetState Called *");
                                            });
                                          },
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(55),
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 10, 16, 10),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFFF8D49),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(55),
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.add,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Add New Member',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  prefs.userId == widget.groupDetails.createBy
                                      ? Row(
                                          children: [
                                            const SizedBox(width: 15),
                                            InkWell(
                                              onTap: () {
                                                deleteGroup();
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(55),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16, 10, 16, 10),
                                                decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                      width: 1,
                                                      color: Color(0xFFCFD4DC),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            55),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Delete Group',
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
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            )
                          : const SizedBox()
                    ],
                  ));
  }


  // This Function is used to send an image to the chat.
  Future _pickImageToSend() async {
    final XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      await MessageApi.sendImage(widget.groupDetails, File(image.path));
    }
  }

  // This will use to convert use voice to text.
  void listenToUser() async {
    if (!widget.isListen) {
      bool avail = await widget.speech.initialize();
      if (avail) {
        setState(() {
          widget.isListen = true;
        });
        widget.speech.listen(onResult: (value) {
          setState(() {
            messageController.text = value.recognizedWords;
            widget.textString = value.recognizedWords;
          });
        });
      }
    } else {
      setState(() {
        widget.isListen = false;
      });
      widget.speech.stop();
    }
  }

  // This message is use to display the toast message to the user.
  void showToast(String Message) => Fluttertoast.showToast(msg: Message);

  // This function is used to change the name of the group.
  void changeName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              child: IntrinsicHeight(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            color: const Color(0xFFF2F3F6),
                            padding: const EdgeInsets.all(16.0),
                            child: const Text(
                              'Update Group name',
                              style: TextStyle(
                                color: Color(0xFF475466),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 16),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFF2F3F6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: updateNameController,
                                    decoration: const InputDecoration(
                                      hintStyle: TextStyle(
                                        color: Color(0xFF98A1B2),
                                        fontSize: 16,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      hintText: "Enter the new group name",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {},
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: const Color(0xFFF2F3F6),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  print("No button pressed");
                                },
                                borderRadius: BorderRadius.circular(25.0),
                                child: const TextButton(
                                  onPressed: null,
                                  child: Text(
                                    "Cancel",
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
                          Expanded(
                            child: Container(
                              color: const Color(0xFFEAECF0),
                              child: InkWell(
                                onTap: () {
                                  widget.groupDetails.groupName =
                                      updateNameController.text;
                                  print(
                                      "the new group will be ${updateNameController.text}");
                                  GroupHelper.changeGroupName(
                                      context,
                                      widget.groupDetails.groupID,
                                      updateNameController.text);
                                  Navigator.pop(context);
                                },
                                borderRadius: BorderRadius.circular(25.0),
                                child: const TextButton(
                                  onPressed: null,
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                      color: Color(0xFFFF5449),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // This group is used to delete a particular group from the database.
  void deleteGroup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              child: IntrinsicHeight(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            color: const Color(0xFFF2F3F6),
                            padding: const EdgeInsets.all(16.0),
                            child: const Text(
                              'Delete Group',
                              style: TextStyle(
                                color: Color(0xFF475466),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                            child: const Column(
                              children: [
                                Text(
                                  "Are you sure you want to delete the group??",
                                  style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF475467),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: const Color(0xFFF2F3F6),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  print("No button pressed");
                                },
                                borderRadius: BorderRadius.circular(25.0),
                                child: const TextButton(
                                  onPressed: null,
                                  child: Text(
                                    "No",
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
                          Expanded(
                            child: Container(
                              color: const Color(0xFFEAECF0),
                              child: InkWell(
                                onTap: () async {
                                  await GroupHelper.instance.deleteGroups(
                                      context, widget.groupDetails.groupID,
                                      onDelete: () {});
                                  Navigator.pop(context);
                                  Get.back();
                                },
                                borderRadius: BorderRadius.circular(25.0),
                                child: const TextButton(
                                  onPressed: null,
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                      color: Color(0xFFFF5449),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  // This will decide which type of widget has to display to the user.
  Widget whichMessage(GroupMessage messages) {
    return prefs.userId == messages.fromPID
        ? SendMessage(
            message: messages.message,
            time: messages.sendat,
            seenMessage: true,
            type: messages.type,
          )
        : SimpleReceive(
            sendName: messages.fromPName,
            sendMessage: messages.message,
            sendMessageTime: messages.sendat,
            type: messages.type,
          );
  }
}
