import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trucker/widgets/help_widget/help.dart';
import 'package:trucker/widgets/help_widget/help_direction.dart';
import 'package:camera/camera.dart';
import 'package:trucker/widgets/help_widget/help_func.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key, required this.onTap, this.onOpenFriendsTabCalled});
  final VoidCallback onTap;
  final VoidCallback? onOpenFriendsTabCalled;

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  static List<CameraDescription>? staticCameras;
  List<CameraDescription> cameras = [];

  @override
  void initState() {
    super.initState();

    if (staticCameras == null) {
      getCamera();
    } else {
      cameras = staticCameras!;
    }
  }

  // This function is use to get the access of camera to click photo for saftey marker from user.
  Future<void> getCamera() async {
    cameras = await availableCameras();
    if (mounted) {
      setState(() {
        staticCameras = cameras;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HelpMaps(),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.34,
            right: MediaQuery.of(context).size.width * 0.001,
            child: HelpFunc(
                onTap: widget.onTap,
                onRefresh: () {
                  setState(() {});
                },
              onOpenFriendsTabCalled: widget.onOpenFriendsTabCalled,
            ),
          ),
          cameras.isNotEmpty
              ? Help(camera: cameras.first)
              : const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFEC6A00),
            ),
          ),
        ],
      ),
    );
  }
}
