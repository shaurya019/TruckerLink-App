// ignore_for_file: avoid_print, unused_catch_stack, unused_element

import 'dart:async';
import 'package:b_dep/b_dep.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:trucker/screens/email_screen/email_login.dart';
import "package:trucker/screens/navigation_screen/bottom.dart";
import 'package:trucker/screens/login_screen/login.dart';
import 'package:trucker/screens/login_screen/enter_details.dart';
import 'package:trucker/share_preferences/shared_preferences_service.dart';

class Otp extends StatefulWidget {
  final String phoneNumberWithCountryCode;
  CountryCode countryCode;
  final String phoneNumber;
  final String email;
  bool pass = false;
  static String verify = "";
  Otp(
      {required this.phoneNumber,
        required this.email,
        Key? key,
        required this.phoneNumberWithCountryCode,
        required this.countryCode,
        required this.pass})
      : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  TextEditingController pinController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var code = "";
  late int _timeLeft = 30;
  late Timer _timer;
  bool isVerifying = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    _listenOtp();
  }

  // This function is use to auto fill the OTP send by the Firebase server.
  void _listenOtp() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();

    _timer.cancel();
    super.dispose();
  }

  // This method is count the timer so that after this timer user can resend the OTP.
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_timeLeft <= 0) {
          timer.cancel();
          setState(() {
            _timeLeft = 0;
          });
        } else {
          setState(() {
            _timeLeft--;
          });
        }
      },
    );
  }

  // This function is validating the OTP entered by the user weather the otp is correct or not.
  void _helpOtp() async {
    try {
      setState(() {
        isVerifying = true;
      });

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: Otp.verify,
        smsCode: code,
      );

      await auth.signInWithCredential(credential);

      setState(() {
        isVerifying = false;
      });

      // Navigate to the next screen after successful verification
      // Replace this with your desired navigation logic
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => Name(email: '', phone: widget.phoneNumber),
      //   ),
      // );
    } catch (ex, st) {
      setState(() {
        isVerifying = false;
      });
    }
  }

  // This function is validating the OTP entered by the user weather the otp is correct or not.
  void verify(String phoneNumber) async {
    String? verId;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException error) {
        print('Verification failed: ${error.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        verId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      forceResendingToken: 3,
    );
    Otp.verify = verId!;
  }

  // This function is used to resend the OTP.
  void resendOtp() async {
    try {
      if (Otp.verify.isNotEmpty) {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: widget.phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException error) {},
          codeSent: (String newVerificationId, int? resendToken) {
            Otp.verify = newVerificationId;
          },
          codeAutoRetrievalTimeout: (String newVerificationId) {},
          forceResendingToken: 3,
        );
      }
    } catch (e) {
      print('Error resending OTP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter the 6-digit-code sent to you at ${widget.phoneNumberWithCountryCode}',
                  style: const TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475467),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                IntrinsicWidth(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xFFEAECF0),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Color(0xFF475467),
                        ),
                        const SizedBox(width: 8.0),
                        InkWell(
                          onTap: _timeLeft == 0
                              ? () {
                            verify(widget.phoneNumberWithCountryCode);
                          }
                              : null,
                          child: Text(
                            _timeLeft == 0
                                ? "Resend code"
                                : "Resend Code (0.${_timeLeft.toString().padLeft(2, '0')})",
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: _timeLeft == 0
                                  ? const Color(0xFF475467)
                                  : const Color(0xFF98A2B3),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                Pinput(
                  length: 6,
                  showCursor: true,
                  onCompleted: (pin) => print('Pin>>>>>$pin'),
                  onChanged: (value) {
                    code = value;
                  },
                  controller: pinController,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFFF8D49),
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                      setState(() {
                        isLoading = true;
                      });
                      Future.delayed(const Duration(seconds: 2));
                      await addUserOtpAndNavigate();
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
                          : const Text(
                        'Continue',
                        style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
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
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      Get.offAll(Login());
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
        ),
      ),
    );
  }

  // This message is use to display the toast message to the user.
  void showToast(String Message) => Fluttertoast.showToast(msg: Message);

  // This Function is use to the verify the OTP enters by the user with the firebase.
  Future<void> addUserOtpAndNavigate() async {
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: 'bcd66cd0-6822-11ee-b113-878869abea3c ',
      context: context,
    );
    Map getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "PhoneNumber": widget.phoneNumberWithCountryCode,
      };

      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "bcd66cd0-6822-11ee-b113-878869abea3c",
        jsonData: getJsonData());
    bBlupSheetsApi.getJsonData = getJsonData;
    var name = '';
    var email = '';
    var userId = '';
    var phoneNumber = '';
    var dialCode = '';
    var countryCode = '';
    var ethnicity = '';
    var imageUrl = '';
    bBlupSheetsApi.onSuccess = (result) async {
      List<dynamic> myList = result;
      if (myList.isEmpty) {
        if (widget.pass == false) {
          print("Details from otp ->  ${widget.phoneNumber}  ${widget.countryCode}");
          Get.off(LoginPage(countryCode: widget.countryCode, phone: widget.phoneNumber));
        } else {
          print("Details otp -> ${widget.email}  ${widget.phoneNumber}  ${widget.countryCode}");
          Get.off(() => Name(
            email: widget.email,
            phone: widget.phoneNumber,
            countryCode: widget.countryCode,
          ));
        }
      }
      for (var res in result) {
        try {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: Login.verify,
            smsCode: code,
          );
          await auth.signInWithCredential(credential);
          if (res['PhoneNumber'] == widget.phoneNumberWithCountryCode) {
            final sharedPreferencesService =
            SharedPreferencesService.getInstance();
            name = res['Name'];
            email = res['Email'];
            userId = res['UserId'];
            phoneNumber = res['PhoneNumber'];
            countryCode = res['userCountryCode'];
            dialCode = res['dialCode'];
            ethnicity = res['ethnicity'];
            imageUrl = res['profilePic'];
            sharedPreferencesService.saveFormData(name, email, userId,
                phoneNumber, dialCode, countryCode, ethnicity, imageUrl);
            setState(() {});
            Get.offAll(Bottom(selectedIndex: 0, newIndex: 0));
          }
          setState(() {
            isLoading = false;
          });
        } catch (ex, st) {
          setState(() {
            isLoading = false;
          });
          if (ex is FirebaseAuthException &&
              ex.code == 'invalid-verification-code') {
            Fluttertoast.showToast(
                msg: "Wrong OTP",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            print('Error>>> $ex $st');
          }
        }
      }
    };
    bBlupSheetsApi.onFailure = (error) {
      setState(() {
        isLoading = false;
      });
      if (error is Response) {
        print("error is ${error.body}");
      }
    };
  }
}
