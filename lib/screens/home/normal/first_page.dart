import 'package:flutter/material.dart';
import 'package:sklps_app/screens/home/normal/announcements.dart';
import 'package:sklps_app/screens/home/normal/events.dart';

import '../../../shared/constants.dart';
import '../../../shared/size_config.dart';
class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

//keeps track of which page is shown
//if true --> Announcement
//if false --> Events
//var isAnnouncements = true;

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.blue[500],
        child: SafeArea(
          bottom: false,
          child: Container(
            height: SizeConfig.safeBlockVertical * 100,
            width: SizeConfig.safeBlockHorizontal * 100,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue[500],
                elevation: 0,
                toolbarHeight: SizeConfig.safeBlockVertical * 8,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: (){
                          /*setState(() {
                            isAnnouncements = true;
                            print(isAnnouncements);
                          });*/
                        },
                        child: TextDefault(
                          text: "Announcements",
                          color: Colors.white,//isAnnouncements ? Colors.white : Colors.black,
                          sizeMultiplier: 3.5,
                          bold: FontWeight.bold,//isAnnouncements ? FontWeight.bold : FontWeight.normal,
                        )
                    ),
                    /*TextButton(
                        onPressed: (){
                          setState(() {
                            isAnnouncements = false;
                            print(isAnnouncements);
                          });
                        },
                        child: TextDefault(
                          text: "Events",
                          color: isAnnouncements ? Colors.black : Colors.white,
                          sizeMultiplier: 3.5,
                          bold: isAnnouncements ? FontWeight.normal : FontWeight.bold,
                        )
                    ), */
                  ],
                ),
              ),
              body: Announcements(),//isAnnouncements ? Announcements() : Events(),
            ),
          ),
        ),
      ),
    );
  }
}
