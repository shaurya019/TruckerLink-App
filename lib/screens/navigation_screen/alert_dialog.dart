import 'package:b_dep/b_dep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trucker/screens/navigation_screen/bottom.dart';
import 'package:trucker/screens/profile_screen/profile.dart';
import 'package:trucker/widgets/help_widget/help_accepted.dart';
import 'package:trucker/widgets/help_widget/help_other_accepted.dart';

class AlertDialogShow extends StatefulWidget {
  String name;
  String subject;
  String userImage;
  List<String>imageList;
  String uuid;
  AlertDialogShow({super.key,required this.uuid, required this.name,required this.subject,required this.userImage,required this.imageList});
  // AlertDialogShow({super.key,required this.Name,required this.Subject});

  @override
  State<AlertDialogShow> createState() => _AlertDialogShowState();
}

class _AlertDialogShowState extends State<AlertDialogShow> {

  @override
  void initState() {
    super.initState();
    alertPresent = true;
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          children: [
            Container(
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
                    'Notification',
                    style: TextStyle(
                      color: Color(0xFF98A1B2),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            // List of image
            if (widget.imageList.isEmpty)
              const SizedBox(
                height: 406,
                child: Center(
                  child: Text(
                    'No image attached',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (widget.imageList.length == 1)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(1.0),
                child: Image.network(
                  widget.imageList[0],
                  fit: BoxFit.cover,
                  height: 406,
                ),
              ),
            if (widget.imageList.length == 2)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(1.0),
                      child: Image.network(
                        widget.imageList[0],
                        fit: BoxFit.cover,
                        height: 406,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(1.0),
                      child: Image.network(
                        widget.imageList[1],
                        fit: BoxFit.cover,
                        height: 406,
                      ),
                    ),
                  ),
                ],
              ),
            if (widget.imageList.length == 3)
              SizedBox(
                height: 406,
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(1.0),
                              child: Image.network(
                                widget.imageList[0],
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 1, 1, 1),
                              child: Image.network(
                                widget.imageList[1],
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      padding: const EdgeInsets.all(1.0),
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        widget.imageList[2],
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  ],
                ),
              ),
            if (widget.imageList.length == 4)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(1.0),
                          child: Image.network(
                            widget.imageList[0],
                            fit: BoxFit.cover,
                            height: 200,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(1.0),
                          child: Image.network(
                            widget.imageList[1],
                            fit: BoxFit.cover,
                            height: 200,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(1.0),
                          child: Image.network(
                            widget.imageList[0],
                            fit: BoxFit.cover,
                            height: 200,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(1.0),
                          child: Image.network(
                            widget.imageList[1],
                            fit: BoxFit.cover,
                            height: 200,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            // pop main content
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                   Row(
                    children: [
                      widget.userImage != ""
                          ?
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                        NetworkImage(widget.userImage),
                      )
                      :
                      const CircleAvatar(
                        radius: 26,
                        backgroundColor: Color(0xFF2970FF),
                        child: Icon(
                          Icons.person,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF475466),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF2F3F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:  Text(
                      widget.subject,
                      style: const TextStyle(
                        color: Color(0xFF1D2838),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
