import 'package:b_dep/b_dep.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:http/http.dart' as http;
import 'package:trucker/global/global_class.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:trucker/share_preferences/shared_preferences_service.dart';

class ContactHelper {
  ContactHelper._privateConstructor();

  static final ContactHelper instance = ContactHelper._privateConstructor();

  factory ContactHelper() {
    return instance;
  }

  Future<void> fetchContactDetails() async{
    await _getContactPermission();
  }

  // This function is used to get the contact permission from the user while he open the app.
  Future<void> _getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      print('Permission of Contacts Got it>>${Permission.contacts.isGranted}');
    } else {
      print('Permission of Contacts in Request');
      await Permission.contacts.request();
    }
    await _containNumber();
  }

  // This function is use to add all the number in a list that was were in the trucker app and in the user contact list both means they are mutual.
  Future<void> _containNumber() async {
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: 'c21831c0-78c5-11ee-be85-19552980afde',
    );
    Map getJsonData() {
      Map<dynamic, dynamic> jsonData = {};
      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "c21831c0-78c5-11ee-be85-19552980afde",
        jsonData: getJsonData());
    bBlupSheetsApi.getJsonData = getJsonData;
    bBlupSheetsApi.onSuccess = (result) async {
      String? userNumber = prefs.phoneNumber;
      for (var res in result) {

        if (userNumber!=null&&userNumber != res["PhoneNumber"]) {
          phoneStore.add(res["PhoneNumber"]);
        }
      }
      await _fetchContacts();
    };
    bBlupSheetsApi.onFailure = (error) {
      if (error is http.Response) {
        print("error is ${error.body}");
      }
    };
  }

  // It is use to fetch all the conatct from the user contact book.
  Future<void> _fetchContacts() async {
    try {
      contacts = await ContactsService.getContacts();
    } catch (error) {
      print("Error fetching contacts: $error");
    }
    // print("Contacts");
    for (Contact contact in contacts) {
      bool flag = false;
      for (Item data in contact.phones ?? []) {
        String userNumber =
        (data.value ?? "").replaceAll(RegExp(r'[^\d\+]+|-'), '');
        if (!checkNumber.contains(userNumber) &&
            userNumber.length >= 7 &&
            userNumber != prefs.phoneNumber) {
          String lastSevenChars = userNumber.substring(userNumber.length - 7);
          for (String databaseNum in phoneStore) {
            if (databaseNum.contains(lastSevenChars)) {
              FinalDetails fDetails = FinalDetails(
                pName: contact.givenName ?? "No Name",
                pNumber: databaseNum,
              );
              if(!finalDetailsList.any((element) => element.pNumber==fDetails.pNumber)) {
                finalDetailsList.add(fDetails);
              }
            }
          }
        }
        checkNumber.add(userNumber);
      }
    }
  }
}
