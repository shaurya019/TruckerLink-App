// ignore_for_file: non_constant_identifier_names, avoid_print, unused_local_variable

import 'dart:typed_data';
import 'package:b_dep/b_dep.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trucker/global/global_class.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/global/global_variables.dart';
import 'package:trucker/screens/login_screen/enter_details.dart';
import 'dart:io';
import "package:trucker/screens/navigation_screen/bottom.dart";
import 'package:trucker/screens/login_screen/login.dart';
import 'package:trucker/screens/welcome_screen/welcome.dart';
import 'package:trucker/share_preferences/shared_preferences_service.dart';
import 'package:trucker/widgets/profile_widget/contact_us.dart';
import 'package:trucker/widgets/profile_widget/settings.dart';

var prefs = SharedPreferencesService.getInstance();

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';
  String imageTemp = "x";
  String userId = '';
  String email = '';
  String phoneNumber = '';
  String countryCode = '';
  String ethnicity = dropDownValue;
  String dial = '';
  File? _selectedImage;
  CountryCode? selectedCountry;
  final List<String> _paths = [];
  TextEditingController firstNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController phoneDialNumberController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  FocusNode phoneNumberFocus = FocusNode();
  final user = FirebaseAuth.instance.currentUser!;

  // this is the list of the entinicty of the user that can be using our app.
  var items = [
    'Aboriginal (Australia)',
    'African American/Black',
    'Apache',
    'Arab',
    'Arab/West Asian',
    'Ashanti',
    'Asian American',
    'Bangladeshi',
    'Berber',
    'Brazilian',
    'Caribbean',
    'Cherokee',
    'Colombian',
    'Dutch',
    'English',
    'Ethiopian',
    'Filipino',
    'Finnish',
    'French',
    'German',
    'Greek',
    'Han Chinese',
    'Hausa',
    'Hispanic',
    'Hispanic/Latino',
    'Igbo',
    'Indian',
    'Indigenous Peoples',
    'Indonesian',
    'Inuit (Arctic regions)',
    'Irish',
    'Italian',
    'Japanese',
    'Jewish',
    'Kazakh',
    'Korean',
    'Kurdish',
    'Latin American',
    'Latino/Latina',
    'Maori (New Zealand)',
    'Malaysian',
    'Melanesian',
    'Mexican',
    'Micronesian',
    'Mongolian',
    'Moroccan',
    'Native American',
    'Navajo',
    'Nepalese',
    'Norwegian',
    'Pacific Islander',
    'Pakistani',
    'Persian (Iranian)',
    'Polish',
    'Polynesian',
    'Portuguese',
    'Punjabi',
    'Romanian',
    'Russian',
    'Scottish',
    'Serbian',
    'Sioux',
    'Somali',
    'Spanish',
    'Swedish',
    'Thai',
    'Tibetan',
    'Turkish',
    'Ukrainian',
    'Vietnamese',
    'Welsh',
    'White (non-Hispanic)',
    'Yoruba',
    'Zulu',
  ];

  @override
  void initState() {
    super.initState();
    loadData();
    getTripsData();
    print(prefs.name);
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    firstNameController.dispose();
    // phoneNumberFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("Data for Number -> $countryCode $selectedCountry $phoneNumber");
    print("Profile");
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF344054),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        Bottom(selectedIndex: 0, newIndex: 0)));
              },
            ),
            const SizedBox(width: 12),
            const Text(
              'Account Info',
              style: TextStyle(
                fontFamily: 'SF Pro',
                color: Color(0xFF344054),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFD0D5DD),
                Color(0xFFEAECF0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 82,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        picUrl != imageTemp
                            ? CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(picUrl),
                        )
                            : prefs.imageUrl != imageTemp
                            ?

                            CircleAvatar(
                          radius: 30,
                          backgroundImage:
                          NetworkImage(prefs.imageUrl!),
                        )
                            :
                        Container(
                          height: 48,
                          width: 48,
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
                        const SizedBox(width: 15),
                        SizedBox(
                          height: 50,
                          // width: 255,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                                child: Text(
                                  'Name',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF667085),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                width: MediaQuery.of(context).size.width - 180,
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF344054),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4F7),
                        borderRadius: BorderRadius.circular(55),
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(55.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setStateDialog) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    insetPadding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: SingleChildScrollView(
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                      child: IntrinsicHeight(
                                        child: Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(25.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                padding:
                                                const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Edit Profile",
                                                      style: TextStyle(
                                                        color:
                                                        Color(0xFF475466),
                                                        fontSize: 24,
                                                        fontFamily: 'SF Pro',
                                                        fontWeight:
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    const Text(
                                                      "Profile photo",
                                                      style: TextStyle(
                                                        color:
                                                        Color(0xFF98A1B2),
                                                        fontSize: 14,
                                                        fontFamily: 'SF Pro',
                                                        fontWeight:
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      children: [
                                                        _selectedImage != null
                                                            ? CircleAvatar(
                                                          radius: 30,
                                                          backgroundImage:
                                                          FileImage(
                                                              _selectedImage!),
                                                        )
                                                            : prefs.imageUrl ==
                                                            'x'
                                                            ? const CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor:
                                                          Color(
                                                              0xFF2970FF),
                                                          child: Icon(
                                                            Icons
                                                                .person,
                                                            size: 30,
                                                            color: Colors
                                                                .white,
                                                          ),
                                                        )
                                                            : CircleAvatar(
                                                          radius: 30,
                                                          backgroundImage:
                                                          NetworkImage(
                                                              prefs.imageUrl!),
                                                        ),
                                                        const SizedBox(
                                                            width: 14),
                                                        Container(
                                                          padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              10, 2, 10, 2),
                                                          decoration:
                                                          ShapeDecoration(
                                                            color: const Color(
                                                                0xFFF2F3F6),
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  12),
                                                            ),
                                                          ),
                                                          child: TextButton(
                                                            onPressed:
                                                                () async {
                                                              final XFile?
                                                              pickedImage =
                                                              await ImagePicker().pickImage(
                                                                  source: ImageSource
                                                                      .gallery,
                                                                  imageQuality:
                                                                  100);
                                                              if (pickedImage !=
                                                                  null) {
                                                                _paths.add(
                                                                    pickedImage
                                                                        .path);
                                                                setStateDialog(
                                                                        () {
                                                                      _selectedImage =
                                                                          File(pickedImage
                                                                              .path);
                                                                    });
                                                              }
                                                            },
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                MaterialStateProperty.all<
                                                                    Color>(
                                                                    Colors
                                                                        .transparent),
                                                                overlayColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                    .transparent)),
                                                            child: const Text(
                                                              "Add Profile photo",
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF475466),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                'SF Pro',
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    // user name field
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        const Text(
                                                          "Name",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF667084),
                                                            fontSize: 14,
                                                            fontFamily:
                                                            'SF Pro',
                                                            fontWeight:
                                                            FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 6),
                                                        Container(
                                                          width:
                                                          double.infinity,
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 16),
                                                          decoration:
                                                          ShapeDecoration(
                                                            color: const Color(
                                                                0xFFF2F3F6),
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  8),
                                                            ),
                                                          ),
                                                          child: TextField(
                                                            controller:
                                                            firstNameController,
                                                            decoration:
                                                            const InputDecoration(
                                                              hintStyle:
                                                              TextStyle(
                                                                color: Color(
                                                                    0xFF98A1B2),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                'SF Pro',
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                              ),
                                                              hintText:
                                                              "Enter your Name",
                                                              border:
                                                              InputBorder
                                                                  .none,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    // user name field
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        const Text(
                                                          "Phone Number",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF667084),
                                                            fontSize: 14,
                                                            fontFamily:
                                                            'SF Pro',
                                                            fontWeight:
                                                            FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 6),
                                                        Row(
                                                          children: [
                                                            IntrinsicWidth(
                                                              child:
                                                              IgnorePointer(
                                                                ignoring:
                                                                true,
                                                                child: Container(
                                                                  height: 48,
                                                                  decoration:
                                                                  ShapeDecoration(
                                                                    color: const Color(
                                                                        0xFFDCDCDC),
                                                                    shape:
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          10),
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child:
                                                                    CountryCodePicker(
                                                                      flagWidth:
                                                                      20,
                                                                      onChanged:
                                                                      _onCountryChange,
                                                                      onInit:
                                                                          (countryCode) {
                                                                        if (countryCode !=
                                                                            null) {
                                                                          selectedCountry =
                                                                              countryCode;
                                                                        }
                                                                      },
                                                                      hideMainText:
                                                                      false,
                                                                      initialSelection:
                                                                      selectedCountry
                                                                          ?.code,
                                                                      favorite: const [
                                                                        'US',
                                                                        'CA'
                                                                      ],
                                                                      showOnlyCountryWhenClosed:
                                                                      false,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            Expanded(
                                                              child:
                                                              IgnorePointer(
                                                                ignoring:
                                                                true,
                                                                child: Container(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                      16),
                                                                  decoration:
                                                                  ShapeDecoration(
                                                                    color: const Color(
                                                                        0xFFDCDCDC),
                                                                    shape:
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          8),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                  TextField(
                                                                    controller:
                                                                    phoneDialNumberController,
                                                                    keyboardType:
                                                                    TextInputType
                                                                        .phone,
                                                                    decoration:
                                                                    const InputDecoration(
                                                                      hintStyle:
                                                                      TextStyle(
                                                                        color: Color(
                                                                            0xFF98A1B2),
                                                                        fontSize:
                                                                        16,
                                                                        fontFamily:
                                                                        'SF Pro',
                                                                        fontWeight:
                                                                        FontWeight.w500,
                                                                      ),
                                                                      hintText:
                                                                      "Enter your number",
                                                                      border: InputBorder
                                                                          .none,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        const Text(
                                                          "Ethnicity",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF667084),
                                                            fontSize: 14,
                                                            fontFamily:
                                                            'SF Pro',
                                                            fontWeight:
                                                            FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 6),
                                                        Container(
                                                          width:
                                                          double.infinity,
                                                          height: 50,
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 16),
                                                          decoration:
                                                          ShapeDecoration(
                                                            color: const Color(
                                                                0xFFF2F3F6),
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  8),
                                                            ),
                                                          ),
                                                          child:
                                                          DropdownButtonFormField(
                                                            value: ethnicity,
                                                            iconSize: 24,
                                                            elevation: 16,
                                                            menuMaxHeight: 400,
                                                            style:
                                                            const TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                              Colors.black,
                                                            ),
                                                            decoration:
                                                            const InputDecoration(
                                                                border:
                                                                InputBorder
                                                                    .none),
                                                            icon: const Icon(Icons
                                                                .keyboard_arrow_down),
                                                            items: items.map(
                                                                    (String items) {
                                                                  return DropdownMenuItem(
                                                                    value: items,
                                                                    child:
                                                                    Text(items),
                                                                  );
                                                                }).toList(),
                                                            onChanged: (String?
                                                            newValue) {
                                                              setState(() {
                                                                ethnicity =
                                                                newValue!;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    // user Email field
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        const Text(
                                                          "Email",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF667084),
                                                            fontSize: 14,
                                                            fontFamily:
                                                            'SF Pro',
                                                            fontWeight:
                                                            FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 6),
                                                        Container(
                                                          width:
                                                          double.infinity,
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 16),
                                                          decoration:
                                                          ShapeDecoration(
                                                            color: const Color(
                                                                0xFFF2F3F6),
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  8),
                                                            ),
                                                          ),
                                                          child: TextField(
                                                            controller:
                                                            userEmailController,
                                                            decoration:
                                                            const InputDecoration(
                                                              hintStyle:
                                                              TextStyle(
                                                                color: Color(
                                                                    0xFF98A1B2),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                'SF Pro',
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                              ),
                                                              hintText:
                                                              "Enter your Name",
                                                              border:
                                                              InputBorder
                                                                  .none,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      color: const Color(
                                                          0xFFF2F3F6),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {});
                                                        },
                                                        child: const TextButton(
                                                          onPressed: null,
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                              fontFamily:
                                                              'SF Pro',
                                                              color: Color(
                                                                  0xFF475466),
                                                              fontSize: 18,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      color: const Color(
                                                          0xFFEAECF0),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          String phoneDial =
                                                              selectedCountry.toString() +
                                                                  phoneDialNumberController
                                                                      .text;
                                                          print("phoneDial -> ${selectedCountry.toString()}");
                                                          if (_paths
                                                              .isNotEmpty) {
                                                            uploadImage(
                                                                context,
                                                                [_paths[0]],
                                                                phoneDial);
                                                          }
                                                          Navigator.pop(
                                                              context);
                                                          if (_paths.isEmpty) {
                                                            editProfileWithout(
                                                              firstNameController
                                                                  .text,
                                                              userEmailController
                                                                  .text,
                                                              phoneDial,
                                                              dialCode,
                                                              countryCode,
                                                              ethnicity,
                                                            );
                                                          }
                                                          setState(() {});
                                                          Fluttertoast.showToast(
                                                              msg:
                                                              "Profile Updated!",
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              gravity:
                                                              ToastGravity
                                                                  .BOTTOM,
                                                              timeInSecForIosWeb:
                                                              1,
                                                              textColor:
                                                              Colors.white,
                                                              fontSize: 16.0);
                                                        },
                                                        child: const TextButton(
                                                          onPressed: null,
                                                          child: Text(
                                                            "Done",
                                                            style: TextStyle(
                                                              fontFamily:
                                                              'SF Pro',
                                                              color:
                                                              Colors.blue,
                                                              fontSize: 18,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            // both button
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/image/pencil.svg',
                          height: 19.33,
                          width: 19.33,
                          color: const Color(0xFF475467),
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 240,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Phone Number',
                                  style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF98A2B3),
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  phoneNumber,
                                  style: const TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF344054),
                                  ),
                                )
                              ]),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFD0D5DD),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Email',
                                  style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: Color(
                                        0xFF98A2B3), // Use the specified color
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF344054),
                                  ),
                                )
                              ]),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFD0D5DD),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Ethnicity',
                                  style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF98A2B3),
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  ethnicity,
                                  style: const TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF344054),
                                  ),
                                )
                              ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Share.share('Have you explored the Trucker Link app?');
                  },
                  child: Container(
                      width: double.infinity,
                      height: 45,
                      // margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4F7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                          child: Text(
                            'Invite Friends',
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF344054),
                            ),
                          ))),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 140,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius:
                  BorderRadius.circular(22), // Border-radius: 12px
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const Settings());
                      },
                      borderRadius:BorderRadius.circular(22), // Border-
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Settings',
                              style: TextStyle(
                                fontFamily: 'SF Pro',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF344054),
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/image/forward.svg',
                              width: 18.0, // Fill width
                              height: 18.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFD0D5DD),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: InkWell(
                        onTap: () {
                          Get.to(const ContactUs());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Help',
                              style: TextStyle(
                                fontFamily: 'SF Pro',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF344054),
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/image/forward.svg',
                              width: 18.0, // Fill width
                              height: 18.0,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                            child: IntrinsicHeight(
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 142,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(22.0),
                                          topRight: Radius.circular(22.0),
                                        ),
                                        color: Color(0xFFFFFFFF),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(
                                          12.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Are you sure you want to',
                                                  style: TextStyle(
                                                    fontFamily: 'SF Pro',
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF475467),
                                                  ),
                                                ),
                                                Text(
                                                  'Log out ?',
                                                  style: TextStyle(
                                                    fontFamily: 'SF Pro',
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF475467),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Are you sure about logging out?',
                                                  style: TextStyle(
                                                    fontFamily: 'SF Pro',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF98A2B3),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  'We\' are here to keep your account safe.',
                                                  style: TextStyle(
                                                    fontFamily: 'SF Pro',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(
                                                        0xFF98A2B3), // Replace with your desired color
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            color: const Color(0xFFF2F3F6),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                              child: const TextButton(
                                                onPressed: null,
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    fontFamily: 'SF Pro',
                                                    color: Color(0xFF475466),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            color: const Color(0xFFEAECF0),
                                            child: InkWell(
                                              onTap: () {
                                                signUserOut(context);
                                              },
                                              child: TextButton(
                                                onPressed: () {
                                                  signUserOut(context);
                                                  Get.to(Welcome());
                                                },
                                                style: ButtonStyle(
                                                  overlayColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                                ),
                                                child: const Text(
                                                  "LogOut",
                                                  style: TextStyle(
                                                    fontFamily: 'SF Pro',
                                                    color: Color(0xFFFF5449),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                      width: double.infinity,
                      height: 45,
                      // margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4F7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                          child: Text(
                            'Log Out',
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFF5449),
                            ),
                          ))),
                ),
              ),
              Container(
                width: double.infinity,
                height: 60,
                margin: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'We value your privacy.',
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF98A2B3),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Please see our Terms and Privacy Policy.',
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF98A2B3),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'All rights reserved, truckerlink 2023',
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF98A2B3),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // This function is used to Edit the profile of user they can update their profile from this function.
  Future<void> editProfile(
      String textName,
      String textEmail,
      String dialPhoneOfUser,
      String dialCodeOfUser,
      String countryCodeOfUser,
      String ethnicityOfUser,
      String imageUrlOfUser,
      ) async {
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: 'f08d2830-76ef-1e0b-a5b7-cf7dcd4fee5d',
      context: context,
    );

    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "Name": textName,
        "PhoneNumber": dialPhoneOfUser,
        "Email": textEmail,
        "UserId": prefs.userId!,
        "dialCode":selectedCountry.toString(),
        "userCountryCode":selectedCountry!.code,
        "profilePic": imageUrlOfUser,
        "ethnicity": ethnicityOfUser,
      };
      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "f08d2830-76ef-1e0b-a5b7-cf7dcd4fee5d",
        jsonData: getJsonData());
    bBlupSheetsApi.getJsonData = getJsonData;
    bBlupSheetsApi.onSuccess = (result) async {
      final sharedPreferencesService = SharedPreferencesService.getInstance();
      final name = textName;
      final email = textEmail;
      final userId = prefs.userId!;
      final phoneNumber = dialPhoneOfUser;
      final dialCode = selectedCountry.toString();
      final countryCode = selectedCountry!.code;
      final ethnicity = ethnicityOfUser;
      final imageUrl = imageUrlOfUser;
      print(name);
      await sharedPreferencesService.saveFormData(name, email, userId,
          phoneNumber, dialCode, countryCode!, ethnicity, imageUrl);
      retrieveFormData();
      _paths.clear();
    };
    bBlupSheetsApi.onFailure = (error) {
      showToast("Permission Denied");
      Navigator.pop(context);
    };
  }

  Future<void> editProfileWithout(
      String textName,
      String textEmail,
      String dialPhone,
      String dialCodeOfUser,
      String countryCodeOfUser,
      String ethnicityOfUser,
      ) async {
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '08e74460-68fe-11ee-8666-77886f926d8e',
      context: context,
    );
    print("Change -> $dialPhone ${selectedCountry} - ${selectedCountry!.code}");
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "Name": textName,
        "PhoneNumber": dialPhone,
        "Email": textEmail,
        "UserId": prefs.userId!,
        "dialCode":selectedCountry.toString(),
        "userCountryCode":selectedCountry!.code,
        "ethnicity": ethnicity,
      };
      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "08e74460-68fe-11ee-8666-77886f926d8e",
        jsonData: getJsonData());
    bBlupSheetsApi.getJsonData = getJsonData;
    bBlupSheetsApi.onSuccess = (result) async {
      final sharedPreferencesService = SharedPreferencesService.getInstance();
      final name = textName;
      final email = textEmail;
      final userId = prefs.userId!;
      final phoneNumber = dialPhone;
      final dialCode = selectedCountry.toString();
      final countryCode = selectedCountry!.code;
      final ethnicity = ethnicityOfUser;
      await sharedPreferencesService.saveFormData(name, email, userId,
          phoneNumber, dialCode, countryCode!, ethnicity, prefs.imageUrl ?? ' ');
      retrieveFormData();
      _paths.clear();
    };
    bBlupSheetsApi.onFailure = (error) {
      showToast("Permission Denied");
      Navigator.pop(context);
    };
  }

  void showToast(String message) => Fluttertoast.showToast(msg: message);

  // This function is used to Logout the user from the app.
  void signUserOut(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().disconnect();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Get.offAll(() => Welcome());
  }

  // This Function keep track of all the trip that the driver is doing with the help of app.

  // With the help of this function user can change their country code of the phone number.
  void _onCountryChange(CountryCode? countryCode) {
    setState(() {
      selectedCountry = countryCode;
      phoneNumberController.text = '';
      phoneDialNumberController.text = '';
    });
    FocusScope.of(context).requestFocus(phoneNumberFocus);
  }

  // This function is use to get all the user data from the database once he updates it profile.
  Future<void> retrieveFormData() async {
    name = prefs.name!;
    email = prefs.email!;
    userId = prefs.userId!;
    phoneNumber = prefs.phoneNumber!;
    dialCode = prefs.dialCode!;
    countryCode = prefs.countryCode!;
    ethnicity = prefs.ethnicity!;
    picUrl = prefs.imageUrl ?? imageTemp;
    setState(() {});
  }

  Future<void> loadData() async {
    await retrieveFormData();
    setState(() {
      firstNameController.text = name;
      phoneNumberController.text = phoneNumber;
      phoneDialNumberController.text =
          phoneNumber.replaceAll(prefs.dialCode as Pattern, '');
      userEmailController.text = email;
      selectedCountry = CountryCode.fromCountryCode(countryCode);
    });
  }

  // This function is used to upload the user profile picture in the app.
  void uploadImage(
      BuildContext context, List<String> path, String phoneDial) async {
    List<Uint8List?> bytesList = [];
    getFile_Picker_onFilePicked(context, kIsWeb ? bytesList : path, phoneDial);
  }

  dynamic file_Picker_onFilePicked_List_of_filePath;

  // below all the function are used to to that picked image to the AWS Server.
  void getFile_Picker_onFilePicked(
      BuildContext context, listOfFileBytes, String phoneDial) async {
    file_Picker_onFilePicked_List_of_filePath = listOfFileBytes;
    await runFile_Uploader_to_BSS(context, phoneDial);
  }

  Future<void> runFile_Uploader_to_BSS(
      BuildContext context, String phoneDial) async {
    BStorage bStorage = BStorage();
    bStorage.uploadFile(getFile_Uploader_to_BSS_List_of_filePath());
    bStorage.bssOnSuccess = (downloadUrl) {
      picUrl = downloadUrl;
      editProfile(firstNameController.text, userEmailController.text, phoneDial,
          dialCode, countryCode, ethnicity, downloadUrl);
    };
    bStorage.bssOnFailure = () {
      print("Failed");
    };
  }

  getFile_Uploader_to_BSS_List_of_filePath() {
    return file_Picker_onFilePicked_List_of_filePath;
  }


  Future<void> getTripsData() async {
    print("coming here");
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: 'de36a1a0-df4f-1e0d-a5b7-cf7dcd4fee5d',
      context: context,
    );
    print("coming till");
    Map getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "UserId": prefs.userId,
      };
      return jsonData;
    }

    print("coming soon");
    String startPos;
    String endPos;
    String date;
    String time;

    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "de36a1a0-df4f-1e0d-a5b7-cf7dcd4fee5d",
        jsonData: getJsonData());
    bBlupSheetsApi.getJsonData = getJsonData;
    print("coming *");
    bBlupSheetsApi.onSuccess = (result) async {
      tripsData.clear();
      print("coming ${tripsData.length}");
      for (var res in result) {
        startPos = res["startPosition"];
        endPos = res["endPosition"];
        date = res["Date"];
        time = res["Time"];
        Trips trip1 = Trips(startPos, endPos, date, time);
        tripsData.add(trip1);
      }
      print("coming ${tripsData.length}");
    print("tripsData - $tripsData");

      tripsData.sort((a, b) {
        String dateTimeString1 = '${a.date} ${a.time}';
        DateFormat dateFormat = DateFormat('yyyy:MM:dd HH:mm:ss');
        DateTime dateTime1 = dateFormat.parse(dateTimeString1);

        String dateTimeString2 = '${b.date} ${b.time}';
        DateTime dateTime2 = dateFormat.parse(dateTimeString1);

        return dateTime2.millisecondsSinceEpoch.compareTo(dateTime1.millisecondsSinceEpoch);
      });
    };
    print("tripsData - $tripsData");
    loadingTrips = false;
    setState(() {});
    bBlupSheetsApi.onFailure = (error) {
      print("error in Trips ${error.body}");
    };
  }

}
