import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucker/screens/login_screen/enter_details.dart';
import 'package:trucker/screens/login_screen/login.dart';
import 'package:trucker/screens/login_screen/otp_verify.dart';

class VerifyNumber extends StatefulWidget {
  final String email;
  final String phone;
  CountryCode countryCode;
  VerifyNumber(
      {super.key,
        required this.email,
        required this.phone,
        required this.countryCode});
  bool isLoading = false;
  @override
  State<VerifyNumber> createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {
  TextEditingController countryController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  var phoneX = "";
  Color gray300 = Colors.grey.withOpacity(0.3);
  CountryCode? selectedCountry;
  bool isButtonEnabled = false;
  bool isEnabled = true;

  @override
  void initState() {
    super.initState();
    selectedCountry = CountryCode.fromCountryCode("IN");
    phoneNumberController.text = '';
    phoneNumberController.addListener(updateButtonState);
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = phoneNumberController.text.isNotEmpty;
    });
  }

  void _onCountryChange(CountryCode? countryCode) {
    setState(() {
      selectedCountry = countryCode;
      phoneNumberController.text = '';
      userCountryCode = countryCode!.name!;
    });
  }

  // This function is used to take the user input number and their country code and verify their account.
  Future<void> verify(String phoneNumber, CountryCode selectedCountry) async {
    String rawPhoneNumber = phoneNumber;
    phoneNumber = selectedCountry.toString() + phoneNumber;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        Login.verify = verificationId;
        print("Details verify_number -> ${widget.email}  $phoneNumber  $selectedCountry");
        Get.off(() => Otp(
          email: widget.email,
            phoneNumber: rawPhoneNumber,
            phoneNumberWithCountryCode: phoneNumber,
            countryCode: selectedCountry,
            pass: true));
        setState(() {
          widget.isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
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
                    const SizedBox(
                      height: 12,
                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}
