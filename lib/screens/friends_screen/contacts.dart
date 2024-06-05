// ignore_for_file: avoid_types_as_parameter_names, prefer_for_elements_to_map_fromiterable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trucker/global/global_class.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/global/global_variables.dart';
import 'package:trucker/requests/contacts_fetch.dart';
import 'package:trucker/requests/groups_fetch.dart';
import 'package:trucker/screens/chat_screen/chat.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:trucker/widgets/custom_widget/custom_checkbox.dart';
import 'package:trucker/widgets/friends_widget/create_group.dart';
import 'package:uuid/uuid.dart';

var filterValue = <FinalDetails>{};
bool isActive = false;

class Contacts extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback? onGroupCreated;
  const Contacts({super.key, required this.onTap, this.onGroupCreated});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  TextEditingController editingController = TextEditingController();
  var filterQuery = '';
  bool isShowLoaderInButton=false;
  bool isLoadingContacts=false;

  @override
  void initState() {
    filterValue = finalDetailsList;
    super.initState();
    itemCheckboxStates = Map<int, bool>.fromIterable(
      List.generate(finalDetailsList.length, (index) => index),
      key: (index) => index,
      value: (index) => false,
    );
    addContact();
    if(finalDetailsList.isEmpty) {
      isLoadingContacts=true;
      ContactHelper.instance.fetchContactDetails().then((value){
        setState(() {
          isLoadingContacts=false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("finalDetailsList - ${finalDetailsList.length} | $isLoadingContacts");
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body:  isLoadingContacts
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFFFF8D49)),
      )
          :
      finalDetailsList.isNotEmpty
          ? showContacts()
          : noContacts(),
    );
  }

  Widget showContacts () {
    return SafeArea(
      child: Padding(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                heading(),
                const SizedBox(height: 24),
                Expanded(child: listOfContacts()),
              ],
            ),
            butNewGroup(),
          ])),
    );
  }

  Widget heading () {
    return Container(
      width: double.infinity,
      height: 56,
      padding:
      const EdgeInsets.symmetric(horizontal: 16),
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
              Navigator.pop(context, true);
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
              textCapitalization:
              TextCapitalization.words,
              controller: editingController,
              onChanged: (value) {
                filterSearchResults(value);
              },
              decoration: const InputDecoration(
                hintText: 'Add Participants',
                hintStyle:
                TextStyle(color: Color(0xFF475467)),
                border: InputBorder.none,
              ),
            ),
          ),
          Visibility(
            visible: editingController.text.isEmpty,
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
            visible: editingController.text.isNotEmpty,
            child: InkWell(
              onTap: () {
                setState(() {
                  filterQuery = '';
                  editingController.clear();
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
    );
  }

  Widget listOfContacts() {
    return ListView.builder(
      itemCount: filterValue.length,
      padding: const EdgeInsets.only(top: 0,bottom: 100),
      itemBuilder: (context, index) {
        if (filterValue.elementAt(index).pNumber != prefs.phoneNumber) {
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: (){
              itemCheckboxStates[index] = !(itemCheckboxStates[index]??false);
              setState(() {
                if (itemCheckboxStates[index]!) {
                  //Now Remove
                  selectedFinalPhoneDetails
                      .add(filterValue.elementAt(index));
                } else {
                  // Now Remove
                  selectedFinalPhoneDetails
                      .remove(filterValue.elementAt(index));
                }
                // print("Values ^_^ ${itemCheckboxStates[index]} ${index} ${filterValue.elementAt(index)}");
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12.0,top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomCheckbox(
                    isChecked: itemCheckboxStates[index] ?? false,
                    onChange: (value) {
                      setState(() {
                        itemCheckboxStates[index] = value;
                        if (value) {
                          //Now Remove
                          selectedFinalPhoneDetails
                              .add(filterValue.elementAt(index));
                        } else {
                          // Now Remove
                          selectedFinalPhoneDetails
                              .remove(filterValue.elementAt(index));
                        }
                      });
                    },
                    backgroundColor: const Color(0xFFFF8D49),
                    iconColor: Colors.white,
                    icon: Icons.check,
                    size: 40,
                    iconSize: 40,
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Container(
                    width: 40.0,
                    height: 40.0,
                    margin: const EdgeInsets.all(6.153846263885498),
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
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filterValue.elementAt(index).pName,
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
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          filterValue.elementAt(index).pNumber,
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
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget noContacts() {
    return SafeArea(
      child: Padding(
        padding:
        const EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Column(
          children: [
            Container(
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
                      textCapitalization: TextCapitalization.words,
                      controller: editingController,
                      decoration: const InputDecoration(
                        hintText: 'Friends',
                        hintStyle:
                        TextStyle(color: Color(0xFF475467)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/image/search.svg',
                        width: 18,
                        height: 18,
                        fit: BoxFit.scaleDown,
                      ),
                    ],
                  )
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Unable to find any contacts',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475467),
                      ),
                    ),
                    Text(
                      'on your phone.',
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
                    Share.share('Have you explored the Trucker Link app?');
                  },
                  child: Container(
                    height: 40,
                    width: 135,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                const SizedBox(
                  height: 18,
                ),
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
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget butNewGroup () {
    final bool isParticipantNotSelected=(selectedFinalPhoneDetails.length<=1);
    final bool isSingleParticipantSelected=(selectedFinalPhoneDetails.length==2);
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.02,
      right: MediaQuery.of(context).size.width * 0.002,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () async{
          if(isParticipantNotSelected == false){
            if(isSingleParticipantSelected){
              ///This [if] takes care of creation of new or open
              ///old ones for single chat rooms.

              var singleChatRooms=filterGroups(selectedFinalPhoneDetails.last.pName);
              bool isChatRoomAlreadyExisting=singleChatRooms.isNotEmpty;

              if(!isChatRoomAlreadyExisting) {
                ///If the chat room already does not exists with the user,
                ///create a new chat room.

                setState(() {
                  isShowLoaderInButton = true;
                });
                var gid = const Uuid().v1();
                NewGroupNameState().createNewGroup(
                    gid, selectedFinalPhoneDetails.last.pName,
                    selectedFinalPhoneDetails, []).then((value) async {
                  await GroupHelper().getAllPName(
                      gid, true
                  );
                  //print("va>>> | $gid | ${dataMap[gid]}");
                  Get.off(ChatScreen(
                      groupDetails: GroupDetails(
                        groupID: gid,
                        createBy: prefs.userId!,
                        groupName: selectedFinalPhoneDetails.last.pName,
                        groupMembers: selectedFinalPhoneDetails.length.toString(),
                      ),
                      userData: dataMap[gid]
                  ));
                  Set<FinalDetails> newList = {
                    selectedFinalPhoneDetails.elementAt(0)
                  };
                  selectedFinalPhoneDetails = newList;
                });
              }else{
                ///If the chat room already exists with the user,
                ///then in place of creating a new chat room.
                ///
                ///Use the previous already created one and redirect to that page.
                Get.off(ChatScreen(
                    groupDetails: singleChatRooms.first,
                    userData: dataMap[singleChatRooms.first.groupID]
                ));
              }
            }else {
              ///Groups don't need to check if it already exists with same members.
              ///As there could be more than one groups with same name and same members.

              ///This open a page to give name to the new group and create it.
              Get.off(
                NewGroupName(
                    onTap: widget.onTap,
                    onGroupCreated: widget.onGroupCreated,
                    selectedFinalPhoneDetails:
                    selectedFinalPhoneDetails),
              );
            }
          }
        },
        child: Container(
          // width: 126,
          // height: 54,
          padding: const EdgeInsets.only(left: 15,right: 15, top: 10,bottom: 10),
          decoration: BoxDecoration(
            color: isParticipantNotSelected?const Color(0xFFFEFEFE):const Color(0xFFFF8D49),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0x0000004D).withOpacity(isParticipantNotSelected?0:0.15),
                offset: const Offset(0.0, 1.0),
                blurRadius: 3.0,
                spreadRadius: 0.0,
              ),
              BoxShadow(
                color: const Color(0x00000026).withOpacity(isParticipantNotSelected?0:0.1),
                offset: const Offset(0.0, 4.0),
                blurRadius: 8.0,
                spreadRadius: 3.0,
              ),
            ],
          ),
          child: Center(
              child: isShowLoaderInButton ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ) :Text(
                isParticipantNotSelected?"Select a friend\nfrom the above list.":
                (selectedFinalPhoneDetails.isNotEmpty&&selectedFinalPhoneDetails.length==2)?'Start Chat':
                'New Group',
                style: TextStyle(
                    color: isParticipantNotSelected?Color(0xFF667085).withOpacity(0.6):Colors.white,
                    fontSize: 18,//0xFF667085
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SF Pro'),
              )),
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    setState(() {
      filterQuery = query;
      filterValue = finalDetailsList
          .where((finalDetails) => finalDetails.pName
          .toLowerCase()
          .contains(filterQuery.toLowerCase()))
          .toSet();
    });
  }

  void addContact() {
    FinalDetails fDetails = FinalDetails(
      pName: '${prefs.name}',
      pNumber: '${prefs.phoneNumber}',
    );
    if (isActive == false) {
      isActive = true;
      selectedFinalPhoneDetails.add(fDetails);
      setState(() {});
    }
  }
}
