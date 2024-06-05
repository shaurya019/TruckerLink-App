import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trucker/widgets/home_widget/bottom_sheet_item.dart';
import 'package:trucker/widgets/maps_widget/map_style.dart';
import 'package:trucker/widgets/maps_widget/map_theme.dart';


// ignore: must_be_immutable
class Drag extends StatefulWidget {
  Drag({super.key,required this.screenIndex, required this.onTap, required this.onReferesh, this.onOpenFriendsTabCalled});
  int screenIndex;
  final VoidCallback onTap;
  final VoidCallback onReferesh;
  final VoidCallback? onOpenFriendsTabCalled;

  @override
  State<Drag> createState() => DragState();

  static GlobalKey<DragState> Dragkey = GlobalKey<DragState>();
}

class DragState extends State<Drag> {
  void refresh(int screenIndex) {
    print("DaD>> $screenIndex");
    setState(() {
      widget.screenIndex = screenIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: dragindex == 2 ? 0.87 : 0.32,
        minChildSize: 0.32,
        maxChildSize: widget.screenIndex == 0 ? 0.87 : 0.32,
        // snapSizes: [0.27, 0.87],
        snap: true,
        builder: (BuildContext context, scrollSheetController) {
          return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowIndicator();
                  return true;
                },
                child: ListView.builder(
                  itemCount: 1,
                  padding: EdgeInsets.zero,
                  physics: const PageScrollPhysics(),
                  controller: scrollSheetController,
                  itemBuilder: (BuildContext context, int index) {
                    print("Da>>> ${widget.screenIndex}");
                    if (widget.screenIndex == 0) {
                      return DragItem(
                        key: DragItem.DKey,
                        onTap: widget.onTap,
                         onRefresh: widget.onReferesh,
                        onOpenFriendsTabCalled: widget.onOpenFriendsTabCalled,
                      );
                    } else if (widget.screenIndex == 1) {
                      return MapStyle(
                        onChange: (selectedValue) {
                          print("onCahne>> $selectedValue");
                          refresh(selectedValue);
                        },
                      );
                    } else if (widget.screenIndex == 2) {
                      return MapTheme(
                        onChange: (selectedValue) {
                          print("onCahne>> $selectedValue");
                          refresh(selectedValue);
                        },
                      );
                    } else {
                      return null;
                    }
                  },
                ),
              ));
        });
  }
}


