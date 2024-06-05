// ignore_for_file: avoid_unnecessary_containers, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trucker/widgets/maps_widget/main_map.dart';
import 'package:trucker/widgets/maps_widget/map_style.dart';
import 'package:trucker/widgets/maps_widget/map_theme.dart';

class MapSettingChange extends StatefulWidget {
  const MapSettingChange({super.key});

  @override
  State<MapSettingChange> createState() => _MapSettingChangeState();
}

class _MapSettingChangeState extends State<MapSettingChange> {
  late int tempSelectedMapIndex;
  late int tempSelectedThemeIndex;
  late MapType tempMapType;
  late String tempMapThemeJson;

  @override
  void initState() {
    super.initState();
    super.initState();
    tempSelectedMapIndex = selectMapIndex;
    tempSelectedThemeIndex = 1;
    tempMapType = currentMapType;
    tempMapThemeJson = lightThemeJson;
  }

  // This is used to give user option to select from multiple map style.
  void selectMapStyleOption(int index, MapType type) {
    setState(() {
      tempSelectedMapIndex = index;
      tempMapType = type;
    });
  }

  // This is used to give user option to select from multiple map Theme.
  void selectMapThemeOption(int index, String themeJson) {
    setState(() {
      tempSelectedThemeIndex = index;
      tempMapThemeJson = themeJson;
    });
  }

  // This function save the map setting after user select and click on the save button.
  void saveSettings() {
    setState(() {
      selectMapIndex = tempSelectedMapIndex;
      selectedThemeIndex = tempSelectedThemeIndex;
      currentMapType = tempMapType;
      googleMapsTheme = tempMapThemeJson;
    });
    mapController?.setMapStyle(googleMapsTheme);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle global = const TextStyle(
      fontFamily: 'SF Pro',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Color(0xFF98A2B3),
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF344054),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            const SizedBox(width: 12),
            const Text(
              'Map settings',
              style: TextStyle(
                color: Color(0xFF344053),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFD0D5DD),
                Color(0xFFEAECF0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Map Style',
              style: TextStyle(
                color: Color(0xFF475466),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildMapStyleOption(0, 'Default', 'assets/image/mapStyle1.png'),
                buildMapStyleOption(
                    1, 'Satellite', 'assets/image/mapStyle2.png'),
                buildMapStyleOption(2, 'Terrain', 'assets/image/mapStyle3.png'),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Map Theme',
              style: TextStyle(
                color: Color(0xFF475466),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildMapThemeOption(1, 'Light', 'assets/image/mapTheme1.png'),
                buildMapThemeOption(2, 'Dark', 'assets/image/mapTheme2.png'),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 24, 10),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFF8D49),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      saveSettings();
                      Get.back();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/image/save.svg',
                                color: const Color(0xFFFFFFFF),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Save',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildMapStyleOption(int index, String title, String imagePath) {
    final isSelected = tempSelectedMapIndex == index;
    return Container(
      child: InkWell(
        onTap: () {
          MapType type = MapType.normal;
          if (index == 1) type = MapType.satellite;
          if (index == 2) type = MapType.terrain;
          selectMapStyleOption(index, type);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  width: 3.78,
                  color:
                  isSelected ? const Color(0xFFFF8D49) : Colors.transparent,
                ),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 10),
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

  Widget buildMapThemeOption(int index, String title, String imagePath) {
    final isSelected = tempSelectedThemeIndex == index ||
        (index == 1 && tempSelectedThemeIndex == -1);
    return InkWell(
      onTap: () {
        String themeJson = lightThemeJson;
        if (index == 2) themeJson = darkThemeJson;
        selectMapThemeOption(index, themeJson);
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  width: 3.78,
                  color:
                  isSelected ? const Color(0xFFFF8D49) : Colors.transparent,
                ),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                height: 1.25,
                letterSpacing: 0.0,
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
