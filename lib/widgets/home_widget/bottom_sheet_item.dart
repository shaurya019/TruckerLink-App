import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trucker/Lists/list.dart';
import 'package:trucker/Widgets/my_grid_view.dart';
import 'package:trucker/global/global_variables.dart';
import 'package:trucker/widgets/custom_widget/groups.dart';
import 'package:trucker/widgets/friends_widget/contacts.dart';
import 'package:trucker/widgets/home_widget/horizontal_second_sheet.dart';
import 'package:trucker/widgets/home_widget/near_by_search.dart';
import 'package:trucker/widgets/search_widget/search_api.dart';


int dragindex = 0;

class DragItem extends StatefulWidget {
   DragItem({super.key, required this.onTap, required this.onRefresh, this.onOpenFriendsTabCalled});
  final VoidCallback onTap;
  final VoidCallback onRefresh;
   final VoidCallback? onOpenFriendsTabCalled;

  @override
  State<DragItem> createState() => _DragItemState();
  static final DKey = GlobalKey();
}

class _DragItemState extends State<DragItem> {
  void bottomSheet(bool MoreShow) {
    setState(() {
      isMoreShow = MoreShow;
    });
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: dragindex == 0
          ? MainDragMenu(onTap: widget.onTap,onRefresh:widget.onRefresh,onOpenFriendsTabCalled: widget.onOpenFriendsTabCalled)
          : dragindex == 1 ? const MoreItemDragMenu()
          : dragindex == 2 ? const SearchApiScreen()
          : const SizedBox(),
    );
  }
}

class MainDragMenu extends StatefulWidget {
  // const MainDragMenu({super.key, required this.refreshMain, required this.onTap});
  MainDragMenu({super.key, required this.onTap,required this.onRefresh, this.onOpenFriendsTabCalled});
  // final Function refreshMain;
  final VoidCallback onTap;
  final VoidCallback onRefresh;
  final VoidCallback? onOpenFriendsTabCalled;

  @override
  State<MainDragMenu> createState() => _MainDragMenuState();
}

class _MainDragMenuState extends State<MainDragMenu> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(height:8,),
          Container(
            width: 36,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(43),
              color: const Color(0xFFD0D5DD),
            ),
          ),
          const SizedBox(height:18,),
          InkWell(
            onTap: (){
              dragindex = 2;
              widget.onRefresh.call();
              DragItem.DKey.currentState?.setState(() {
              });
              // Get.to(const SearchApiScreen());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width:double.infinity,
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(43),
                  color: const Color(0xFFF2F4F7),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/image/search.svg',
                        height: 18,
                        width: 18,
                        color: const Color(0xFF475467),),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Where to go?',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Color(0xFF475467),)),
                    ),
                    SvgPicture.asset('assets/image/mic.svg',
                        height: 24,
                        width: 24,
                        color: const Color(0xFF475467)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height:18,),
          const HorizontalSecondSheet(),
          const SizedBox(height:18,),
          Container(
            width: double.infinity,
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16.0,),
            decoration: BoxDecoration(
              color: const Color(0xFFEAECF0),
              border: Border.all(
                color: const Color(0xFFEAECF0),
                width: 1,
              ),
            ),
          ),
          const SizedBox(height:18,),
          NearBy(),
          const SizedBox(height:18,),
          Container(
            width: double.infinity,
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16.0,),
            decoration: BoxDecoration(
              color: const Color(0xFFEAECF0),
              border: Border.all(
                color: const Color(0xFFEAECF0),
                width: 1,
              ),
            ),
          ),
          const SizedBox(height:18,),
           const Contact_sheet(),
          const SizedBox(height:18,),
          Container(
            width: double.infinity,
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16.0,),
            decoration: BoxDecoration(
              color: const Color(0xFFEAECF0),
              border: Border.all(
                color: const Color(0xFFEAECF0),
                width: 1,
              ),
            ),
          ),
          const SizedBox(height:18,),
           Groups(onTap: widget.onTap, onOpenFriendsTabCalled: widget.onOpenFriendsTabCalled),
        ]);
  }
}

class MoreItemDragMenu extends StatefulWidget {
  // final Function refreshMain;
  // const MoreItemDragMenu({super.key, required this.refreshMain});
  const MoreItemDragMenu({super.key,});

  @override
  State<MoreItemDragMenu> createState() => _MoreItemDragMenuState();
}

class _MoreItemDragMenuState extends State<MoreItemDragMenu> {
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:16.0),
      child: Column(children: [
        const SizedBox(height:8,),
        Container(
          width: 36,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(43),
            color: const Color(0xFFD0D5DD),
          ),
        ),
        const SizedBox(height: 18,),
        Container(
          width:double.infinity,
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(43),
            color: const Color(0xFFF2F4F7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    dragindex = 0;
                    DragItem.DKey.currentState?.setState(() {
                    });
                  },
                  child: const Icon(Icons.arrow_back)),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('More Categories',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Color(0xFF475467),)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18,),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Places',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475467),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: MyGridView(items: places)),
          ],
        ),
        const SizedBox(
          height: 18,
        ),
        Container(
          width: double.infinity,
          height: 1,
          decoration: BoxDecoration(
            color: const Color(0xFFEAECF0),
            border: Border.all(
              color: const Color(0xFFEAECF0),
              width: 1,
            ),
          ),
        ),
        const SizedBox(
          height: 18,
        ),
         Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Amenities',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475467),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: MyGridView(items: amenities)),
          ],
        ),
        const SizedBox(
          height: 18,
        ),
        Container(
          width: double.infinity,
          height: 1, // 1 pixel height for the border
          decoration: BoxDecoration(
            color: const Color(0xFFEAECF0), // Background color
            border: Border.all(
              color: const Color(0xFFEAECF0), // Border color
              width: 1, // Border width
            ),
          ),
        ),
        const SizedBox(
          height: 18,
        ),
         Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Food & Drink',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475467),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: MyGridView(items: food)),
          ],
        ),
        const SizedBox(
          height: 18,
        ),
        Container(
          width: double.infinity,
          height: 1, // 1 pixel height for the border
          decoration: BoxDecoration(
            color: const Color(0xFFEAECF0), // Background color
            border: Border.all(
              color: const Color(0xFFEAECF0), // Border color
              width: 1, // Border width
            ),
          ),
        ),
        const SizedBox(
          height: 18,
        ),
         Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Truck Services',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475467),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
                alignment: Alignment.centerLeft, child: MyGridView(items: truck)),
          ],
        ),
        const SizedBox(
          height: 18,
        ),
        Container(
          width: double.infinity,
          height: 1,
          decoration: BoxDecoration(
            color: const Color(0xFFEAECF0),
            border: Border.all(
              color: const Color(0xFFEAECF0),
              width: 1, // Border width
            ),
          ),
        ),
      ]),
    );
  }
}
