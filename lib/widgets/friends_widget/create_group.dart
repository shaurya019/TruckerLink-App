import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:get/get.dart";
import "package:trucker/global/global_class.dart";
import "package:trucker/global/global_list.dart";
import "package:trucker/screens/navigation_screen/bottom.dart";
import 'package:b_dep/b_dep.dart';
import "package:trucker/screens/profile_screen/profile.dart";
import 'package:uuid/uuid.dart';


class NewGroupName extends StatefulWidget {
  final Set<FinalDetails> selectedFinalPhoneDetails;
  final List Pidlist = [];
  final participants;
  bool isLoadingGroup = false;
  String gid = "";
  final VoidCallback onTap;
  final VoidCallback? onGroupCreated;
  NewGroupName({Key? key, required this.selectedFinalPhoneDetails, required this.onTap,this.onGroupCreated})
      : participants = selectedFinalPhoneDetails.length,
        super(key: key);

  @override
  State<NewGroupName> createState() => NewGroupNameState();
}

class NewGroupNameState extends State<NewGroupName> {
  TextEditingController newGroupController = TextEditingController();
  TextEditingController newController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  void dispose(){
    super.dispose();
    Set<FinalDetails> newList = {selectedFinalPhoneDetails.elementAt(0)};
    selectedFinalPhoneDetails = newList;
  }

  void updateButtonState() {
    if(mounted) {
      if (widget.selectedFinalPhoneDetails.length > 1) {
        setState(() {
          isButtonEnabled = newGroupController.text.isNotEmpty;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: InkWell(
                          onTap: () {
                            Set<FinalDetails> newList = {selectedFinalPhoneDetails.elementAt(0)};
                            selectedFinalPhoneDetails = newList;
                            Get.back();
                          },
                          child: const Icon(Icons.arrow_back,color:Color(0xFF667085))),
                    ),
                    const Text(
                      "Group Name",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  cursorColor: Colors.black,
                  textCapitalization: TextCapitalization.words,
                  controller: newGroupController,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xFF475467),
                  ),
                  decoration:  InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFEAECF0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none, // Adjust the radius as needed
                    ),
                    hintText: 'Enter Your Group Name',
                    hintStyle :const TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF98A2B3),
                    ),
                    // border: InputBorder.none,
                  ),
                  onChanged: (_) {
                    updateButtonState();
                  },
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isButtonEnabled
                        ? const Color(0xFFFF8D49)
                        : const Color(0xFFEAECF0),
                  ),
                  child: TextButton(
                    onPressed: isButtonEnabled ?
                    widget.isLoadingGroup ? null : () async {
                      setState(() {
                        widget.isLoadingGroup = true;
                      });
                      var gid = const Uuid().v1();
                      await createNewGroup(gid,newGroupController.text,widget.selectedFinalPhoneDetails,widget.Pidlist);
                      widget.onTap.call();
                      if(widget.onGroupCreated!=null) {
                        widget.onGroupCreated!();
                      }
                      Get.back();
                      // Get.off(() =>  Bottom(selectedIndex: 1,newIndex: 1,));
                    } : null,
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: Center(
                        child: isButtonEnabled ?
                        widget.isLoadingGroup ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ) :
                        Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: isButtonEnabled
                                ? Colors.white
                                : const Color(0xFF98A2B3),
                          ),
                        )
                            :  Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: isButtonEnabled
                                ? Colors.white
                                : const Color(0xFF98A2B3),
                          ),
                        )
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFEAECF0),
                  ),
                  child:  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: (){
                      Set<FinalDetails> newList = {selectedFinalPhoneDetails.elementAt(0)};
                      selectedFinalPhoneDetails = newList;
                      Get.back();
                    },
                    child: const Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF98A1B2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Participants: ${widget.participants}",
                  style: const TextStyle(
                    color: Color(0xFF475466),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: List.generate(
                    widget.selectedFinalPhoneDetails.length,
                        (index) {
                      var phoneDetails = widget.selectedFinalPhoneDetails.elementAt(index);
                      return ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Container(
                          width: 40.0,
                          height: 40.0,
                          margin: const EdgeInsets.all(
                              6.153846263885498),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2970FF),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child:SvgPicture.asset(
                            'assets/image/person.svg',
                            height: 18.33,
                            width: 15,
                            color: Colors.white,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        title: Text(phoneDetails.pName),
                        subtitle: Text(phoneDetails.pNumber),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createNewGroup(gid,groupName,selectedFinalPhoneDetails, Pidlist) async {
    for (int index = 0; index < selectedFinalPhoneDetails.length; index++) {
      var phoneDetails = selectedFinalPhoneDetails.elementAt(index);
      await getUserId(phoneDetails.pNumber,Pidlist);
      if (selectedFinalPhoneDetails.length == Pidlist.length) {
        //print("1");
        await saveGroupDetails(gid, groupName,selectedFinalPhoneDetails, Pidlist);
      }
    }
  }

  Future<void> getUserId(var pno,Pidlist) async {
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '8a4ea620-878e-11ee-aa0d-490042dbc558',
      // context: context,
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
    if (response[0]["UserId"] != null) {
      var id = response[0]["UserId"];
      Pidlist.add(id);
    }
  }

  Future<void> saveGroupDetails(gid, groupName,selectedFinalPhoneDetails, Pidlist) async {
    // var groupName = newGroupController.text;
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '894a6680-6e69-11ee-8e06-bd1e227af3b0',
      // context: context,
    );
    // var gid = const Uuid().v1();
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "GID": gid,
        "GroupName": groupName,
        "Created_by":prefs.userId,
        "total_members":selectedFinalPhoneDetails.length,
      };
      return jsonData;
    }

    var response = await bBlupSheetsApi.runHttpApi(
        queryId: "894a6680-6e69-11ee-8e06-bd1e227af3b0",
        jsonData: getJsonData());
    await saveGidAndPid(Pidlist, gid);
    print("saveGroupDetails Success");
  }

  Future<void> saveGidAndPid(Pidlist, gid) async {
    // print("saveGidAndPid Coming");
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: 'c5432ac0-6f34-11ee-ad34-d94c3b1e1747',
      // context: context,
    );
    // print("IdLength -> ${widget.Pidlist.length}");
    for (int index = 0; index < Pidlist.length; index++) {
      var indexPid = Pidlist[index];
      print("indexPid -> $indexPid");
      Map<dynamic, dynamic> getJsonData() {
        Map<dynamic, dynamic> jsonData = {
          "PID": indexPid,
          "GID": gid,
        };
        return jsonData;
      }

      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "c5432ac0-6f34-11ee-ad34-d94c3b1e1747",
          jsonData: getJsonData());

      print("saveGidAndPid Success");
    }
    Pidlist.clear();
  }

}
