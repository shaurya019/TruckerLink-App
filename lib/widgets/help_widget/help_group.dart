import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:trucker/global/global_class.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/modals/message_modals.dart';
import 'package:trucker/requests/groups_fetch.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:trucker/widgets/custom_widget/custom_checkbox.dart';
import 'package:trucker/widgets/custom_widget/image_pos.dart';
import 'package:trucker/requests/message_api.dart';

class GroupSelect extends StatefulWidget {
  final String helpMessage;
  GroupSelect({super.key, required this.helpMessage});
  bool isMessageLoading = false;

  @override
  State<GroupSelect> createState() => _GroupSelectState();
}

class _GroupSelectState extends State<GroupSelect> {
  TextEditingController textEditingController = TextEditingController();
  String item1 = 'Delete group';
  int groupLength = 0;
  bool isLoading = true;
  bool isChecked = false;
  var filterQuery = '';
  final List selectedGroupDetails = [];
  List<dynamic> filterGroups(String query) {
    return detailsUser.where((group) {
      final groupName = group.groupName.toString().toLowerCase();
      return groupName.contains(query.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    selectedGroupDetails.clear();
    itemCheckboxStates = {
      for (var index
          in List.generate(finalDetailsList.length, (index) => index))
        index: false
    };
    loadGroupDetails();
  }

  Future<void> loadGroupDetails() async {
    await GroupHelper.instance.getAllGroupDetails();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> sendHelpMessageToGroups() async {
    setState(() {
      widget.isMessageLoading = true;
    });
    for (int i = 0; i < selectedGroupDetails.length; i++) {
      await MessageApi.sendMessage(
        selectedGroupDetails[i],
        widget.helpMessage,
        MessageType.text,
      );
    }
    Fluttertoast.showToast(
        msg: "The message has been delivered.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
    widget.isMessageLoading = false;
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              detailsUser.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
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
                                  Get.back();
                                },
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: SvgPicture.string(
                                      '''<svg width="24" height="24" viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <path d="M19.2422 12H5.24219M5.24219 12L12.2422 19M5.24219 12L12.2422 5" stroke="#667085" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                              </svg>'''),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  cursorColor: Colors.black,
                                  textCapitalization: TextCapitalization.words,
                                  controller: textEditingController,
                                  onChanged: (value) {
                                    setState(() {
                                      filterQuery = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Select Group',
                                    hintStyle: TextStyle(
                                      fontFamily: 'SF Pro',
                                      color: Color(0xFF475467),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: textEditingController.text.isNotEmpty,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      filterQuery = '';
                                      textEditingController.clear();
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
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        detailsUser.isNotEmpty
                            ? Expanded(child: buildShareList())
                            : Center(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/image/message-zero.png',
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit
                                          .cover, // You can adjust the fit as needed
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
                    )
                  : SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(43),
                                color: const Color(0xFFEAECF0),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: SvgPicture.string(
                                          '''<svg width="24" height="24" viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M19.2422 12H5.24219M5.24219 12L12.2422 19M5.24219 12L12.2422 5" stroke="#667085" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                </svg>'''),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextField(
                                      cursorColor: Colors.black,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      controller: textEditingController,
                                      decoration: const InputDecoration(
                                        hintText: 'Select Group',
                                        hintStyle: TextStyle(
                                            fontFamily: 'SF Pro',
                                            color: Color(0xFF475467)),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset('assets/image/search.svg',
                                      height: 18,
                                      width: 18,
                                      color: const Color(0xFF475467)),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Column(
                              children: [
                                Image.asset(
                                  'assets/image/message-zero.png',
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit
                                      .cover, // You can adjust the fit as needed
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
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: selectedGroupDetails.isEmpty
                        ? const Color(0xFFF9FAFB)
                        : const Color(0xFFFF8D49),
                  ),
                  child: TextButton(
                    onPressed: () {
                      selectedGroupDetails.isEmpty
                          ? const SizedBox()
                          : sendHelpMessageToGroups();
                    },
                    child: Center(
                      child: widget.isMessageLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ))
                          : Text(
                              'Send Message',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: selectedGroupDetails.isEmpty
                                    ? const Color(0xFF98A2B3)
                                    : Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildShareList() {
    final filteredGroups = filterGroups(filterQuery);
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
          }
        }
        return groupDetails.groupMembers == '2'
            ? InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  itemCheckboxStates[i] = !(itemCheckboxStates[i] ?? false);
                  setState(() {
                    if (itemCheckboxStates[i]!) {
                      //Now Remove
                      selectedGroupDetails.add(groupDetails);
                    } else {
                      // Now Remove
                      selectedGroupDetails.remove(groupDetails);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 11.0),
                        child: CustomCheckbox(
                          isChecked: itemCheckboxStates[i] ?? false,
                          onChange: (value) {
                            print(
                                "itemCheckboxStates - ${itemCheckboxStates[i]}");
                            setState(() {
                              itemCheckboxStates[i] = value;
                              if (value) {
                                //Now Remove
                                selectedGroupDetails.add(groupDetails);
                              } else {
                                // Now Remove
                                selectedGroupDetails.remove(groupDetails);
                              }
                            });
                          },
                          backgroundColor: const Color(0xFFFF8D49),
                          iconColor: Colors.white,
                          icon: Icons.check,
                          size: 40,
                          iconSize: 40,
                        ),
                      ),
                      const SizedBox(width: 12),
                      (filteredData?.pImage ?? "x") == "x"
                          ? ImagePos(length: 1)
                          : Align(
                              alignment: Alignment.center,
                              child: Container(
                                // width: 35.0,
                                // height: 35.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF98A2B3),
                                  borderRadius: BorderRadius.circular(43),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      NetworkImage(filteredData?.pImage ?? "x"),
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
                            const SizedBox(height: 5),
                            if(filteredData?.pRem!=null)
                            Text(
                              (filteredData?.pStatus ?? "offline").toLowerCase() == "online"
                                  ? (filteredData?.pStatus ?? "offline")
                                  : 'Last seen at ${filteredData?.pRem ?? "NA"}',
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
              )
            : InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  itemCheckboxStates[i] = !(itemCheckboxStates[i] ?? false);
                  setState(() {
                    if (itemCheckboxStates[i]!) {
                      //Now Remove
                      selectedGroupDetails.add(groupDetails);
                    } else {
                      // Now Remove
                      selectedGroupDetails.remove(groupDetails);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 11.0),
                        child: CustomCheckbox(
                          isChecked: itemCheckboxStates[i] ?? false,
                          onChange: (value) {
                            print(
                                "itemCheckboxStates - ${itemCheckboxStates[i]}");
                            setState(() {
                              itemCheckboxStates[i] = value;
                              if (value) {
                                //Now Remove
                                selectedGroupDetails.add(groupDetails);
                              } else {
                                // Now Remove
                                selectedGroupDetails.remove(groupDetails);
                              }
                            });
                          },
                          backgroundColor: const Color(0xFFFF8D49),
                          iconColor: Colors.white,
                          icon: Icons.check,
                          size: 40,
                          iconSize: 40,
                        ),
                      ),
                      const SizedBox(width: 12),
                      ImagePos(
                        length: int.parse(groupDetails.groupMembers),
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
                            const SizedBox(height: 5),
                            Text(
                              '${groupDetails.groupMembers} participants',
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
              );
      },
    );
  }
}
