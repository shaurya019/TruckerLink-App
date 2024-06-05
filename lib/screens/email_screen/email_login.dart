// ignore_for_file: must_be_immutable, use_build_context_synchronously, implementation_imports

import 'package:b_dep/b_dep.dart';
import 'package:country_code_picker/src/country_code.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trucker/screens/login_screen/verify_number.dart';
import "package:trucker/screens/navigation_screen/bottom.dart";
import 'package:trucker/screens/email_screen/forget_password.dart';
import 'package:trucker/screens/email_screen/create_account.dart';
import 'package:trucker/screens/email_screen/email_verify.dart';
import 'package:trucker/screens/login_screen/login.dart';
import 'package:trucker/screens/login_screen/enter_details.dart';
import 'package:trucker/share_preferences/shared_preferences_service.dart';

class LoginPage extends StatefulWidget {
  final String phone;
  final CountryCode? countryCode;
  LoginPage({super.key, required this.countryCode, required this.phone});
  bool isPasswordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isButtonEnabled = false;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    widget.emailController.addListener(updateButtonState);
    widget.passwordController.addListener(updateButtonState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: 354,
          padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter your Email",
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  color: Color(0xFF475467),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: widget.emailController,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: "Enter Your Email",
                    hintStyle: TextStyle(
                      fontFamily: 'SF Pro',
                      color: Color(0xFF98A2B3),
                    ),
                    errorStyle: TextStyle(height: 0.3),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: widget.passwordController,
                  obscureText: !widget.isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: InkWell(
                      splashColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: Icon(
                        widget.isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFFFF8D49),
                      ),
                      onTap: () {
                        setState(() {
                          widget.isPasswordVisible = !widget.isPasswordVisible;
                        });
                      },
                    ),
                    hintStyle: const TextStyle(
                      fontFamily: 'SF Pro',
                      color: Color(0xFF98A2B3),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(
                        ForgetPassword(
                          countryCode: widget.countryCode,
                          phone: widget.phone,
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                        color: Color(0xFF98A2B3),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              if (errorMessage != null)
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/image/red.svg',
                      width: 16,
                      height: 16,
                      fit: BoxFit.scaleDown,
                    ),
                    Text(
                      errorMessage!,
                      style: const TextStyle(
                        fontFamily: 'SF Pro',
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 8,
              ),
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
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: isButtonEnabled
                      ? widget.isLoading
                      ? null
                      : () async {
                    setState(() {
                      widget.isLoading = true;
                    });
                    addUserHasEmailData();
                  }
                      : null,
                  child: Center(
                    child: isButtonEnabled
                        ? widget.isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
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
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color(0xFFF2F4F7),
                ),
                child: TextButton(
                  onPressed: () {
                    Get.offAll(() => Login());
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Center(
                    child: Center(
                      child: Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.0,
                          color: Color(0xFF98A2B3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    "New to Truckerlink? ",
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF475467),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await Get.to(() => RegisterNow(phone: widget.phone, countryCode: widget.countryCode,));
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                        color: Color(0xFFFF8D49),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = widget.emailController.text.isNotEmpty &&
          widget.passwordController.text.isNotEmpty;
      errorMessage = null;
    });
  }

  // This function is used to login a user if user data is not updated yet this will make ask the user to fill all it details before using the app.
  void addUserHasEmailData() {
    BBlupSheetsApi bBlupSheetsApi = BBlupSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '658510e0-6817-11ee-b113-878869abea3c',
      context: context,
    );
    Map getJsonData() {
      Map<dynamic, dynamic> jsonData = {"Email": widget.emailController.text};
      return jsonData;
    }

    bBlupSheetsApi.runDefaultBlupSheetApi(
        queryId: "658510e0-6817-11ee-b113-878869abea3c",
        jsonData: getJsonData());
    bBlupSheetsApi.getJsonData = getJsonData;
    var name = '';
    var email = '';
    var userId = '';
    var phoneNumber = '';
    var countryCode = '';
    var dialCode = '';
    var ethnicity = '';
    var imageUrl = '';
    bBlupSheetsApi.onSuccess = (result) async {
      if (widget.emailController.text.isEmpty ||
          widget.passwordController.text.isEmpty) {
        setState(() {
          widget.isLoading = false;
        });
        return;
      }
      List<dynamic> myList = result;
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.emailController.text,
          password: widget.passwordController.text,
        );
        if (FirebaseAuth.instance.currentUser != null &&
            FirebaseAuth.instance.currentUser!.emailVerified) {
          if (myList.isEmpty) {
            if (widget.phone != '') {
              print("Details -> ${widget.emailController.text} -> ${widget.phone} -> ${widget.countryCode}");
              Get.offAll(() => Name(
                email: widget.emailController.text,
                phone: widget.phone,
                countryCode: widget.countryCode ?? CountryCode(),
              ));
            } else {
              print("Details email-login -> ${widget.emailController.text}  ${widget.countryCode}");
              Get.offAll(() => VerifyNumber(
                email: widget.emailController.text,
                phone: '',
                countryCode: widget.countryCode ?? CountryCode(),
              ));
            }
          }
          for (var res in result) {
            name = res['Name'];
            email = res['Email'];
            userId = res['UserId'];
            phoneNumber = res['PhoneNumber'];
            countryCode = res['userCountryCode'];
            dialCode = res['dialCode'];
            ethnicity = res['ethnicity'];
            imageUrl = res['profilePic'];
            if (email == widget.emailController.text) {
              final sharedPreferencesService =
              SharedPreferencesService.getInstance();
              sharedPreferencesService.saveFormData(name, email, userId,
                  phoneNumber, dialCode, countryCode, ethnicity, imageUrl);
              setState(() {});
              Get.offAll(() => Bottom(selectedIndex: 0, newIndex: 0));
            }
          }
        } else {
          FirebaseAuth.instance.currentUser!.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Verification email sent. Check your inbox. ',
              ),
            ),
          );
          Get.to(VerifyEmail(
            phone: widget.phone,
          ));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            errorMessage = 'Account does not exist.';
          });
        }
        if (widget.emailController.text.isEmpty ||
            widget.passwordController.text.isEmpty) {
          errorMessage = "Please fill all details";
        } else {
          setState(() {
            errorMessage = 'Check your email or password';
          });
        }
      }
      setState(() {
        widget.isLoading = false;
      });
    };
    bBlupSheetsApi.onFailure = (error) {
      if (error is Response) {
        print("error is ${error.body}");
      }
    };
  }
}
