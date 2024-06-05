class GroupMessage {
  GroupMessage({
    required this.read,
    required this.fromPID,
    required this.sendat,
    required this.type,
    required this.message,
    required this.fromPName,
    required this.toGId,
  });
  late final String read;
  late final String fromPID;
  late final String sendat;
  late final MessageType type;
  late final String message;
  late final String fromPName;
  late final String toGId;

  // This modal is used to convert the Json chat data into simple map chat data.
  GroupMessage.fromJson(Map<String, dynamic> json) {
    read = json['read'].toString();
    fromPID = json['fromP_ID'].toString();
    sendat = json['sendat'].toString();
    type = json['type'].toString() == MessageType.image.name
        ? MessageType.image
        : MessageType.text;
    message = json['message'].toString();
    fromPName = json['fromP_Name'].toString();
    toGId = json['toG_Id'].toString();
  }

  // While Sending a Message this function is used to send a simple map data in the JSON format.
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['read'] = read;
    data['fromP_ID'] = fromPID;
    data['sendat'] = sendat;
    data['type'] = type.name;
    data['message'] = message;
    data['fromP_Name'] = fromPName;
    data['toG_Id'] = toGId;
    return data;
  }
}

// This is use to find weather the message that has to send is image or simple text.
enum MessageType { text, image }
