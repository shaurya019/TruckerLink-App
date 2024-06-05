import 'package:b_dep/b_dep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:trucker/global/global_class.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/global/global_variables.dart';
import 'package:trucker/requests/groups_fetch.dart';
import 'package:trucker/screens/chat_screen/chat.dart';
import 'package:trucker/screens/friends_screen/contacts.dart';
import 'package:trucker/widgets/custom_widget/custom_checkbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trucker/widgets/custom_widget/image_pos.dart';
import 'package:trucker/widgets/help_widget/help_direction.dart';
import 'package:uuid/uuid.dart';

import '../../screens/profile_screen/profile.dart';

class GroupList extends StatefulWidget {
  final VoidCallback? onRefresh;
  const GroupList({super.key, this.onRefresh});

  @override
  State<GroupList> createState() => GroupListState();
}

class GroupListState extends State<GroupList> {
  TextEditingController textEditingController = TextEditingController();
  Offset? _tabPosition;
  bool onLongPress = false;
  int peopleAroundYou = 10;
  @override
  void initState() {
    super.initState();
    checkCount = 0;
    checkedGroupGid.clear();
    for (int i = 0; i < detailsUser.length; i++) {
      itemCheckboxStates[i] = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingMute
        ? const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF8D49)),
          )
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !onLongPress
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(43),
                              color: Colors.grey.shade200,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextField(
                                    cursorColor: Colors.black,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    controller: textEditingController,
                                    onChanged: (value) {
                                      setState(() {
                                        filterQuery = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Search Friends',
                                      hintStyle:
                                          TextStyle(color: Color(0xFF475467)),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: textEditingController.text.isEmpty,
                                  child: InkWell(
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                      'assets/image/search.svg',
                                      height: 18,
                                      width: 18,
                                      color: const Color(0xFF475467),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      textEditingController.text.isNotEmpty,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        textEditingController.clear();
                                        filterQuery = '';
                                      });
                                    },
                                    child: SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: SvgPicture.asset(
                                        'assets/image/cross.svg',
                                        height: 24,
                                        width: 24,
                                        color: const Color(0xFF475467),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(43),
                              color: const Color(0xFFEAECF0),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      onLongPress = false;
                                      itemCheckboxStates.clear();
                                      for (int i = 0; i < groupLength; i++) {
                                        itemCheckboxStates[i] = false;
                                      }
                                      checkCount = 0;
                                      checkedGroupGid.clear();
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'assets/image/cross.svg',
                                    width: 18,
                                    height: 18,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    "$checkCount",
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    for (int i = 0;
                                        i < checkedGroupGid.length;
                                        i++) {
                                      await GroupHelper.instance.deleteGroups(
                                          context, checkedGroupGid[i],
                                          onDelete: () {});
                                    }
                                    widget.onRefresh?.call();
                                    setState(() {
                                      print("calling set state delete groups");
                                    });
                                    checkedGroupGid.clear();
                                    onLongPress = false;
                                    itemCheckboxStates.clear();
                                    Fluttertoast.showToast(
                                      msg: "All group deleted successfully.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  },
                                  child: SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: SvgPicture.string(
                                      '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M16 6V5.2C16 4.0799 16 3.51984 15.782 3.09202C15.5903 2.71569 15.2843 2.40973 14.908 2.21799C14.4802 2 13.9201 2 12.8 2H11.2C10.0799 2 9.51984 2 9.09202 2.21799C8.71569 2.40973 8.40973 2.71569 8.21799 3.09202C8 3.51984 8 4.0799 8 5.2V6M3 6H21M19 6V17.2C19 18.8802 19 19.7202 18.673 20.362C18.3854 20.9265 17.9265 21.3854 17.362 21.673C16.7202 22 15.8802 22 14.2 22H9.8C8.11984 22 7.27976 22 6.63803 21.673C6.07354 21.3854 5.6146 20.9265 5.32698 20.362C5 19.7202 5 18.8802 5 17.2V6" stroke="#667085" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              ''',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ),
                  // people around you
                  peopleNearMe(),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Friends',
                      style: TextStyle(
                        color: Color(0xFF475466),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  isLoadingMute
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFFFF8D49)),
                        )
                      : detailsUser.isNotEmpty
                          ? Expanded(child: buildList())
                          : showAddGroups()
                ],
              ),
            ),
          );
  }

  Widget noPeopleAround() {
    return const Column(
      children: [
        SizedBox(
          height: 12,
        ),
        Center(
          child: Text(
            'Currently unable to find anyone in your vicinity.',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w500,
              color: Color(0xFF475467),
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget showAddGroups() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: Column(
          children: [
            Image.asset(
              'assets/image/message-zero.png',
              width: 64,
              height: 64,
              fit: BoxFit.cover,
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
            InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () async {
                Get.to(
                  () => Contacts(
                    onTap: () {},
                    onGroupCreated: () {
                      print("Wait completed--0");
                    },
                  ),
                )?.then((value) {
                  print("Wait completed--");
                });
              },
              child: Container(
                height: 40,
                width: 155,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      'assets/image/plus.svg',
                      height: 11,
                      width: 11,
                      color: const Color(0xFF475467),
                    ),
                    const Text(
                      'Create Groups',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475467),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildList() {
    print("Build ,list called");
    filteredGroups = filterGroups(filterQuery);
    // return SizedBox.shrink();
    return ListView.builder(
      itemCount: filteredGroups.length,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        GetIndividualData? filteredData;
        GroupDetails groupDetails = filteredGroups[i];
        if (int.parse(groupDetails.groupMembers) == 2) {
          if (dataMap.containsKey(groupDetails.groupID)) {
            filteredData = dataMap[groupDetails.groupID]!;
            if (groupDetails.groupName == prefs.name) {
              groupDetails.groupName = filteredData.pName;
            }
            print("list> ${filteredData.latestMessage} | ${groupDetails.groupID}");
          }
        }
        return groupDetails.groupMembers == '2'
            ? InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        print("Values ^_^ ${itemCheckboxStates[i]} - ${i} ");
                        itemCheckboxStates[i] =
                            !(itemCheckboxStates[i] ?? false);
                        setState(() {
                          checkCount = itemCheckboxStates.values.where((value) => value == true).length;
                          if (itemCheckboxStates[i]!) {
                            checkedGroupGid.add(groupDetails.groupID);
                          } else {
                            checkedGroupGid.remove(groupDetails.groupID);
                          };
                        });

                        if (onLongPress == false) {
                          Get.to(ChatScreen(
                              groupDetails: groupDetails,
                              userData: filteredData));
                          print("Wait completed 1");
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          onLongPress = true;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                onLongPress
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 11.0),
                                        child: (prefs.userId ==
                                                groupDetails.createBy||(int.parse(groupDetails.groupMembers) == 2))
                                            ? CustomCheckbox(
                                                isChecked:
                                                    itemCheckboxStates[i] ??
                                                        false,
                                                onChange: (value) {
                                                  itemCheckboxStates[i] = value;
                                                  print("value - $value");
                                                  setState(() {
                                                    checkCount =
                                                        itemCheckboxStates
                                                            .values
                                                            .where((value) =>
                                                                value == true)
                                                            .length;
                                                    if (value) {
                                                      checkedGroupGid.add(
                                                          groupDetails.groupID);
                                                    } else {
                                                      checkedGroupGid.remove(
                                                          groupDetails.groupID);
                                                    }
                                                    print(checkedGroupGid);
                                                  });
                                                  print(checkCount);
                                                },
                                                backgroundColor:
                                                    const Color(0xFFFF8D49),
                                                iconColor: Colors.white,
                                                icon: Icons.check,
                                                size: 40,
                                                iconSize: 14,
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "You are not the admin!",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                },
                                                child: IgnorePointer(
                                                  child: CustomCheckbox(
                                                    isChecked: false,
                                                    onChange: (value) {},
                                                    backgroundColor:
                                                        const Color(0xFFFF8D49),
                                                    iconColor: Colors.white,
                                                    icon: Icons.check,
                                                    size: 40,
                                                    iconSize: 14,
                                                  ),
                                                ),
                                              ),
                                      )
                                    : const SizedBox(),
                                (filteredData?.pImage ?? "x") == "x"
                                    ? ImagePos(length: 1)
                                    : Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          // width: 35.0,
                                          // height: 35.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF98A2B3),
                                            borderRadius:
                                                BorderRadius.circular(43),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(
                                                filteredData?.pImage ?? "x"),
                                          ),
                                        ),
                                      ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      // const SizedBox(height: 5),

                                      if(filteredData?.latestMessage!=null||filteredData?.pRem!=null)
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          if(filteredData?.isNewMessage??false)
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.red,
                                              ),
                                            ),
                                          if(filteredData?.isNewMessage??false)
                                          SizedBox(width: 5,),
                                          Text(
                                            filteredData?.latestMessage!=null?filteredData!.latestMessage!:(
                                            ((filteredData?.pStatus ?? "offline").toLowerCase() == "online")
                                                ? (filteredData?.pStatus ??
                                                    "offline")
                                                : 'Last seen at ${filteredData?.pRem ?? "NA"}'),
                                            style: const TextStyle(
                                              fontFamily: 'SF Pro',
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF98A2B3),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              onLongPress
                                  ? const SizedBox()
                                  : InkWell(
                                      onTapDown: (position) {
                                        _tabPosition = position.globalPosition;
                                        var deleteGid = groupDetails.groupID;
                                        var createdBy = groupDetails.createBy;
                                        showPopupMenu(context, _tabPosition!,
                                            deleteGid, createdBy, '1');
                                      },
                                      child: const Icon(
                                        Icons.more_vert,
                                        size: 24.0,
                                        color: Colors.black,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (onLongPress == false) {
                          Get.to(ChatScreen(
                              groupDetails: groupDetails,
                              userData: filteredData));
                        }
                        itemCheckboxStates[i] =
                            !(itemCheckboxStates[i] ?? false);
                        setState(() {
                          checkCount = itemCheckboxStates.values.where((value) => value == true).length;
                          if (itemCheckboxStates[i]!) {
                            checkedGroupGid.add(groupDetails.groupID);
                          } else {
                            checkedGroupGid.remove(groupDetails.groupID);
                          }
                          print(checkedGroupGid);
                        });
                      },
                      onLongPress: () {
                        setState(() {
                          onLongPress = true;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                onLongPress
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 11.0),
                                        child: CustomCheckbox(
                                          isChecked:
                                              itemCheckboxStates[i] ?? false,
                                          onChange: (value) {
                                            itemCheckboxStates[i] = value;
                                            setState(() {
                                              checkCount = itemCheckboxStates
                                                  .values
                                                  .where(
                                                      (value) => value == true)
                                                  .length;
                                              if (value) {
                                                checkedGroupGid
                                                    .add(groupDetails.groupID);
                                              } else {
                                                checkedGroupGid.remove(
                                                    groupDetails.groupID);
                                              }
                                              print(checkedGroupGid);
                                            });
                                            print(checkCount);
                                          },
                                          backgroundColor:
                                              const Color(0xFFFF8D49),
                                          iconColor: Colors.white,
                                          icon: Icons.check,
                                          size: 40,
                                          iconSize: 14,
                                        )

                                        // prefs.userId == groupDetails.createBy
                                        //     ? CustomCheckbox(
                                        //         isChecked:
                                        //             itemCheckboxStates[i] ?? false,
                                        //         onChange: (value) {
                                        //           itemCheckboxStates[i] = value;
                                        //           setState(() {
                                        //             checkCount = itemCheckboxStates
                                        //                 .values
                                        //                 .where(
                                        //                     (value) => value == true)
                                        //                 .length;
                                        //             if (value) {
                                        //               checkedGroupGid
                                        //                   .add(groupDetails.groupID);
                                        //             } else {
                                        //               checkedGroupGid.remove(
                                        //                   groupDetails.groupID);
                                        //             }
                                        //             print(checkedGroupGid);
                                        //           });
                                        //           print(checkCount);
                                        //         },
                                        //         backgroundColor:
                                        //             const Color(0xFFFF8D49),
                                        //         iconColor: Colors.white,
                                        //         icon: Icons.check,
                                        //         size: 40,
                                        //         iconSize: 14,
                                        //       )
                                        //     : InkWell(
                                        //         onTap: () {
                                        //           Fluttertoast.showToast(
                                        //             msg: "You are not the admin!",
                                        //             toastLength: Toast.LENGTH_LONG,
                                        //             gravity: ToastGravity.CENTER,
                                        //             timeInSecForIosWeb: 1,
                                        //             textColor: Colors.white,
                                        //             fontSize: 16.0,
                                        //           );
                                        //         },
                                        //         child: IgnorePointer(
                                        //           child: CustomCheckbox(
                                        //             isChecked: false,
                                        //             onChange: (value) {},
                                        //             backgroundColor:
                                        //                 const Color(0xFFFF8D49),
                                        //             iconColor: Colors.white,
                                        //             icon: Icons.check,
                                        //             size: 40,
                                        //             iconSize: 14,
                                        //           ),
                                        //         ),
                                        //       ),
                                        )
                                    : const SizedBox(),
                                ImagePos(
                                  length: int.parse(groupDetails.groupMembers),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      const SizedBox(height: 5),
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
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              onLongPress
                                  ? const SizedBox()
                                  : InkWell(
                                      onTapDown: (position) {
                                        _tabPosition = position.globalPosition;
                                        var deleteGid = groupDetails.groupID;
                                        var createdBy = groupDetails.createBy;
                                        showPopupMenu(context, _tabPosition!,
                                            deleteGid, createdBy, '1');
                                      },
                                      child: const Icon(
                                        Icons.more_vert,
                                        size: 24.0,
                                        color: Colors.black,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget peopleNearMe() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'People around you.',
            style: TextStyle(
              color: Color(0xFF475466),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        peopleAroundYou > 0 ? nearByPerson() : noPeopleAround(),
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFCFD4DC),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget nearByPerson() {
    // print("nearByPerson");
    return SizedBox(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: peopleAround.length,
          padding: const EdgeInsets.only(left: 10),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int i) {
            return TextButton(
              onPressed: () async {
                await checkForExistingGroup(peopleAround[i]);
              },
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: SizedBox(
                width: 80,
                child: Column(
                  children: [
                    peopleAround[i].image != 'x'
                        ? CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(peopleAround[i].image),
                          )
                        : Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFF98A2B3),
                              borderRadius: BorderRadius.circular(43),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: SvgPicture.asset(
                              'assets/image/person.svg',
                              height: 40,
                              width: 40,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                    const SizedBox(height: 5),
                    Text(
                      peopleAround[i].name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475467),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  void showToast(String message) => Fluttertoast.showToast(msg: message);

  bool clickYes = false;
  void showDialogBox(NearbyPerson peopleAround) async {
    clickYes = true;
    // setStateDialog(() {
    //   print("YES Clicked");
    // });
    await createNewGroup(peopleAround);
    if(widget?.onRefresh!=null) {
      widget.onRefresh?.call();
    }
    return;
  }

  Future<void> checkForExistingGroup(NearbyPerson peopleAround) async {
    String checkForExisting = '', gName = '';
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: 'cf40d220-af5e-1e32-83d6-03d89d8c60e7',
      // context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        'P_Id1': prefs.userId,
        'P_Id2': peopleAround.userId,
      };
      return jsonData;
    }

    var response = await bBlupSheetsApi.runHttpApi(
        queryId: "cf40d220-af5e-1e32-83d6-03d89d8c60e7",
        jsonData: getJsonData());
    print("response - $response");
    for (var res in response) {
      print('res - ${res['G_Id']}');
      checkForExisting = res['G_Id'];
      gName = res['G_Name'];
    }
    if (checkForExisting == '') {
      showDialogBox(peopleAround);
    } else {
      GroupDetails newGroupDetails = GroupDetails(
        groupName: gName,
        groupMembers: '2',
        groupID: checkForExisting,
        createBy: prefs.userId!,
      );
      GetIndividualData user = GetIndividualData(
        pName: peopleAround.name,
        pId: peopleAround.userId,
        pNumber: peopleAround.phoneNumber,
        pRem: peopleAround.pastTime,
        pStatus: peopleAround.status,
        pImage: peopleAround.image,
      );
      Get.to(ChatScreen(groupDetails: newGroupDetails, userData: user));
      print("Wait completed 4");
    }
  }

  Future<void> createNewGroup(NearbyPerson peopleAround) async {
    String gId = const Uuid().v1();
    String groupName = peopleAround.name;
    await saveGroupDetails(peopleAround, gId, groupName);
    await saveGidAndPid(peopleAround, gId, groupName);
    GroupDetails newGroupDetails = GroupDetails(
      groupName: groupName,
      groupMembers: '2',
      groupID: gId,
      createBy: prefs.userId!,
    );
    GetIndividualData user = GetIndividualData(
      pName: peopleAround.name,
      pId: peopleAround.userId,
      pNumber: peopleAround.phoneNumber,
      pRem: peopleAround.pastTime,
      pStatus: peopleAround.status,
      pImage: peopleAround.image,
    );
    //Navigator.pop(context);
    Get.to(ChatScreen(groupDetails: newGroupDetails, userData: user))
        ?.then(onChildNavigatorPop);
    print("Wait completed 5");
    clickYes = false;
  }

  Future<void> saveGroupDetails(
      NearbyPerson peopleAround, String gId, String groupName) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '894a6680-6e69-11ee-8e06-bd1e227af3b0',
      // context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "GID": gId,
        "GroupName": groupName,
        "Created_by": prefs.userId,
        "total_members": 2,
      };
      return jsonData;
    }

    var response = await bBlupSheetsApi.runHttpApi(
        queryId: "894a6680-6e69-11ee-8e06-bd1e227af3b0",
        jsonData: getJsonData());
  }

  Future<void> saveGidAndPid(
      NearbyPerson peopleAround, String gId, String groupName) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: 'c5432ac0-6f34-11ee-ad34-d94c3b1e1747',
      // context: context,
    );
    String x;
    for (int i = 0; i < 2; i++) {
      if (i == 0) {
        x = prefs.userId!;
      } else {
        x = peopleAround.userId;
      }
      Map<dynamic, dynamic> getJsonData() {
        Map<dynamic, dynamic> jsonData = {
          "PID": x,
          "GID": gId,
        };
        return jsonData;
      }

      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "c5432ac0-6f34-11ee-ad34-d94c3b1e1747",
          jsonData: getJsonData());
    }
  }

  Future<void> showPopupMenu(
      BuildContext context, Offset position, gid, createId, size) async {
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
          padding: const EdgeInsets.fromLTRB(12, 12, 40, 12),
          onTap: () async {
            if (size == '1') {
              await GroupHelper.instance
                  .deleteGroups(context, gid, onDelete: () {});
              widget.onRefresh?.call();
              Fluttertoast.showToast(
                msg: "Group Deleted Successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              setState(() {
                print("calling set state delete groups");
              });
            } else {
              if (prefs.userId == createId) {
                await GroupHelper.instance
                    .deleteGroups(context, gid, onDelete: () {});
                widget.onRefresh?.call();
                Fluttertoast.showToast(
                  msg: "Group Deleted Successfully",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                setState(() {
                  print("calling set state delete groups");
                });
              } else {
                Fluttertoast.showToast(
                  msg: TOAST_MESSAGE_ONLY_ADMIN_CAN_DELETE_A_GROUP,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            }
          },
          child: const Text(
            "Delete for everyone",
            style: TextStyle(
              color: Color(0xFF475466),
              fontSize: 14,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void onChildNavigatorPop(isReloadData) async {
    // print("onChildNavigatorPop *");
    await GroupHelper.instance.getAllGroupDetails();
    print("G3");
    setState(() {
      isLoadingMute = false;
    });
  }
}
