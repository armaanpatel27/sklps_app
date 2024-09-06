import 'package:flutter/material.dart';

import '../../../services/access_data.dart';
import '../../../services/announcement_helper.dart';
import '../../../shared/constants.dart';
import '../../../shared/size_config.dart';
class Announcements extends StatefulWidget {
  const Announcements({Key? key}) : super(key: key);

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {

  AccessData _accessData = AccessData();
  AnnouncementHelper announcementHelper = AnnouncementHelper();
  //stores all documents inside Announcement collection
  List<Map<dynamic, dynamic>> announcementList = [];

  @override
  void initState() {
    super.initState();
    initializeAnnouncementList();
  }
  //initializes announcementList to store documents as a maps inside Announcement collection
  void initializeAnnouncementList() async{
    //tempList holds value of announcement
    //prevents setState from being async
    try {
      List<Map<dynamic, dynamic>> tempList = await _accessData.getAllDocuments(
          "announcements");
      setState(() {
        announcementList = tempList;
        announcementHelper.sortListByDate(announcementList);
      });
    } catch(e) {
      setState(() {
        isError = true;
      });
    }
  }

  //whether an error occurred when initializing AnnouncementList
  var isError = false;

  @override
  Widget build(BuildContext context) {
    return isError ? Center(child: Container(child: TextDefault(text: "Error #1020", sizeMultiplier: 5, color: Colors.black,),)) : Material(
      child: SafeArea(
        bottom: false,
        child: Container(
          color: Colors.white,
          height: SizeConfig.safeBlockVertical * 92,
          width: SizeConfig.safeBlockHorizontal * 100,
          //build container for each item in announcementList
          child: ListView.separated(
            //SizedBox separates each item build by ListView
            separatorBuilder: (context, index) =>Column(children: [Divider(color: Colors.black, thickness: 1.0,),SizedBox(height: SizeConfig.safeBlockVertical * 1,)],),
            itemCount: announcementList.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockVertical * 2, SizeConfig.safeBlockVertical * 2, SizeConfig.safeBlockVertical * 2, SizeConfig.safeBlockVertical * 2),
              child: Container(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.zero),
                        color: Colors.blue[100],
                      ),
                      padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 2, SizeConfig.safeBlockVertical * 1, SizeConfig.safeBlockHorizontal * 2, SizeConfig.safeBlockVertical * 1),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: TextDefault(
                              text: announcementList[index]["name"],
                              sizeMultiplier: 2.5,
                              color: Colors.black,
                              bold: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: TextDefault(
                              text: announcementList[index]["content"],
                              sizeMultiplier: 2,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextDefault(
                        text: announcementHelper.timestampToString(announcementList[index]["timestamp"]),
                        sizeMultiplier: 1.8,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
