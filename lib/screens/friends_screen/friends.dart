import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trucker/global/global_class.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/global/global_variables.dart';
import 'package:trucker/requests/groups_fetch.dart';
import 'package:trucker/screens/friends_screen/contacts.dart';
import 'package:trucker/widgets/friends_widget/group_list.dart';
import 'package:trucker/widgets/friends_widget/message.dart';


class Friends extends StatefulWidget {
  Friends({super.key, required this.onTap, this.onRefresh});
  final VoidCallback onTap;
   VoidCallback? onRefresh;

  @override
  State<Friends> createState() => FriendsState();
}

class FriendsState extends State<Friends> {
  TextEditingController editingController = TextEditingController();
  Timer? loopTimer;

  @override
  void initState() {
    super.initState();
    print("Friends InitState called");
    call();
  }

  void call() async {
    await loadGroupDetails(flag:false);
    loopTimer=Timer(const Duration(seconds: 15), () {
      if(mounted) {
        call();
      }
    });
  }

  @override
  void didUpdateWidget(Friends oldWidget) {
    super.didUpdateWidget(oldWidget);
  }


  @override
  Widget build(BuildContext context) {
    // print("buildCalledd");
    return Scaffold(
      backgroundColor :const Color(0xFFF2F4F7),
      body: showGroups()
    );
  }

  Widget showGroups () {
    return Stack(
      children: [
        GroupList(
            onRefresh: (){
              print("REFRSH CA,llledd");
              setState(() {
              });
            },
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.03,
          right: MediaQuery.of(context).size.width * 0.05,
          child: Message(
            onTap: (){
              if(selectedFinalPhoneDetails.isNotEmpty) {
                Set<FinalDetails> newList = {
                  selectedFinalPhoneDetails.elementAt(0)
                };
                selectedFinalPhoneDetails = newList;
              }
              widget.onTap();
            },
            onGroupCreated: (){
              if(loopTimer!=null) {
                loopTimer?.cancel();
              }
              call();
            },
          ),
        ),
      ],
    );
  }

  bool isDataLoaded = false;
  Future<void> loadGroupDetails({required bool flag}) async {
    await GroupHelper.instance.getAllGroupDetails();
    // print("G1 | $mounted ");
    if(mounted) {
      setState(() {
        isLoadingMute = false;
      });
    }
  }

}