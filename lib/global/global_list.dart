import 'package:contacts_service/contacts_service.dart';
import 'package:google_place/google_place.dart';
import 'package:trucker/global/global_class.dart';

List<GroupDetails> filterGroups(String query) {
  return detailsUser.where((group) {
    final groupName = group.groupName.toString().toLowerCase();
    return groupName.contains(query.toLowerCase());
  }).toList();
}
List<Contact> contacts = [];
List<String> phoneStore = [];
Set<String> checkNumber = {};
Set<String> finalNumber = {};
Set<FinalDetails> selectedFinalPhoneDetails = {};
Set<FinalDetails> finalDetailsList = {};
Set<FinalDetails> selectedFinalPhoneDetailsAdd = {};
Set<FinalDetails> nonParticipants = {};
Map<int, bool> itemCheckboxStatesAdd = {};
Map<int, bool> itemCheckboxStates = {};
List<GetIndividualData> individualData = [];
Set<GroupDetails> detailsUser = {};
Map<String, GetIndividualData> dataMap = {};
List<Trips> tripsData = [];
List<GroupDetails> filteredGroups = [];
List<Photo> arr = [];