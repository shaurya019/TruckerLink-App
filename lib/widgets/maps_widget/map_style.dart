import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trucker/widgets/maps_widget/map_setting.dart';
import 'package:trucker/widgets/maps_widget/main_map.dart';

int selectMapIndex = 0;

class MapStyle extends StatefulWidget {
  final Function onChange;
  const MapStyle({super.key, required this.onChange});

  @override
  State<MapStyle> createState() => _MapStyleState();
}

class _MapStyleState extends State<MapStyle> {
  @override
  void initState() {
    super.initState();
    switch (currentMapType) {
      case MapType.none:
        selectMapIndex = 0;
      case MapType.normal:
        selectMapIndex = 0;
      case MapType.satellite:
        selectMapIndex = 1;
      case MapType.terrain:
        selectMapIndex = 2;
      case MapType.hybrid:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Map Style',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475467),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(55),
                ),
                child: TextButton(
                  onPressed: () {
                    MapSetting.staticKey.currentState?.setIndex(0);
                    widget.onChange(0);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55.0),
                      ),
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/image/cross.svg',
                    width: 24,
                    height: 24,
                    color: const Color(0xFF475467),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildMapStyleOption(0, 'Default', 'assets/image/mapStyle1.png'),
              buildMapStyleOption(1, 'Satellite', 'assets/image/mapStyle2.png'),
              buildMapStyleOption(2, 'Terrain', 'assets/image/mapStyle3.png'),
            ],
          ),
          const SizedBox(
            height: 18,
          )
        ],
      ),
    );
  }

  Widget buildMapStyleOption(int index, String title, String imagePath) {
    final isSelected = selectMapIndex == index;
    return Container(
      height: 96,
      width: 68,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.11),
      ),
      child: InkWell(
        onTap: () {
          if (index == 0) {
            currentMapType = MapType.normal;
          }
          if (index == 1) {
            currentMapType = MapType.satellite;
          }
          if (index == 2) {
            currentMapType = MapType.terrain;
          }
          setState(() {
            selectMapIndex = index;
          });
          MainMaps.gKey.currentState?.setState(() {});
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.11),
                border: Border.all(
                  width: 3.78,
                  color:
                  isSelected ? const Color(0xFFFF8D49) : Colors.transparent,
                ),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFFFF8D49)
                    : const Color(0xFF5D5E67),
              ),
            )
          ],
        ),
      ),
    );
  }
}
