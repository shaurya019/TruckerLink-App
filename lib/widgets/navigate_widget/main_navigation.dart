import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:trucker/screens/navigate_screen/search_destination.dart';
import 'package:trucker/widgets/navigate_widget/back_icon.dart';
import 'package:trucker/widgets/navigate_widget/map_polyline.dart';
import 'package:trucker/widgets/navigate_widget/navigate_bottom_sheet.dart';
LatLng Pos = const LatLng(0, 0);

class NavigateSet extends StatefulWidget {
  const NavigateSet({super.key, this.endPosition, required this.duration});
  final DetailsResult? endPosition;
  final String duration;
  @override
  State<NavigateSet> createState() => _NavigateSetState();
}

class _NavigateSetState extends State<NavigateSet> {
  @override
  Widget build(BuildContext context) {
     Pos = LatLng(widget.endPosition!.geometry!.location!.lat!,
        widget.endPosition!.geometry!.location!.lng!);
    return  Scaffold(
      body: Stack(children: [
        NavigateMapScreen(endPosition:widget.endPosition),
        const Positioned(
          top: 57,
            right: 20,
            child: NavigateIcon()),
        NavigateSearch(screenIndex: 0,endPosition:widget.endPosition,duration:widget.duration),
      ]),
    );
  }
}