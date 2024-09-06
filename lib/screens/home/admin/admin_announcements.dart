import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sklps_app/models/User.dart';
import 'package:sklps_app/services/access_data.dart';
import 'package:sklps_app/services/announcement_helper.dart';
import '../../../shared/constants.dart';
import '../../../shared/size_config.dart';

class AdminAnnouncements extends StatefulWidget {
  const AdminAnnouncements({Key? key}) : super(key: key);

  @override
  State<AdminAnnouncements> createState() => _AdminAnnouncementsState();
}

//name on left, time underneath
class _AdminAnnouncementsState extends State<AdminAnnouncements> {
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
  void initializeAnnouncementList() async {
    //tempList holds value of announcement
    //prevents setState from being async
    try {
      List<Map<dynamic, dynamic>> tempList =
          await _accessData.getAllDocuments("announcements");
      setState(() {
        announcementList = tempList;
        announcementHelper.sortListByDate(announcementList);
      });
    } catch (e) {
      setState(() {
        isError = true;
      });
    }
  }

  //whether an error occurred when initializing AnnouncementList
  var isError = false;

  //dialogBox to edit announcement content
  showEditDialogBox(String text, int index) {
    //stores edited version of content of announcement
    var editedContent = "";
    var _error = "";
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        //StateBuilder allows updates to dialogBox UI
        return StatefulBuilder(builder: (newContext, newSetState) {
          return SingleChildScrollView(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              insetPadding: EdgeInsets.fromLTRB(
                  SizeConfig.safeBlockHorizontal * 5,
                  SizeConfig.safeBlockVertical * 2,
                  SizeConfig.safeBlockHorizontal * 5,
                  SizeConfig.safeBlockVertical * 2),
              title: TextDefault(
                text: "ALERT",
                color: Colors.black,
                sizeMultiplier: 3,
                bold: FontWeight.bold,
              ),
              //Size of dialogBox depends on whether it is a changeEmail request or deleteAccount request
              content: SizedBox(
                height: SizeConfig.safeBlockVertical * 38,
                child: Column(
                  children: [
                    Center(
                      child: TextDefault(
                        text: text,
                        color: Colors.black,
                        sizeMultiplier: 2.5,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 3,
                    ),
                    //Edit text box
                    TextFormField(
                      initialValue: announcementList[index]["content"],
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 2.5,
                          color: Colors.red),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ),
                        errorStyle: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical * 1.5),
                        helperText: "",
                        helperStyle: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical * 1.5),
                      ),
                      maxLines: 5,
                      //on change updates password with value in textFormField
                      onChanged: (value) {
                        newSetState(() => editedContent = value.trim());
                      },
                    ),
                    TextDefault(
                        text: _error, sizeMultiplier: 1.5, color: Colors.red)
                  ],
                ),
              ),
              actions: <Widget>[
                //cancel Button --> removes DialogBox --> back to Announcement Page
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    newSetState(() {
                      editedContent = "";
                    });
                  },
                  child: TextDefault(
                    text: "Cancel",
                    color: Colors.blue,
                    sizeMultiplier: 2.5,
                  ),
                ),
                //Edits content and sends it to database
                TextButton(
                    onPressed: () async {
                      try {
                        //if function succeeds --> close dialog box
                        await _accessData.updateField(
                            "announcements",
                            announcementList[index]["docID"],
                            "content",
                            editedContent);
                        pop(context);
                        //if error --> capture it in var error
                      } catch (e) {
                        newSetState(() {
                          _error = "Error #1020. Please try again later";
                        });
                      }
                    },
                    child: TextDefault(
                      text: "Confirm",
                      color: Colors.blue,
                      sizeMultiplier: 2.5,
                    )),
              ],
            ),
          );
        });
      },
    );
  }

  //dialogBox to confirm deleting an announcement
  showDeleteDialogBox(String text, int index) {
    //stores edited version of content of announcement
    var _error = "";
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        //StateBuilder allows updates to dialogBox UI
        return StatefulBuilder(builder: (newContext, newSetState) {
          return SingleChildScrollView(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              insetPadding: EdgeInsets.fromLTRB(
                  SizeConfig.safeBlockHorizontal * 5,
                  SizeConfig.safeBlockVertical * 2,
                  SizeConfig.safeBlockHorizontal * 5,
                  SizeConfig.safeBlockVertical * 2),
              title: TextDefault(
                text: "ALERT",
                color: Colors.black,
                sizeMultiplier: 3,
                bold: FontWeight.bold,
              ),
              //Size of dialogBox depends on whether it is a changeEmail request or deleteAccount request
              content: SizedBox(
                height: SizeConfig.safeBlockVertical * 15,
                child: Column(
                  children: [
                    Center(
                      child: TextDefault(
                        text: text,
                        color: Colors.black,
                        sizeMultiplier: 2.5,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 3,
                    ),
                    //Edit text box
                    TextDefault(
                        text: _error, sizeMultiplier: 1.5, color: Colors.red)
                  ],
                ),
              ),
              actions: <Widget>[
                //cancel Button --> removes DialogBox --> back to Announcement Page
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: TextDefault(
                    text: "Cancel",
                    color: Colors.blue,
                    sizeMultiplier: 2.5,
                  ),
                ),
                //Edits content and sends it to database
                TextButton(
                    onPressed: () async {
                      try {
                        //if function succeeds --> close dialog box
                        await _accessData.deleteDoc(
                            "announcements", announcementList[index]["docID"]);
                        pop(context);
                        //if firebase error --> capture it in var error
                      } catch (e) {
                        newSetState(() {
                          _error = "Error #1021. Please try again later";
                        });
                      }
                    },
                    child: TextDefault(
                      text: "Confirm",
                      color: Colors.blue,
                      sizeMultiplier: 2.5,
                    )),
              ],
            ),
          );
        });
      },
    );
  }

  //dialogBox to add a new announcement
  showAddDialogBox(String text) {
    //stores edited version of content of announcement
    var newContent = "";
    var _error = "";
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        //StateBuilder allows updates to dialogBox UI
        return StatefulBuilder(builder: (newContext, newSetState) {
          return SingleChildScrollView(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              insetPadding: EdgeInsets.fromLTRB(
                  SizeConfig.safeBlockHorizontal * 5,
                  SizeConfig.safeBlockVertical * 2,
                  SizeConfig.safeBlockHorizontal * 5,
                  SizeConfig.safeBlockVertical * 2),
              title: TextDefault(
                text: "ALERT",
                color: Colors.black,
                sizeMultiplier: 3,
                bold: FontWeight.bold,
              ),
              //Size of dialogBox depends on whether it is a changeEmail request or deleteAccount request
              content: SizedBox(
                height: SizeConfig.safeBlockVertical * 38,
                child: Column(
                  children: [
                    Center(
                      child: TextDefault(
                        text: text,
                        color: Colors.black,
                        sizeMultiplier: 2.5,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 3,
                    ),
                    //Edit text box
                    TextFormField(
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 2.5,
                          color: Colors.red),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ),
                        errorStyle: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical * 1.5),
                        helperText: "",
                        helperStyle: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical * 1.5),
                      ),
                      maxLines: 5,
                      //on change updates password with value in textFormField
                      onChanged: (value) {
                        newSetState(() => newContent = value.trim());
                      },
                    ),
                    TextDefault(
                        text: _error, sizeMultiplier: 1.5, color: Colors.red)
                  ],
                ),
              ),
              actions: <Widget>[
                //cancel Button --> removes DialogBox --> back to Announcement Page
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    newSetState(() {
                      newContent = "";
                    });
                  },
                  child: TextDefault(
                    text: "Cancel",
                    color: Colors.blue,
                    sizeMultiplier: 2.5,
                  ),
                ),
                //Edits content and sends it to database
                TextButton(
                    onPressed: () async {
                      try {
                        //if function succeeds --> close dialog box
                        await announcementHelper.addAnnouncement(UserData.name, newContent);
                        pop(context);
                        //if error --> capture it in var error
                      } catch (e) {
                        newSetState(() {
                          _error = "Error #1020. Please try again later";
                        });
                      }
                    },
                    child: TextDefault(
                      text: "Confirm",
                      color: Colors.blue,
                      sizeMultiplier: 2.5,
                    )),
              ],
            ),
          );
        });
      },
    );
  }

  //pops dialogBox and updates announcementList + UI
  void pop(context) {
    Navigator.of(context).pop();
    initializeAnnouncementList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //if error loading data --> show an error screen
    //otherwise --> show actual announcement page
    return isError
        ? Center(
            child: Container(
            child: TextDefault(
              text: "Error #1020",
              sizeMultiplier: 5,
              color: Colors.black,
            ),
          ))
        : Material(
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  height: SizeConfig.safeBlockVertical * 85,
                  width: SizeConfig.safeBlockHorizontal * 100,
                  //build container for each item in announcementList
                  child: Stack(
                    children: [
                      //creates a container for each announcement
                      ListView.separated(
                        //SizedBox separates each item build by ListView
                        separatorBuilder: (context, index) => Column(
                          children: [
                            Divider(
                              color: Colors.black,
                              thickness: 1.0,
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical * 1,
                            )
                          ],
                        ),
                        itemCount: announcementList.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.fromLTRB(
                              SizeConfig.safeBlockVertical * 2,
                              SizeConfig.safeBlockVertical * 2,
                              SizeConfig.safeBlockVertical * 2,
                              SizeConfig.safeBlockVertical * 2),
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.all(Radius.zero),
                                    color: Colors.blue[100],
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                      SizeConfig.safeBlockHorizontal * 2,
                                      SizeConfig.safeBlockVertical * 1,
                                      SizeConfig.safeBlockHorizontal * 2,
                                      SizeConfig.safeBlockVertical * 0),
                                  child: Column(
                                    children: [
                                      //name of person who created it
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
                                      //displays message
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: TextDefault(
                                          text: announcementList[index]
                                              ["content"],
                                          sizeMultiplier: 2,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          //refreshes state and retrieves data from announcements
                                          //IconButton(onPressed: (){initializeAnnouncementList();}, icon: Icon(Icons.refresh), iconSize: SizeConfig.safeBlockVertical * 3,),
                                          //edit or delete announcement options
                                          PopupMenuButton(
                                            icon: Icon(Icons.menu),
                                            iconSize:
                                                SizeConfig.safeBlockVertical * 3,
                                            itemBuilder: (context) => [
                                              //User requests to change their email --> opens dialogBox for new value
                                              PopupMenuItem(
                                                child: TextDefault(
                                                  text: "Edit",
                                                  sizeMultiplier: 2,
                                                  color: Colors.black,
                                                ),
                                                onTap: () {
                                                  Future.delayed(
                                                      const Duration(seconds: 0),
                                                      () {
                                                    showEditDialogBox(
                                                      "Please edit content of announcement here:",
                                                      index,
                                                    );
                                                  });
                                                },
                                              ),
                                              PopupMenuItem(
                                                child: TextDefault(
                                                  text: "Delete",
                                                  sizeMultiplier: 2,
                                                  color: Colors.black,
                                                ),
                                                onTap: () {
                                                  Future.delayed(
                                                      const Duration(seconds: 0),
                                                      () {
                                                    showDeleteDialogBox(
                                                      "Are you sure you want to delete this announcement?",
                                                      index,
                                                    );
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //shows date and time that announcement was posted
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: TextDefault(
                                    text: announcementHelper.timestampToString(
                                        announcementList[index]["timestamp"]),
                                    sizeMultiplier: 1.8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //button to post a new announcement
                      Positioned(
                        top:SizeConfig.safeBlockVertical * 71,
                        left: SizeConfig.safeBlockHorizontal * 82,
                        child: SizedBox(
                          height: SizeConfig.safeBlockVertical * 10,
                          child: FloatingActionButton(
                            backgroundColor: Colors.orange[600],
                            onPressed: () {
                              Future.delayed(
                                  const Duration(seconds: 0),
                                      () {
                                    showAddDialogBox(
                                      "Enter text for your new announcement:",
                                    );
                                  });
                            },
                            child: Icon(
                              Icons.add,
                              size: SizeConfig.safeBlockVertical * 6,
                              color: Colors.white,
                            )
                            ),
                        )),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
