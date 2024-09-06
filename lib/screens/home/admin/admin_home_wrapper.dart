import 'package:flutter/material.dart';
import 'package:sklps_app/screens/home/admin/admin_announcements.dart';
import 'package:sklps_app/screens/home/admin/admin_first_page.dart';
import 'package:sklps_app/screens/home/normal/first_page.dart';
import 'package:sklps_app/shared/size_config.dart';
import 'admin_account.dart';
import 'admin_search.dart';

//Bottom Navigation Guide from "https://blog.logrocket.com/how-to-build-a-bottom-navigation-bar-in-flutter/"

class AdminHomeWrapper extends StatefulWidget {
  const AdminHomeWrapper({Key? key}) : super(key: key);

  @override
  State<AdminHomeWrapper> createState() => _AdminHomeWrapperState();
}

class _AdminHomeWrapperState extends State<AdminHomeWrapper> {

  //when tap on item in navigation bar --> sets current index
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  //holds value of the current index of the current page in BottomNavigationBar
  int currentIndex = 0;

  //Widgets displayed in BottomNavigationBar
  List<Widget> pages = [
    AdminFirstPage(),
    AdminSearch(),
    AdminAccount(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Stack(position widget) that shows a single child from a given index
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        color: Colors.blue,
        child: SafeArea(
          child: SizedBox(
            height: SizeConfig.safeBlockVertical * 9.5,
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.blue,
              currentIndex: currentIndex,
              //changes current index depending on which item is tapped
              onTap: onTap,
              //displays clickable icons that can be used to navigate between pages
              items: const <BottomNavigationBarItem>[
                //Admin Search Page
                BottomNavigationBarItem(
                  icon: Icon(Icons.announcement),
                  label: "Announcements",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: "Search",
                ),
                //Admin Account Page
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Account",
                ),
              ],

              //Customizing icons and their behavior
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedIconTheme: IconThemeData(
                color: Colors.black,
                size: SizeConfig.safeBlockVertical * 4.0,
              ),
              unselectedIconTheme: IconThemeData(
                color: Colors.black26,
                size: SizeConfig.safeBlockVertical * 3.2,
              ),

            ),
          ),
        ),
      ),
    );
  }
}
