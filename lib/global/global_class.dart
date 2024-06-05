
class Trips {
  final String destination;
  final String start;
  final String date;
  final String time;

  Trips(this.start, this.destination, this.date, this.time);
}

class FinalDetails {
  String pName;
  String pNumber;
  FinalDetails({required this.pName, required this.pNumber});
}

class GroupDetails {
  String groupName;
  String groupMembers;
  String groupID;
  String createBy;
  // bool singleChat;
  GroupDetails({
    required this.groupName,
    required this.groupMembers,
    required this.groupID,
    required this.createBy,
    // required this.singleChat
  });

  Map<String, String> toJson(){
    return {
      "groupName":groupName,
      "groupMembers":groupMembers,
      "groupID":groupID,
      "createBy":createBy,
    };
  }

}

class GetIndividualData {
  String pName;
  String pId;
  String pNumber;
  String pRem;
  String pStatus;
  String pImage;
  String? latestMessage;
  bool? isNewMessage;
  GetIndividualData({
    required this.pName,
    required this.pId,
    required this.pNumber,
    required this.pRem,
    required this.pStatus,
    required this.pImage,
    this.latestMessage,
    this.isNewMessage=false,
  });
}

