import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

bool loadingTrips = true;
bool flagEnter = false;
bool isMoreShow = false;
bool isLoading = true;
String countrySelected = "United";
String address = '';
String picUrl = " ";
int checkCount = 0;
List checkedGroupGid = [];
var filterQuery = '';
int groupLength = 0;
bool isLoadingMute = true;
bool flagFriends = false;
double dbr = 0.0;
String ratings = '';
String length = '';
String formattedAddress = '';
String formattedPhoneNumber = '';
String name = '';
LatLng pos = const LatLng(0, 0);
late GooglePlace googlePlace;

const String TOAST_MESSAGE_ONLY_ADMIN_CAN_DELETE_A_GROUP ="Only an admin can delete the group.";
const String TOAST_MESSAGE_GROUP_EXITED_BY_YOU ="The group is exited by you.";