// ignore_for_file: avoid_print, prefer_for_elements_to_map_fromiterable, must_be_immutable, use_build_context_synchronously, unused_local_variable

import 'package:b_dep/b_dep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trucker/global/global_class.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/global/global_variables.dart';
import 'package:trucker/requests/groups_fetch.dart';
import 'package:trucker/widgets/custom_widget/custom_checkbox.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddParticipant extends StatefulWidget {
  GroupDetails groupDetail;
  final VoidCallback onTap;
  AddParticipant({super.key, required this.groupDetail, required this.onTap});

  @override
  State<AddParticipant> createState() => _AddParticipantState();
}

class _AddParticipantState extends State<AddParticipant> {
  final searchController = TextEditingController();
  List addPidlist = [];
  var filterAddParticipant = <FinalDetails>{};
  var filterQuery = '';
  bool isAdding = false;

  @override
  void initState() {
    filterAddParticipant = nonParticipants;
    selectedFinalPhoneDetailsAdd.clear();
    super.initState();
    // This will create a map of all non members with a false as their name and value as false.
    itemCheckboxStatesAdd = Map<int, bool>.fromIterable(
      List.generate(filterAddParticipant.length, (index) => index),
      key: (index) => index,
      value: (index) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(43),
                        color: const Color(0xFFEAECF0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
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
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              cursorColor: Colors.black,
                              textCapitalization: TextCapitalization.words,
                              controller: searchController,
                              onChanged: (value) {
                                filterSearchResults(value);
                              },
                              decoration: const InputDecoration(
                                hintText: 'Add New Participants',
                                hintStyle: TextStyle(color: Color(0xFF475467)),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: searchController.text.isNotEmpty,
                            child: InkWell(
                              onTap: () {},
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
                    const SizedBox(height: 24),
                    nonParticipants.length == 0
                        ? Column(
                      children: [
                        const SizedBox(height: 24),
                        Image.asset(
                          'assets/image/message-zero.png',
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 18),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'All your contact is',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF475467),
                              ),
                            ),
                            Text(
                              'in the group.',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF475467),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {},
                          child: Container(
                            height: 40,
                            width: 135,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                            ),
                            padding:
                            const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  'assets/image/share.svg',
                                  height: 18,
                                  width: 18,
                                  color: const Color(0xFF475467),
                                ),
                                const Text(
                                  'Share App',
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
                        const SizedBox(height: 18),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Share the app with your friend',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF667085),
                              ),
                            ),
                            Text(
                              'to add them to groups.',
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
                    )
                        : Expanded(child: newMemberList()),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: InkWell(
                  onTap: () async {
                    addPidlist.clear();
                    await addNewParticipant();
                    Fluttertoast.showToast(
                      msg: "New user added successfully!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFF8D49),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isAdding
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          ),
                        )
                            : const Text(
                          'Add Participant',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // This Function is use to filter the name by the search bar.
  void filterSearchResults(String query) {
    setState(() {
      filterQuery = query;
      filterAddParticipant = nonParticipants
          .where((FinalDetails) => FinalDetails.pName
          .toLowerCase()
          .contains(filterQuery.toLowerCase()))
          .toSet();
    });
  }

  // This function is used to display the toast message.
  void showToast(String message) => Fluttertoast.showToast(msg: message);

  // This widget is use to display the list of the members that are present in group at that time.
  Widget newMemberList() {
    return ListView.builder(
      itemCount: filterAddParticipant.length,
      padding: const EdgeInsets.only(top: 0),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomCheckbox(
                isChecked: itemCheckboxStatesAdd[index] ?? false,
                onChange: (value) {
                  setState(() {
                    itemCheckboxStatesAdd[index] = value;
                    if (value) {
                      //Now Remove
                      selectedFinalPhoneDetailsAdd
                          .add(filterAddParticipant.elementAt(index));
                    } else {
                      // Now Remove
                      selectedFinalPhoneDetailsAdd
                          .remove(filterAddParticipant.elementAt(index));
                    }
                  });
                },
                backgroundColor: const Color(0xFFFF8D49),
                iconColor: Colors.white,
                icon: Icons.check,
                size: 40,
                iconSize: 14,
              ),
              const SizedBox(width: 14),
              Container(
                width: 40.0,
                height: 40.0,
                margin: const EdgeInsets.all(6.15),
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
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      filterAddParticipant.elementAt(index).pName,
                      style: const TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        height: 20.0 / 14.0,
                        letterSpacing: 0.0,
                        color: Color(0xFF475467),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      filterAddParticipant.elementAt(index).pNumber,
                      style: const TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        height: 20.0 / 14.0,
                        letterSpacing: 0.0,
                        color: Color(0xFF475467),
                      ),
                      maxLines: 2,
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

  // This function is used to the user unique Id with the help of phone number from trucer login table.
  Future<void> getUserId(var pno, var name) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '8a4ea620-878e-11ee-aa0d-490042dbc558',
      context: context,
    );
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "PhoneNumber": pno,
      };
      return jsonData;
    }

    var response = await bBlupSheetsApi.runHttpApi(
        queryId: "8a4ea620-878e-11ee-aa0d-490042dbc558",
        jsonData: getJsonData());
    print("response data - $response");
    print("response[0] data - ${response[0]}");
      var userId = response[0]["UserId"];
      var status = response[0]["status"];
      var date = response[0]["date"];
      var time = response[0]["time"];
      var profilePic = response[0]["profilePic"];
       addPidlist.add(userId);
      print("date -> $date $time");
      String dateTimeString = '$date $time';
      DateFormat dateFormat = DateFormat('yyyy:MM:dd HH:mm:ss');
      DateTime dateTime = dateFormat.parse(dateTimeString);
      String rem = '';
      Duration difference = DateTime.now().difference(dateTime);
      if (difference.inDays > 365) {
        rem =  DateFormat.yMMMd().format(dateTime); // Show full date if more than a year ago
      } else if (difference.inDays > 1) {
        rem =  DateFormat.yMMMd().format(dateTime);
      } else if (difference.inHours > 1) {
        rem =  '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 1) {
        rem =  '${difference.inMinutes} minutes ago';
      } else {
        rem =  'Just now';
      }

      GetIndividualData newData = GetIndividualData(
        pName: name,
        pId: userId,
        pNumber: pno,
        pRem: rem,
        pStatus:status,
        pImage: profilePic
      );
      individualData.add(newData);
  }

  // This function is use to add the new member to the existing group.
  Future<void> saveGidAndPid() async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: 'c5432ac0-6f34-11ee-ad34-d94c3b1e1747',
      context: context,
    );
    for (int index = 0; index < addPidlist.length; index++) {
      var indexPid = addPidlist[index];
      Map<dynamic, dynamic> getJsonData() {
        Map<dynamic, dynamic> jsonData = {
          "PID": indexPid,
          "GID": widget.groupDetail.groupID,
        };
        return jsonData;
      }

      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "c5432ac0-6f34-11ee-ad34-d94c3b1e1747",
          jsonData: getJsonData());
    }
  }

  // This is main function to add the new member to the existing group if the new members are multiple.
  Future<void> addNewParticipant() async {
    int newMember = selectedFinalPhoneDetailsAdd.length;
    setState(() {
      isAdding = true;
    });
    for (int index = 0; index < selectedFinalPhoneDetailsAdd.length; index++) {
      var phoneDetails = selectedFinalPhoneDetailsAdd.elementAt(index);
      var id = await getUserId(phoneDetails.pNumber, phoneDetails.pName);
      if (selectedFinalPhoneDetailsAdd.length == addPidlist.length) {
        await saveGidAndPid();
        await GroupHelper.updateTotalMember(
            context, newMember, widget.groupDetail.groupID);
      }
    }
    int currentMembers = int.parse(widget.groupDetail.groupMembers);
    int newMembersTotal = currentMembers + selectedFinalPhoneDetailsAdd.length;
    widget.groupDetail.groupMembers = newMembersTotal.toString();
    setState(() {
      isAdding = false;
    });
    widget.onTap.call();
    Get.back();
  }
}
