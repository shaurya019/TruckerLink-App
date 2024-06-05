import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:trucker/widgets/navigate_widget/navigate_data.dart';

class NavigateSearch extends StatefulWidget {
  final DetailsResult? endPosition;
  NavigateSearch({super.key, required this.screenIndex,this.endPosition, required this.duration});
  int screenIndex;
  final String duration;

  @override
  State<NavigateSearch> createState() => NavigateSearchState();

}

class NavigateSearchState extends State<NavigateSearch> {
  void refresh(int screenIndex) {
    setState(() {
      widget.screenIndex = screenIndex;
    });

  }
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.33,
        minChildSize: 0.33,
        maxChildSize: .87,
        snapSizes: const [0.33, .87],
        snap: true,
        builder: (BuildContext context, scrollSheetController) {
          return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView.builder(
                  itemCount: 1,
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  controller: scrollSheetController,
                  itemBuilder: (BuildContext context, int index) {
                    return NavigateInfo(endPosition:widget.endPosition,duration:widget.duration);
                  }
              ));
        });
  }
}

