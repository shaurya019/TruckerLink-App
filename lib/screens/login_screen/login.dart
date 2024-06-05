// ignore_for_file: avoid_print

import 'package:b_dep/b_dep.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trucker/screens/login_screen/verify_number.dart';
import "package:trucker/screens/navigation_screen/bottom.dart";
import 'package:trucker/screens/email_screen/email_login.dart';
import 'package:trucker/screens/login_screen/enter_details.dart';
import 'package:trucker/screens/login_screen/otp_verify.dart';
import 'package:trucker/share_preferences/shared_preferences_service.dart';

var dialCode = '';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // This Function is use to give user an option of sign in google
  Future<String?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult =
        await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        if (user != null) {
          return user.email;
        }
      }
    } catch (error) {
      // Handle errors here
      print(error.toString());
    }
    return null;
  }
}

class Login extends StatefulWidget {
  Login({super.key});
  bool isLoading = false;
  bool isLoadingGoogle = false;
  bool isLoadingEmail = false;
  static String verify = "";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController countryController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  var phoneX = "";
  Color gray300 = Colors.grey.withOpacity(0.3);
  CountryCode? selectedCountry;
  bool isButtonEnabled = false;
  bool isEnabled = true;
  bool googleFlag = false;
  bool emailFlag = false;

  @override
  void initState() {
    super.initState();
    selectedCountry = CountryCode.fromCountryCode("IN");
    phoneNumberController.text = '';
    phoneNumberController.addListener(updateButtonState);
  }

  @override
  void dispose() {
    phoneNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter your mobile number',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475467),
                        ),
                      ),
                      const SizedBox(height: 12),
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
                                      userCountryCode = countryCode.name!;
                                    }
                                  },
                                  hideMainText: false,
                                  initialSelection: 'IN',
                                  favorite: const ['US', 'CA'],
                                  showOnlyCountryWhenClosed: false,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
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
                                controller: phoneNumberController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                    color: Color(0xFF98A1B2),
                                    fontSize: 16,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  hintText: "Enter your number",
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  phoneX = phoneNumberController.text;

                                  setState(() {
                                    isButtonEnabled = phoneX.length >= 8;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
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
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              )),
                          onPressed: isButtonEnabled
                              ? widget.isLoading
                              ? null
                              : () async {
                            setState(() {
                              widget.isLoading = true;
                            });
                            final phoneNumber = phoneX;

                            await verify(phoneNumber, selectedCountry!);
                          }
                              : null,
                          child: Center(
                              child: isButtonEnabled
                                  ? widget.isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                                  : Text(
                                'Continue',
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: isButtonEnabled
                                      ? Colors.white
                                      : const Color(0xFF98A2B3),
                                ),
                              )
                                  : Text(
                                'Continue',
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: isButtonEnabled
                                      ? Colors.white
                                      : const Color(0xFF98A2B3),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD0D5DD), width: 1),
                    color: const Color(0xFFD0D5DD),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 112,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFf2f4f7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              onPressed: isButtonEnabled
                                  ? null
                                  : widget.isLoadingEmail
                                  ? null
                                  : widget.isLoadingGoogle
                                  ? null
                                  : () async {
                                setState(() {
                                  widget.isLoadingGoogle = true;
                                  // isenabled = false;
                                });
                                String? googleEmail =
                                await AuthService()
                                    .signInWithGoogle(context);
                                addUserHasDataAndNavigate(
                                    googleEmail, selectedCountry);
                              },
                              child: Center(
                                child: widget.isLoadingGoogle
                                    ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                        Colors.orange),
                                  ),
                                )
                                    : Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/image/google.svg',
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    const Expanded(
                                      child: Text(
                                        'Continue with Google',
                                        style: TextStyle(
                                          fontFamily: 'SF Pro',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF475467),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F4F7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  )),
                              onPressed: isButtonEnabled
                                  ? null
                                  : widget.isLoadingGoogle
                                  ? null
                                  : widget.isLoadingEmail
                                  ? null
                                  : () async {
                                setState(() {
                                  widget.isLoadingEmail = true;
                                });
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                Get.to(() => LoginPage(
                                    countryCode: selectedCountry,
                                    phone: ''));
                                setState(() {
                                  widget.isLoadingEmail = false;
                                  // isenabled = false;
                                });
                              },
                              child: widget.isLoadingEmail
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.orange),
                                ),
                              )
                                  : Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/image/email.svg',
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    child: Text(
                                      'Continue with Email',
                                      style: TextStyle(
                                        fontFamily: 'SF Pro',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0,
                                        color: Color(0xFF475467),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD0D5DD), width: 1),
                    color: const Color(0xFFD0D5DD),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  //height: 312,
                  child: Column(
                    children: [
                      const Text(
                        'Upon entering your number, TruckerLink will send an SMS or OTP to your mobile number',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF98A2B3),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'We value your privacy by clicking the Continue, you agree to our terms and privacy policy',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF98A2B3),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 160,
                          height: 48,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(43),
                            color: const Color(0xFFEAECF0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SvgPicture.asset(
                                'assets/image/question.svg',
                                width: 20,
                                height: 20,
                                fit: BoxFit.scaleDown,
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                'Need Help?',
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF475467),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onCountryChange(CountryCode? countryCode) {
    setState(() {
      selectedCountry = countryCode;
      phoneNumberController.text = '';
      userCountryCode = countryCode!.name!;
    });
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = phoneNumberController.text.isNotEmpty;
    });
  }

  // This function checks if this email is already registered in the firebase account or not.
  Future<bool> isEmailRegisteredInFirebase(String email) async {
    try {
      final list =
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (list.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error checking email registration:>>>>>>>>> $e");
      return false;
    }
  }

  // This message is use to display the toast message to the user.
  void showToast(String Message) => Fluttertoast.showToast(msg: Message);

  // This function is used to validate the phone number via sending them an OTP to validate their phone number.
  Future<void> verify(String phoneNumber, CountryCode selectedCountry) async {
    String rawPhoneNumber = phoneNumber;
    phoneNumber = selectedCountry.toString() + phoneNumber;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'your-specific-error-code') {
          print('Error due to suspicious activity: ${e.message}');
        } else {
          Fluttertoast.showToast(
              msg: "${e.message}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          print('Verification failed with error: ${e.message}');
        }
        setState(() {
          widget.isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        Login.verify = verificationId;
        Get.to(() => Otp(
          email:'',
            phoneNumber: rawPhoneNumber,
            phoneNumberWithCountryCode: phoneNumber,
            countryCode: selectedCountry,
            pass: false));
        setState(() {
          widget.isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void addUserHasDataAndNavigate(String? googleEmail, selectedCountry) {
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '658510e0-6817-11ee-b113-878869abea3c',
      context: context,
    );
    if (googleEmail == null) {
      setState(() {
        widget.isLoadingGoogle = false;
      });
      return;
    }
    Map getJsonData() {
      Map<dynamic, dynamic> jsonData = {"Email": googleEmail};

      return jsonData;
    }

    setState(() {
      widget.isLoadingGoogle = true;
    });
    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "658510e0-6817-11ee-b113-878869abea3c",
        jsonData: getJsonData());
    bBlupSheetsApi.getJsonData = getJsonData;
    var name = '';
    var email = '';
    var userId = '';
    var phoneNumber = '';
    var dialCode = '';
    var countryCode = selectedCountry;
    var ethnicity = '';
    var imageUrl = '';
    bBlupSheetsApi.onSuccess = (result) async {
      for (var res in result) {
        name = res['Name'];
        // print('Name>>>$Name');
        email = res['Email'];
        // print('email>>>$email');
        userId = res['UserId'];
        // print('userId>>>$userId');
        phoneNumber = res['PhoneNumber'];
        // print('phoneNumber>>>$phoneNumber');
        dialCode = res['dialCode'];
        // print('dialCode>>>$dialCode');
        countryCode = res['userCountryCode'];
        // print("countyrCode>> $userCountryCode");
        ethnicity = res['ethnicity'];
        // print("ethnicity>> $ethnicity");
        imageUrl = res['profilePic'];
        if (res['Email'] == googleEmail) {
          // print("ethnicity - ${res['ethnicity']} imageUrl - ${res['profilePic']}");
          final sharedPreferencesService =
          SharedPreferencesService.getInstance();
          sharedPreferencesService.saveFormData(name, email, userId,
              phoneNumber, dialCode, countryCode, ethnicity, imageUrl);
          setState(() {});
          Get.offAll(Bottom(selectedIndex: 0, newIndex: 0));
        }
      }
      // print("countryCode Pass - $countryCode - ${countryCode.runtimeType}");
      if (email.isEmpty) {
        Get.to(VerifyNumber(
          email: googleEmail,
          phone: '',
          countryCode: countryCode,
        ));
      }
      setState(() {
        widget.isLoadingGoogle = false;
      });
    };
    bBlupSheetsApi.onFailure = (error) {
      if (error is Response) {
        print("error is ${error.body}");
      }
    };
  }
}
