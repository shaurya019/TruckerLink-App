import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trucker/Lists/list.dart';
import 'package:trucker/global/global_list.dart';
import 'package:trucker/global/global_variables.dart';
import 'package:trucker/screens/login_screen/enter_details.dart';
import 'package:trucker/widgets/help_widget/help_group.dart';
import 'package:trucker/widgets/navigate_widget/main_navigation.dart';
import 'package:trucker/widgets/nearby_widget/move_home.dart';
import 'package:trucker/widgets/search_widget/search_api.dart';
import 'package:url_launcher/url_launcher.dart';

class DragSearch extends StatefulWidget {
  DragSearch(
      {super.key,
        required this.screenIndex,
        this.startPosition,
        required this.duration});
  final DetailsResult? startPosition;
  final String duration;
  int screenIndex;

  @override
  State<DragSearch> createState() => DragSearchState();
}

class DragSearchState extends State<DragSearch> {
  void refresh(int screenIndex) {
    setState(() {
      widget.screenIndex = screenIndex;
    });
  }

  int selectedIndex = 5;
  Uri dialNumber = Uri(scheme: 'tel', path: formattedPhoneNumber);
  TextEditingController textEditingController = TextEditingController();
  callNumber() async {
    await launchUrl(dialNumber);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.87,
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
              return SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 8.0),
                      Container(
                        width: 36,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD0D5DD),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      Container(
                        width: double.infinity,
                        height: 56,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(43),
                          color: const Color(0xFFf2f4f7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/image/search.svg',
                              height: 18,
                              width: 18,
                              color: const Color(0xFF475467),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF475467),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: tabItems.length,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemBuilder: (context, index) {
                            final isSelected = index == selectedIndex;
                            final width = index == 0 ? 131.0 : 105.0;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                                if (index == 0) {
                                  Get.to(
                                    NavigateSet(
                                        endPosition: widget.startPosition,
                                        duration: widget.duration),
                                  );
                                }
                                if (index == 1) {
                                  if (index == 1) {
                                    Get.to(GroupSelect(
                                       helpMessage: 'I am currently exploring the exquisite location known as $name',
                                    ));
                                  }

                                }
                                if (index == 2 &&
                                    formattedPhoneNumber != "Not Available") {
                                  callNumber();
                                }
                                if (index == 3) {
                                  Share.share(
                                      'Location shared via TruckerLink: ${getMapUrl(widget.startPosition!.geometry!.location!.lat,widget.startPosition!.geometry!.location!.lng)}');
                                }
                              },
                              child: Container(
                                width: width,
                                height: 40.0,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 4),
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SvgPicture.asset(
                                        tabIcons[index],
                                        width: 15.0,
                                        height: 15.0,
                                        fit: BoxFit.scaleDown,
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF475467),
                                      ),
                                      Text(
                                        tabItems[index],
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
                          },
                        ),
                      ),
                      const SizedBox(height: 8.0),

                      formattedPhoneNumber == "Not Available"
                      ?
                      Container(
                    width: double.infinity,
                    height: 60.0,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child:          Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/image/pin.svg'),
                          const SizedBox(width: 14.4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  formattedAddress,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade400,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      :
                      Container(
                        width: double.infinity,
                        height: 170.0,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/image/pin.svg'),
                                  const SizedBox(width: 14.4),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        Text(
                                          formattedAddress,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade400,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 2,
                              color: Colors.grey.shade300,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        ratings,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        'assets/image/star.svg',
                                        width: 15,
                                        height: 15,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        length,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      Text(
                                        ' Reviews',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 2,
                              color: Colors.grey.shade300,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: SelectableText(
                                  formattedPhoneNumber,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: arr.length,
                          itemBuilder: (context, int index) {
                            return Container(
                              height: 300,
                              width: 320,
                              margin: const EdgeInsets.all(8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  'https://maps.googleapis.com/maps/api/place/photo?maxwidth=300&photo_reference=${arr[index].photoReference}&key=AIzaSyCWO_OjMQ5weq00puKyGj47Umf2DJUetp0',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      Container(
                        width: double.infinity,
                        height: 1.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD0D5DD), // Color #D0D5DD
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      const SizedBox(height: 18.0),
                      Text(
                        'More Places ',
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
                                    Get.to( Move(value:'Hotel',head:'Hotels',position: pos,));
                                  }
                                  if (index == 1) {
                                    Get.to( Move(value:'Gas Station',head:'Gas Stations',position: pos,));
                                  }
                                  if (index == 2) {
                                    Get.to( Move(value:'Parking',head:'Parkings',position: pos,));
                                  }
                                  if (index == 3) {
                                    Get.to( Move(value:'Walmart',head:'Walmarts',position: pos,));
                                  }
                                },
                                borderRadius: BorderRadius.circular(16.0),
                                child: Container(
                                  width: (MediaQuery.of(context).size.width - 40) / 4,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: const Color(0xFFF2F4F7),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
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
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  getMapUrl(double? lat, double? lng) {
    return
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";
  }

}
