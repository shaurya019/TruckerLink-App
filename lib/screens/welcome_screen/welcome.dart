// ignore_for_file: avoid_print, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/screens/friends_screen/contacts.dart';
import 'package:trucker/screens/login_screen/login.dart';
import "package:http/http.dart" as http;
import "package:flutter_stripe/flutter_stripe.dart";
import "dart:convert";
import 'package:trucker/screens/splash_screen/splash.dart';

Map<String, dynamic>? paymentIntentData;

class Welcome extends StatefulWidget {
  Welcome({Key? key}) : super(key: key);

  bool isLoading = false;

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
  }

  // This Function is used to get the user Location information like Latitude and Longitude

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.string(svgPath),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  'Welcome to the new way to',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475467),
                  ),
                ),
                const Text(
                  'drive your truck.',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475467),
                  ),
                )
              ],
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFFF8D49),
              ),
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                onPressed: widget.isLoading ? null : _handleGetStarted,
                child: Center(
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Let's get started",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/image/upwardArrow.svg',
                              width: 10,
                              height: 10,
                              fit: BoxFit.scaleDown,
                            )
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //
  // Future<void> getLatLong() async {
  //   Future<Position> data =
  //       Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   data.then((value) {
  //     setState(() {
  //       lat = value.latitude;
  //       lng = value.longitude;
  //     });
  //     startLocation = LatLng(value.latitude, value.longitude);
  //   }).catchError((error) {
  //     print("Error $error");
  //   });
  // }

  void _handleGetStarted() async {
    setState(() {
      widget.isLoading = true;
    });
    await GetCurrentLocation().fetch();
    selectedFinalPhoneDetails.clear();
    setState(() {});
    final user = FirebaseAuth.instance.currentUser;
    await Future.delayed(const Duration(seconds: 2));
    Get.offAll(() => Login());
  }
}

const svgPath = '''
<svg width="243" height="49" viewBox="0 0 243 49" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_574_18914)">
<path d="M40.3789 9.38391H0.762695C0.762695 18.9007 8.47759 26.6156 17.9944 26.6156H23.1472V49H40.3789V9.38391Z" fill="#F97103"/>
<path d="M49.7084 0L30.8125 0.054656L49.7084 18.5303V0Z" fill="#F97103"/>
<path d="M61.5661 25.0758H54.1895V20.3057H74.4442V25.0758H67.0355V43.3592H61.5661V25.0758Z" fill="#1D2939"/>
<path d="M84.9391 31.2765C84.3662 31.2124 83.8894 31.1803 83.5087 31.1803C82.2158 31.1803 81.2508 31.4555 80.6157 32.0077C79.9805 32.5599 79.662 33.4815 79.662 34.7744V43.3592H74.415V26.2519H79.4698V29.4954C80.3179 27.3337 81.8746 26.2104 84.1438 26.1256C84.5038 26.1256 84.7695 26.1369 84.9391 26.1576V31.2765Z" fill="#1D2939"/>
<path d="M97.7503 40.9731C97.1773 41.8853 96.5101 42.5789 95.7468 43.0557C94.9835 43.5325 93.9771 43.7719 92.7257 43.7719C90.5432 43.7719 89.011 43.1782 88.1308 41.9909C87.2507 40.8035 86.8115 38.9923 86.8115 36.5535V26.2518H92.0585V35.2512C92.0585 35.8656 92.0698 36.3425 92.0905 36.6817C92.1113 37.0209 92.164 37.413 92.2489 37.8577C92.3337 38.3025 92.4656 38.6361 92.6465 38.8585C92.8275 39.0809 93.0857 39.2769 93.4249 39.4465C93.7641 39.6162 94.1769 39.701 94.665 39.701C95.7676 39.701 96.5573 39.3617 97.0341 38.6832C97.5109 38.0047 97.7503 36.8702 97.7503 35.2814V26.2518H102.997V43.3591H97.7503V40.975V40.9731Z" fill="#1D2939"/>
<path d="M122.997 32.5166H118.101C117.697 30.7148 116.606 29.8139 114.825 29.8139C113.766 29.8139 112.88 30.2116 112.17 31.0069C111.459 31.8023 111.105 33.048 111.105 34.7424C111.105 36.4367 111.465 37.7145 112.187 38.5099C112.907 39.3052 113.787 39.7029 114.825 39.7029C116.732 39.7029 117.899 38.8227 118.323 37.0643H123.22C122.839 38.6757 122.155 40.0044 121.169 41.0542C120.183 42.104 119.139 42.8183 118.037 43.2009C116.934 43.5816 115.758 43.7738 114.507 43.7738C111.731 43.7738 109.578 42.9577 108.052 41.3256C106.525 39.6934 105.762 37.4884 105.762 34.7122C105.762 31.9361 106.566 29.8535 108.178 28.21C109.789 26.5666 111.898 25.7449 114.505 25.7449C115.798 25.7449 116.991 25.9409 118.082 26.3329C119.173 26.7249 120.185 27.4467 121.118 28.4946C122.051 29.5444 122.677 30.8844 122.993 32.5166H122.997Z" fill="#1D2939"/>
<path d="M130.976 20.3057V32.7691L136.732 26.25H142.933L136.828 32.7993L143.442 43.3554H137.305L133.266 36.6139L130.976 39.0621V43.3554H125.729V20.3057H130.976Z" fill="#1D2939"/>
<path d="M161.598 37.9841C160.878 39.8914 159.738 41.3332 158.179 42.3095C156.621 43.2858 154.921 43.772 153.075 43.772C150.256 43.772 147.989 42.9616 146.272 41.3389C144.555 39.7162 143.695 37.5073 143.695 34.7086C143.695 31.9098 144.579 29.8762 146.351 28.2215C148.121 26.5686 150.288 25.7412 152.853 25.7412C155.673 25.7412 157.887 26.7118 159.498 28.6512C161.11 30.5905 161.83 33.0858 161.66 36.139H148.972C149.057 37.283 149.476 38.1632 150.228 38.7776C150.98 39.392 151.875 39.6992 152.915 39.6992C154.802 39.6992 156.083 39.1263 156.762 37.9823H161.594L161.598 37.9841ZM149.038 32.9596H156.447C156.426 31.9418 156.081 31.1521 155.414 30.5905C154.747 30.0289 153.893 29.7481 152.855 29.7481C151.816 29.7481 151.006 30.0176 150.295 30.5585C149.585 31.0994 149.167 31.9004 149.04 32.9596H149.038Z" fill="#1D2939"/>
<path d="M174.953 31.2765C174.38 31.2124 173.903 31.1803 173.522 31.1803C172.229 31.1803 171.264 31.4555 170.629 32.0077C169.994 32.5599 169.676 33.4815 169.676 34.7744V43.3592H164.429V26.2519H169.483V29.4954C170.332 27.3337 171.888 26.2104 174.157 26.1256C174.517 26.1256 174.783 26.1369 174.953 26.1576V31.2765Z" fill="#1D2939"/>
<path d="M182.837 38.557H193.902V43.3592H177.399V20.3057H182.837V38.557Z" fill="#1D2939"/>
<path d="M198.37 22.4052L200.993 24.5029H195.746V20.3057L198.37 22.4033V22.4052ZM201.025 26.2519V43.3592H195.748V26.2519H201.025Z" fill="#1D2939"/>
<path d="M200.993 24.5029L198.37 22.4052V22.4033L195.746 20.3057V24.5029H200.993Z" fill="#F97103"/>
<path d="M210.022 28.5098C210.446 27.7898 211.13 27.1698 212.073 26.6496C213.015 26.1313 214.103 25.8712 215.331 25.8712C217.452 25.8712 218.941 26.4649 219.798 27.6522C220.658 28.8396 221.085 30.6527 221.085 33.0896V43.3592H215.838V34.3919C215.838 33.7982 215.827 33.327 215.806 32.9765C215.786 32.6259 215.727 32.2302 215.631 31.7835C215.535 31.3368 215.397 31.0051 215.218 30.7827C215.037 30.5603 214.777 30.3643 214.44 30.1947C214.101 30.0251 213.688 29.9403 213.2 29.9403C212.097 29.9403 211.293 30.3172 210.784 31.0692C210.275 31.8212 210.02 32.9935 210.02 34.5822V43.3574H204.773V26.25H210.02V28.5079L210.022 28.5098Z" fill="#1D2939"/>
<path d="M229.77 20.3057V32.7691L235.526 26.25H241.727L235.622 32.7993L242.236 43.3554H236.099L232.06 36.6139L229.77 39.0621V43.3554H224.523V20.3057H229.77Z" fill="#1D2939"/>
<path d="M76.865 17.895L71.9365 17.9082L76.865 22.7274V17.895Z" fill="#F97103"/>
</g>
<defs>
<clipPath id="clip0_574_18914">
<rect width="241.472" height="49" fill="white" transform="translate(0.763672)"/>
</clipPath>
</defs>
</svg>
''';
