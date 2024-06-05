import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trucker/Lists/list.dart';
import 'package:trucker/widgets/navigate_widget/main_navigation.dart';
import 'package:trucker/widgets/nearby_widget/move_home.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigateInfo extends StatefulWidget {
  final DetailsResult? endPosition;
  final String duration;
  const NavigateInfo({super.key, this.endPosition, required this.duration});

  @override
  State<NavigateInfo> createState() => _NavigateInfoState();
}

class _NavigateInfoState extends State<NavigateInfo>
    with WidgetsBindingObserver {
  int selectedIndex = -1;
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      resetClickedItemsList();
    }
  }

  void resetClickedItemsList() {
    setState(() {
      selectedIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD0D5DD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18.0),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Container(
                  width: double.infinity,
                  height: 56.0,
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.duration,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 12.0),
            SizedBox(
              height: 40,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (context, index) {
                    final isSelected = index == selectedIndex;
                    final width = 98.0;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        if (index == 0) {
                          gotoMap();
                        }
                        if (index == 1) {
                          Share.share(
                              'Location shared via TruckerLink: ${getMapUrl(widget.endPosition!.geometry!.location!.lat,widget.endPosition!.geometry!.location!.lng)}');
                        }
                      },
                      child: Container(
                        width: width,
                        height: 40.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          border: index == selectedIndex
                              ? null
                              : Border.all(
                            color: const Color(0xFFD0D5DD),
                            width: 1.0,
                          ),
                          color: isSelected
                              ? const Color(0xFFFF8D49)
                              : Colors.white,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SvgPicture.asset(
                                navigateIcons[index],
                                width: 15.0,
                                height: 15.0,
                                fit: BoxFit.scaleDown,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF475467),
                              ),
                              Text(
                                navigateItems[index],
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                  letterSpacing: 0.1,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF475467),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 300,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: widget.endPosition!.photos!.length,
                itemBuilder: (context, int index) {
                  return Container(
                    height: 300,
                    width: 300,
                    margin: const EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=300&photo_reference=${widget.endPosition!.photos![index].photoReference}&key=AIzaSyCWO_OjMQ5weq00puKyGj47Umf2DJUetp0',
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18.0),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFD0D5DD),
                ),
                margin: const EdgeInsets.all(1.0),
              ),
            ),
            const SizedBox(height: 18.0),
            Text(
              'More Places',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 18.0),
            Row(
              children: List.generate(
                4,
                    (index) => Padding(
                  padding: EdgeInsets.only(
                      left: index == 0 ? 8.0 : 0.0,
                      right: index < 3 ? 8.0 : 0.0),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(42.0),
                    child: InkWell(
                      onTap: () {
                        if (index == 0) {
                          Get.to( Move(value:'Hotel',head:'Hotels',position: Pos,));
                        }
                        if (index == 1) {
                          Get.to( Move(value:'Gas Station',head:'Gas Stations',position: Pos,));
                        }
                        if (index == 2) {
                          Get.to( Move(value:'Parking',head:'Parkings',position: Pos,));
                        }
                        if (index == 3) {
                          Get.to( Move(value:'Walmart',head:'Walmarts',position: Pos,));
                        }
                      },
                      child: Center(
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 40) / 4,
                          height: 62,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: const Color(0xFFF2F4F7),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 18.0,
                                  height: 18.0,
                                  padding: const EdgeInsets.only(
                                      top: 2.25, left: 2.25),
                                  child: SvgPicture.asset(
                                    icons[index],
                                    width: 14.0,
                                    height: 14.0,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  items[index],
                                  style: const TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 14.0,
                                    color: Color(0xFF475467),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getMapUrl(double? lat, double? lng) {
    return
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";
  }

  gotoMap() {
    try {
      var url =
          "https://www.google.com/maps/dir/?api=1&destination=${widget.endPosition!.geometry!.location!.lat},${widget.endPosition!.geometry!.location!.lng}";
      final Uri url0 = Uri.parse(url);
      launchUrl(url0);
    } catch (_) {
      print("Error launch Map");
    }
  }
}
