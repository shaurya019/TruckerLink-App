// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:b_dep/b_dep.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:trucker/screens/navigation_screen/bottom.dart";
import 'package:trucker/screens/login_screen/login.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/share_preferences/shared_preferences_service.dart';
import 'package:uuid/uuid.dart';

String userCountryCode= "";
String dropDownValue = 'Indian';
var userPersonId;

class Name extends StatefulWidget {
  final String email;
  final String phone;
   CountryCode countryCode;
   Name({Key? key, required this.email, required this.phone, required this.countryCode}) : super(key: key);
  @override
  State<Name> createState() => _NameState();
}

class _NameState extends State<Name> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isFirstNameValid = true;
  bool isLastNameValid = true;
  bool isEmailValid = true;
  bool isPhoneNumberValid = true;
  bool isButtonEnabled = false;
  bool isLoading = false;
  CountryCode? selectedCountry;

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
    emailController.addListener(updateButtonState);
    lastNameController.addListener(updateButtonState);
    emailController.addListener(updateButtonState);
    phoneController.addListener(updateButtonState);
    selectedCountry = widget.countryCode;
    emailController.text = widget.email;
    phoneController.text = widget.phone;
    userCountryCode= selectedCountry!.name!;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 67),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What\'s your name?',
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 24,
                fontWeight: FontWeight.w500,
                height: 32 / 24,
                letterSpacing: 0,
                color: Color(0xFF475467),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Please let us know the appropriate way to address you.',
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF98A2B3),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'First name',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475467),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFF2F4F7),
                  ),
                  child: TextFormField(
                    controller: firstNameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          !checkForValidName(value)) {
                        return 'Please enter only letters in the first name.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter First Name',
                      hintStyle: TextStyle(
                        fontFamily: 'SF Pro',
                        color: Color(0xFF98A2B3),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Last name',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                    letterSpacing: 0.0,
                    color: Color(0xFF475467),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFF2F4F7),
                  ),
                  child: TextFormField(
                    controller: lastNameController,
                    textCapitalization: TextCapitalization.words,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          !checkForValidName(value)) {
                        return 'Please enter only letters in the second name.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter Last Name',
                      hintStyle: TextStyle(
                        fontFamily: 'SF Pro',
                        color: Color(0xFF98A2B3),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ethnicity',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                    letterSpacing: 0.0,
                    color: Color(0xFF475467),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFF2F4F7),
                    ),
                    child:DropdownButtonFormField(
                      value: dropDownValue,
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(fontSize: 18,color:Colors.black,),
                      decoration: const InputDecoration(
                          border:InputBorder.none
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropDownValue = newValue!;
                        });
                      },
                    ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Email',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                    letterSpacing: 0.0,
                    color: Color(0xFF475467),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFF2F4F7),
                  ),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.words,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          !checkForValidEmail(value)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter Email',
                      hintStyle: TextStyle(
                        fontFamily: 'SF Pro',
                        color: Color(0xFF98A2B3),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            if (!isEmailValid)
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Invalid email format',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter Phone number',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                    letterSpacing: 0.0,
                    color: Color(0xFF475467),
                  ),
                ),
                const SizedBox(height: 6),


                Row(
                  children: [
                    IntrinsicWidth(
                      child: Container(
                        height: 48,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF2F3F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: CountryCodePicker(
                            flagWidth: 30,
                            onChanged: _onCountryChange,
                            onInit: (countryCode) {
                              if (countryCode != null) {
                                selectedCountry = countryCode;
                              }
                            },
                            hideMainText: false,
                            initialSelection: widget.countryCode.code,
                            favorite: const ['US', 'CA'],
                            showOnlyCountryWhenClosed: false,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF2F3F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(
                              fontFamily: 'SF Pro',
                              color: Color(0xFF98A1B2),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            hintText:
                            "Enter your number",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            dialCode = selectedCountry!.dialCode!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isButtonEnabled
                        ? const Color(0xFFFF8D49)
                        : const Color(0xFFF2F4F7),
                  ),
                  child: TextButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                            });

                            addUserDataAndNavigate();


                          },
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Center(
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: isButtonEnabled
                                      ? Colors.white
                                      : const Color(0xFF98A2B3),
                                ),
                              ),
                            ),
                    ), // Empty SizedBox when not loading
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFF2F4F7),
              ),
              child: TextButton(
                onPressed: () async {
                  Get.off(() => Login());
                },
                child: const Center(
                  child: Text(
                    'Back',
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF98A2B3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = firstNameController.text.isNotEmpty &&
          lastNameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          phoneController.text.isNotEmpty;
    });
  }

  void _onCountryChange(CountryCode? countryCode) {
    setState(() {
      selectedCountry = countryCode;
      phoneController.text = '';
      userCountryCode= countryCode!.name!;
    });
  }

  void validateFields() {
    setState(() {
      isFirstNameValid = checkForValidName(firstNameController.text);
      isLastNameValid = checkForValidName(lastNameController.text);
      isEmailValid = checkForValidEmail(emailController.text);
      isPhoneNumberValid = phoneController.text.isNotEmpty;
    });
  }

  bool checkForValidName(String value) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(value) && value.isNotEmpty;
  }

  bool checkForValidEmail(String value) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value);
  }

  void addUserDataAndNavigate() async{
     var userName = '${firstNameController.text} ${lastNameController.text}';
     dialCode = selectedCountry!.dialCode!;
     var startLocation=await GetCurrentLocation().fetch();
     //print("dialCode - $dialCode - ${startLocation.latitude} - ${startLocation.longitude}");
     var userPhoneNumber =  dialCode+phoneController.text;
     String image = 'x';
     userPersonId = const Uuid().v1();
      BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi('client.blup.white.falcon@gmail.com', calledFrom: '000f4fc0-6806-11ee-a3f4-535b68566daf', context: context, );

      Map<dynamic,dynamic> getJsonData() {

        Map<dynamic,dynamic> jsonData = {
          "Name": userName,
          "PhoneNumber":userPhoneNumber,
          "UserId":userPersonId,
          "Email": emailController.text,
          "countryCode": selectedCountry?.code,
          "dialCode": selectedCountry.toString(),
          "ethnicity":dropDownValue,
          "profilePic": image,
          "lat":startLocation.latitude,
          "lng":startLocation.longitude,
          "compass":"0.0"
        };
        return jsonData;
      }

      bBlupSheetsApi.runDefaultBlupSheetApi(queryId: "000f4fc0-6806-11ee-a3f4-535b68566daf", jsonData: getJsonData());

      bBlupSheetsApi.getJsonData = getJsonData;

      bBlupSheetsApi.onSuccess=(result){
        final sharedPreferencesService = SharedPreferencesService.getInstance();
        final name = userName;
        final email = emailController.text;
        final userId = userPersonId;
        final phoneNumber = userPhoneNumber;
        final countryCode= selectedCountry?.code;
        final dialCode = selectedCountry.toString();
        final ethnicity = dropDownValue;
        final imageUrl = image;
        sharedPreferencesService.saveFormData(name,email,userPersonId,phoneNumber,dialCode,countryCode!,ethnicity,imageUrl);
        validateFields();
        if (isButtonEnabled) {
           Future.delayed(const Duration(seconds: 2));
          Get.offAll(() =>  Bottom(selectedIndex: 0,newIndex:0));
        }
        setState(() {
          isLoading = false;
        });
      };
      bBlupSheetsApi.onFailure=(error){
        print("Blup error - $error");
      };
    }
}
