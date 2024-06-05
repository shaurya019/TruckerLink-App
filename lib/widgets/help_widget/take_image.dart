import 'dart:io';
import 'package:b_dep/b_dep.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:trucker/requests/message_api.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:trucker/screens/splash_screen/splash.dart';
import 'package:trucker/widgets/help_widget/help.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final List<XFile> existingImages;

  const TakePictureScreen({
    required this.camera,
    Key? key,
    this.existingImages = const [],
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final List<XFile> _imageFiles = [];
  List<String> _paths = [];
  final int maxImages = 4;
  var uuid = "trucker";
  bool isButtonEnabled = false;
  bool isButtonEnabledHelp = false;
  ScrollController scrollController = ScrollController();
  final TextEditingController alertController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    if (widget.existingImages.isNotEmpty) {
      _imageFiles.addAll(widget.existingImages);
    }
    isButtonEnabled = _imageFiles.isNotEmpty;
  }

  @override
  void dispose() {
    scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_imageFiles.length >= maxImages) {
      return;
    }
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate();
      }
      setState(() {
        _imageFiles.add(image);
        _paths.add(image.path);
        isButtonEnabled = true;
      });
    } catch (e) {
      print(e);
    }
  }

  void helpImageDialog(CameraDescription camera) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext contextA, StateSetter setStateDialog) {
              return Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                insetPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                    child: IntrinsicHeight(
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: const Color(0xFFF2F3F6),
                              padding: const EdgeInsets.all(16.0),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.shield_outlined,
                                        size: 24,
                                        color: Color(0xFF475467),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Safety',
                                        style: TextStyle(
                                          color: Color(0xFF475466),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '2 of 2 steps',
                                    style: TextStyle(
                                      color: Color(0xFF98A1B2),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            _imageFiles.isNotEmpty
                                ? Stack(
                              children: [
                                if (_imageFiles.length == 1)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(1.0),
                                    child: Image.file(
                                      File(_imageFiles[0].path),
                                      fit: BoxFit.cover,
                                      height: 320,
                                    ),
                                  ),
                                if (_imageFiles.length == 2)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Image.file(
                                            File(_imageFiles[0].path),
                                            fit: BoxFit.cover,
                                            height: 320,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Image.file(
                                            File(_imageFiles[1].path),
                                            fit: BoxFit.cover,
                                            height: 320,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_imageFiles.length == 3)
                                  SizedBox(
                                    height: 320,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 160,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      1.0),
                                                  child: Image.file(
                                                    File(_imageFiles[0].path),
                                                    fit: BoxFit.cover,
                                                    height: 160,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(0, 1, 1, 1),
                                                  child: Image.file(
                                                    File(_imageFiles[1].path),
                                                    fit: BoxFit.cover,
                                                    height: 160,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 160,
                                          padding: const EdgeInsets.all(1.0),
                                          width: MediaQuery.of(context)
                                              .size
                                              .width,
                                          child: Image.file(
                                            File(_imageFiles[2].path),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                if (_imageFiles.length == 4)
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding:
                                              const EdgeInsets.all(1.0),
                                              child: Image.file(
                                                File(_imageFiles[0].path),
                                                fit: BoxFit.cover,
                                                height: 160,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                              const EdgeInsets.all(1.0),
                                              child: Image.file(
                                                File(_imageFiles[1].path),
                                                fit: BoxFit.cover,
                                                height: 160,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding:
                                              const EdgeInsets.all(1.0),
                                              child: Image.file(
                                                File(_imageFiles[2].path),
                                                fit: BoxFit.cover,
                                                height: 160,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                              const EdgeInsets.all(1.0),
                                              child: Image.file(
                                                File(_imageFiles[3].path),
                                                fit: BoxFit.cover,
                                                height: 160,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                _imageFiles.length != 4
                                    ? Positioned(
                                  bottom: 16,
                                  right: 10,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Get.to(TakePictureScreen(
                                        camera: camera,
                                        existingImages: _imageFiles,
                                      ));
                                    },
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      padding: const EdgeInsets.all(12),
                                      decoration: ShapeDecoration(
                                        color: Colors.black
                                            .withOpacity(0.2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(26),
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/image/capture.svg',
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                )
                                    : const SizedBox(),
                              ],
                            )
                                : Stack(
                              children: [
                                const SizedBox(
                                  height: 320,
                                  child: Center(
                                    child: Text(
                                      "No Image Clicked !! Please Click an Image",
                                      style: TextStyle(
                                        color: Color(0xFF344053),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  right: 10,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Get.to(
                                          TakePictureScreen(camera: camera));
                                    },
                                    borderRadius: BorderRadius.circular(26),
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      padding: const EdgeInsets.all(12),
                                      decoration: ShapeDecoration(
                                        color: Colors.black.withOpacity(0.2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(26),
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/image/capture.svg',
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Column(
                                children: [
                                  Container(
                                    height: 95.0,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: TextField(
                                      style: const TextStyle(
                                        color: Color(0xFF1D2838),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      controller: alertController,
                                      onChanged: (text) {
                                        setStateDialog(() {
                                          isButtonEnabledHelp = text.isNotEmpty;
                                        });
                                      },
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                        fillColor: Color(0xFFF2F3F6),
                                        filled: true,
                                        border: InputBorder.none,
                                        hintText:
                                        "What caution would you like \nto share with others?\nEg: Accident, Snow, Traffic Jam, etc.",
                                        hintStyle: TextStyle(
                                          color: Color(0xFF98A1B2),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: const Color(0xFFF2F3F6),
                                    child: TextButton(
                                      onPressed: () {
                                        _imageFiles.clear();
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        overlayColor:
                                        MaterialStateColor.resolveWith(
                                                (states) => Colors.transparent),
                                      ),
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Color(0xFF98A1B2),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: isButtonEnabledHelp
                                        ? const Color(0xFFFF8D49)
                                        : const Color(0xFFF9FAFB),
                                    child: TextButton(
                                      onPressed: isButtonEnabledHelp
                                          ? () async {
                                        await upload(contextA);
                                        _imageFiles.clear();
                                      }
                                          : null,
                                      style: ButtonStyle(
                                        overlayColor:
                                        MaterialStateColor.resolveWith(
                                                (states) => Colors.transparent),
                                      ),
                                      child: Text(
                                        "Add Marker",
                                        style: TextStyle(
                                          color: isButtonEnabledHelp
                                              ? Colors.white
                                              : const Color(0xFF98A2B3),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFEEEEEE),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            size: 24,
            color: Color(0xFF667085),
          ),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Capture Images',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF475466),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '1 of 2 Steps',
              style: TextStyle(
                color: Color(0xFF98A1B2),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Positioned.fill(
                        child: CameraPreview(_controller),
                      ),
                      Positioned(
                        left: 10,
                        bottom: 15,
                        child: Text(
                          '${_imageFiles.length} out of $maxImages Captured',
                          style: const TextStyle(
                            color: Color(0xFFF0F0F0),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 25,
                        left: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            _takePicture();
                          },
                          child: SvgPicture.asset(
                            'assets/image/camerabut.svg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF8D49),
                      ));
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 62,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imageFiles.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: 45,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: FileImage(
                                File(_imageFiles[index].path),
                              ),
                              fit: BoxFit.cover,
                            ),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 0.10,
                                color: Color(0xFF545454),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: isButtonEnabled
                      ? () {
                    Get.back();
                    print("Next button pressed");
                    helpImageDialog(widget.camera);
                  }
                      : null,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    decoration: ShapeDecoration(
                      color: isButtonEnabled
                          ? const Color(0xFFFF8D49)
                          : const Color(0xFFF9FAFB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: Text(
                      'Next',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isButtonEnabled
                            ? const Color(0xFFF7F7F7)
                            : const Color(0xFF98A2B3),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> insertIntoAlert(BuildContext context, String downloadUrl) async {
    uuid = const Uuid().v1();
    DateTimeComponents dateTimeComponents = getCurrentDateTime();
    String times = dateTimeComponents.time;
    String date = dateTimeComponents.date;
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: 'c1d95df0-fac6-1dca-b01d-bf7d275b52fc',
      context: context,
    );
    var startLocation=await GetCurrentLocation().fetch();
      Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "uid": uuid,
        "Subject": alertController.text,
        "Status": "Active",
        "Lat": startLocation.latitude,
        "Lng": startLocation.longitude,
        "alertTime": times,
        "alertDate": date,
        "UserId": prefs.userId,
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "c1d95df0-fac6-1dca-b01d-bf7d275b52fc",
          jsonData: getJsonData());
      insertIntoAlertImage(context, uuid, downloadUrl);
    } catch (es, st) {
      print("Error in InsertIntoAlert>> $es $st");
    }
  }

  Future<void> insertIntoAlertImage(
      BuildContext context, String uuid, String pic) async {
    print("InsertIntoAlertImage *");
    BSheetsApi bBlupSheetsApi = BSheetsApi(
      'client.blup.white.falcon@gmail.com',
      calledFrom: '965807a0-faa6-1dca-b01d-bf7d275b52fc',
      context: context,
    );
    print("InsertIntoAlertImage **");
    Map<dynamic, dynamic> getJsonData() {
      Map<dynamic, dynamic> jsonData = {
        "uid": uuid,
        "image": pic,
      };
      return jsonData;
    }

    try {
      var response = await bBlupSheetsApi.runHttpApi(
          queryId: "965807a0-faa6-1dca-b01d-bf7d275b52fc",
          jsonData: getJsonData());
      print("InsertIntoAlertImage ***");
    } catch (es, st) {
      print("Error in InsertIntoAlertImage>> $es $st");
    }
  }

  void uploadImage(BuildContext context, List<String> path) async {
    print("upload started> $path");
    List<Uint8List?> bytesList = [];
    getFile_Picker_onFilePicked(
      context,
      kIsWeb ? bytesList : path,
    );
  }

  dynamic file_Picker_onFilePicked_List_of_filePath;

  void getFile_Picker_onFilePicked(
      BuildContext context, listOfFileBytes) async {
    print("getFile_Picker_onFilePicked *");
    file_Picker_onFilePicked_List_of_filePath = listOfFileBytes;
    print("getFile_Picker_onFilePicked **");
    await runFile_Uploader_to_BSS(context);
  }

  Future<void> runFile_Uploader_to_BSS(
      BuildContext context,
      ) async {
    print("** NOT CALLED HERE **");
    BStorage bStorage = BStorage();
    bStorage.uploadFile(getFile_Uploader_to_BSS_List_of_filePath());
    bStorage.bssOnSuccess = (downloadUrl) {
      print("File uploaded with url $downloadUrl");
      print("UUId - $uuid");
      if (uuid == "trucker") {
        insertIntoAlert(context, downloadUrl);
      } else {
        print("uuid - $uuid");
        insertIntoAlertImage(context, uuid, downloadUrl);
      }
    };
    bStorage.bssOnFailure = () {
      print("Failed");
    };
  }

  getFile_Uploader_to_BSS_List_of_filePath() {
    return file_Picker_onFilePicked_List_of_filePath;
  }

  Future<void> upload(BuildContext context) async {
    print("uploading *");
    for (int i = 0; i < _paths.length; i++) {
      print("uploading $i!");
      uploadImage(context, [_paths[i]]);
    }

    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: "Uploaded. Your marker is now shared with others!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
