import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Data/user_model.dart';
import '../../../Util/constants.dart';

class BottomNavBarWidget extends StatelessWidget {
  int selectedPage;
  Function(int)? onPressed;
  BottomNavBarWidget({
    required this.onPressed,
    required this.selectedPage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
        child: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(
              fontFamily: kNormalFont, fontSize: 11, color: kDarkBlueColor),
          backgroundColor: Colors.white,
          elevation: 10,
          currentIndex: selectedPage,
          onTap: onPressed,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          type: BottomNavigationBarType.shifting,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                child: Icon(
                  Icons.groups,
                  color: selectedPage == 0 ? kDarkBlueColor : kGreyColor,
                ),
              ),
              label: 'Groups',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Icon(
                  Icons.file_upload_rounded,
                  color: selectedPage == 1 ? kDarkBlueColor : kGreyColor,
                ),
              ),
              label: 'Upload',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Icon(
                  Icons.file_copy_sharp,
                  color: selectedPage == 2 ? kDarkBlueColor : kGreyColor,
                ),
              ),
              label: 'Download',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Icon(
                  Icons.settings,
                  color: selectedPage == 3 ? kDarkBlueColor : kGreyColor,
                ),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
