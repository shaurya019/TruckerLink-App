import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:trucker/global/global_class.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/requests/groups_fetch.dart';
import 'package:trucker/screens/chat_screen/chat.dart';
import 'package:trucker/screens/navigation_screen/bottom.dart';
import 'package:trucker/widgets/custom_widget/image_pos.dart';

import '../../screens/profile_screen/profile.dart';

bool isLoadingGroup = true;

class Groups extends StatefulWidget {
  const Groups({super.key, required this.onTap, this.onRefresh,this.onOpenFriendsTabCalled});
  final VoidCallback onTap;
  final VoidCallback? onRefresh;
  final VoidCallback? onOpenFriendsTabCalled;

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  String item1 = 'Delete group';
  Offset? _tabPosition;

  @override
  void initState() {
    super.initState();
    loadGroupDetails(context: context);
  }

  void showToast(String message) => Fluttertoast.showToast(msg: message);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              minHeight: 21,
            ),
            child: const Text(
              'Friends',
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475467),
              ),
            ),
          ),
          const SizedBox(height: 20),
          detailsUser.isNotEmpty
              ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Column(
                              children: detailsUser.take(3).map((groupDetails) {
                  // Add the following lines to call GetIndividualData
                  GetIndividualData? filteredData;
                  if (int.parse(groupDetails.groupMembers) == 2) {
                    if (dataMap.containsKey(groupDetails.groupID)) {
                      filteredData = dataMap[groupDetails.groupID]!;
                      if (groupDetails.groupName == prefs.name) {
                        groupDetails.groupName = filteredData.pName;
                      }
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            groupDetails.groupMembers == '2'
                                ?
                            InkWell(
                              highlightColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Get.to(ChatScreen(
                                    groupDetails: groupDetails,
                                    userData : filteredData
                                ));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        (filteredData?.pImage??"x") == "x"
                                            ? ImagePos(length: 1)
                                            :
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: 46.0,
                                            height: 46.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF98A2B3),
                                              borderRadius: BorderRadius.circular(43),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                            ),
                                            child:CircleAvatar(

                                              radius: 20,
                                              backgroundImage: NetworkImage(
                                                  filteredData!.pImage),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                groupDetails.groupName,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontFamily: 'SF Pro',
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF475467),
                                                ),
                                              ),
                                              if(filteredData?.pStatus!=null)
                                              Text(
                                                (filteredData!.pStatus == "Online")
                                                    ? filteredData.pStatus : 'Last seen at ${filteredData.pRem}',
                                                style: const TextStyle(
                                                  fontFamily: 'SF Pro',
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF98A2B3),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  InkWell(
                                    onTapDown: (position) {
                                      _tabPosition = position.globalPosition;
                                      var deleteGid = groupDetails.groupID;
                                      showPopupMenu(context, _tabPosition!, deleteGid, 0);
                                    },
                                    child: const Icon(
                                      Icons.more_vert,
                                      size: 24.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            )
                                :
                            InkWell(
                              highlightColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Get.to(ChatScreen(
                                  groupDetails: groupDetails,
                                ));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        ImagePos(length: detailsUser.length,),
                                        const SizedBox(width: 12),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                groupDetails.groupName,
                                                style: const TextStyle(
                                                  fontFamily: 'SF Pro',
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF475467),
                                                ),
                                              ),
                                              Text(
                                                "${groupDetails.groupMembers} participants",
                                                style: const TextStyle(
                                                  fontFamily: 'SF Pro',
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF98A2B3),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  InkWell(
                                    onTapDown: (position) {
                                      _tabPosition = position.globalPosition;
                                      var deleteGid = groupDetails.groupID;
                                      showPopupMenu(context, _tabPosition!, deleteGid, 0);
                                    },
                                    child: const Icon(
                                      Icons.more_vert,
                                      size: 24.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ]
                    ),
                  );
                              }).toList(),
                            ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    // widget.onTap.call();
                    if(widget.onOpenFriendsTabCalled!=null) {
                      widget.onOpenFriendsTabCalled!();
                    }
                    Get.back();
                    // Get.off(Bottom(selectedIndex: 1, newIndex: 1,));
                  },
                  child: Container(
                    width: 88,
                    height: 28,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: const Color(0xFFf2f4f7),
                    ),
                    child: const Center(
                      child: Text(
                        "see all",
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                          color: Color(0xFF475467),
                        ),
                      ),
                    ),
                  ),
                ),
                ],
              )
              : Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/image/message-zero.png',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover, // You can adjust the fit as needed
                ),
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  'Create a group to start \n a chat with your friends.',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475467),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showPopupMenu(BuildContext context, Offset position, gid, int index) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width,
        position.dy + 12,
        22.0,
        0.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      items: [
        PopupMenuItem(
          child: Text(item1),
          onTap: () async {
            if (detailsUser.elementAt(index).createBy == prefs.userId) {
              await GroupHelper.instance.deleteGroups(context, gid,
                  onDelete: () {
                    widget.onRefresh?.call();
                  });
              setState(() {});
            } else {
              Fluttertoast.showToast(
                  msg: "Only Admin can Delete the group!",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
        ),
      ],
    );
  }

  Future<void> loadGroupDetails({required BuildContext context}) async {
    await GroupHelper.instance.getAllGroupDetails();
    print("G2");
    setState(() {
      isLoadingGroup = false;
    });
  }
}


