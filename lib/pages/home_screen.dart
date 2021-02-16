import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/pages/signin_screen.dart';
import 'package:instagramclone/services/auth.dart';

import 'NotificationsPage.dart';
import 'ProfilePage.dart';
import 'SearchPage.dart';
import 'TimeLinePage.dart';
import 'UploadPage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;
  PageController pageController;

  getPageIndex(int pindex) {
    setState(() {
      pageIndex = pindex;
    });
  }

  onTapChangePage(int index) {
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.bounceOut);
  }
@override
  void initState() {
    // TODO: implement initState
  pageController=PageController();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose\
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: getPageIndex,
        physics: NeverScrollableScrollPhysics(),
        children: [
          TimeLinePage(),
          SearchPage(),
          UploadPage(),
          NotificationsPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Colors.white,
        currentIndex: pageIndex,
        inactiveColor: Colors.blueGrey,
        backgroundColor: Theme.of(context).accentColor,
        onTap: onTapChangePage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
          ),
        ],
      ),
    );
  }
}
