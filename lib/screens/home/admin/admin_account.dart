import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sklps_app/models/User.dart';
import 'package:sklps_app/shared/constants.dart';
import 'package:sklps_app/shared/custom_dialog_box.dart';
import 'package:sklps_app/shared/size_config.dart';
import '../../../services/access_data.dart';
import '../../../services/auth.dart';
import '../../../services/error_handling.dart';
import '../../authenticate/send_Email.dart';
class AdminAccount extends StatefulWidget {
  const AdminAccount({Key? key}) : super(key: key);

  @override
  State<AdminAccount> createState() => _AdminAccountState();
}

class _AdminAccountState extends State<AdminAccount> {





  //variables to store new values if requested to change
  String newEmail = "";
  String password = "";

  //holds error message
  String error = "";

  //access to methods to return error strings
  ErrorHandling errorHandle = ErrorHandling();

  ScrollController scrollController = ScrollController(initialScrollOffset: 0);


  //dialogBox handled user request to change email or delete account
  //param bool needEmail --> adjusts content of dialogBox based on user request to change email or delete account
  showDialogBox(String text, Future<dynamic> Function(dynamic, dynamic) fun, bool needEmail) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        //StateBuilder allows updates to dialogBox UI
        return StatefulBuilder(builder: (newContext, newSetState) {
          return AlertDialog(
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
              height: needEmail
                  ? SizeConfig.safeBlockVertical * 35
                  : SizeConfig.safeBlockVertical * 25,
              child: Column(
                children: [
                  TextDefault(
                    text: text,
                    color: Colors.black,
                    sizeMultiplier: 2.5,
                  ),
                  //if emailRequest --> display another textFormField that asks for email
                  //otherwise --> sizedBox(empty space)
                  needEmail
                      ? TextFormField(
                    style: TextStyle(
                        fontSize: SizeConfig.safeBlockVertical * 2.5),
                    decoration: InputDecoration(
                      hintText: "Email",
                      errorStyle: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 1.5),
                      helperText: "",
                      helperStyle: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 1.5),
                    ),
                    maxLines: 1,
                    //sets newEmail to text in textFormField on change
                    onChanged: (value) {
                      setState(() => newEmail = value.trim().toLowerCase());
                    },
                  )
                      : SizedBox(height: 0),
                  //Password input box
                  TextFormField(
                    style:
                    TextStyle(fontSize: SizeConfig.safeBlockVertical * 2.5),
                    decoration: InputDecoration(
                      hintText: "Password",
                      errorStyle: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 1.5),
                      helperText: "",
                      helperStyle: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 1.5),
                    ),
                    obscureText: true,
                    maxLines: 1,
                    //on change updates password with value in textFormField
                    onChanged: (value) {
                      setState(() => password = value.trim());
                    },
                  ),
                  //Error Text
                  TextDefault(
                      text: error, sizeMultiplier: 2, color: Colors.red),
                ],
              ),
            ),
            actions: <Widget>[
              //cancel Button --> removes DialogBox --> back to Account Page
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  newSetState(() {
                    error = "";
                  });
                },
                child: TextDefault(
                  text: "Cancel",
                  color: Colors.blue,
                  sizeMultiplier: 2.5,
                ),
              ),
              //Confirm email change or to delete account --> function is passed as argument to dialogBox
              TextButton(
                  onPressed: () async {
                    try {
                      //if function succeeds --> close dialog box
                      await fun(newEmail, password);
                      Navigator.of(context).pop();
                      //if emailChange request --> go to email verification page and update email field
                      if (needEmail) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SendEmail(
                              isNavigator: true,
                            )));
                        AccessData().updateField("membersPublic",
                            UserData.membersPublicId, "email", newEmail);
                      }
                      //if firebase error --> capture it in var error
                    } on FirebaseAuthException catch (e) {
                      newSetState(() {
                        error = errorHandle.errorHandling(e.code);
                      });
                      //if any other error --> display error message
                    } catch (e) {
                      newSetState(() {
                        if(!needEmail) {
                          error = "Error #1015. Please try again later";
                        } else {
                          error = "Error #1016. Please try again later";
                        }
                      });
                    }
                  },
                  child: TextDefault(
                    text: "Confirm",
                    color: Colors.blue,
                    sizeMultiplier: 2.5,
                  )),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //holds specific user info that will be displayed on the page
    List<Map> accountInfo = [
      {"title": "Email", "subtitle": UserData.email},
      {"title": "Phone Number", "subtitle": UserData.phoneNumber},
      {"title": "Gaam", "subtitle": UserData.gaam},
      {"title": "Street Address", "subtitle": "${UserData.address}"},
      {"title" : "City", "subtitle": "${UserData.city}"},
      {"title" : "State", "subtitle": "${UserData.state}"},
      {"title" : "Zip", "subtitle": "${UserData.zip}"},
      {"title": "Father", "subtitle": "${UserData.father}"},
      {"title": "Mother", "subtitle": "${UserData.mother}"},
      {"title": "Spouse", "subtitle": UserData.spouse},
      {"title": "Child1", "subtitle": "${UserData.child1}"},
      {"title" : "Child2", "subtitle": "${UserData.child2}"},
      {"title" : "Child3", "subtitle": "${UserData.child3}"},
      {"title" : "Child4", "subtitle": "${UserData.child4}"},
      {"title" : "Child5", "subtitle": "${UserData.child5}"},
    ];
    final authService = Provider.of<AuthService>(context);

    //whether this page is on top of a navigation stack
    bool canPop = Navigator.of(context).canPop();

    return Material(
      child: Container(
        color: Colors.blue[200],
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Container(
              height: SizeConfig.safeBlockVertical * 90.5,
              width: SizeConfig.safeBlockHorizontal * 100,
              color: Colors.white,
              child: Column(
                children: [
                  //Stack allows widgets to overlap each other
                  Stack(
                    children: [
                      //sets design pattern at the top of the page
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 25,
                        child: ClipPath(
                          clipper: CustomClipPath(),

                          //background for clipPath
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.blue[100]!, Colors.blue[500]!],
                                )),
                            height: SizeConfig.safeBlockVertical * 20,
                          ),
                        ),
                      ),
                      //sets up circleIcon in the center
                      Positioned(
                        top: SizeConfig.safeBlockVertical * 7.2,
                        left: SizeConfig.safeBlockHorizontal * 33,
                        child: CircleAvatar(
                          backgroundColor: Colors.lightBlue,
                          radius: SizeConfig.safeBlockVertical * 8.8,
                          child: CircleAvatar(
                            child: Icon(
                              Icons.person,
                              size: SizeConfig.safeBlockVertical * 15,
                            ),
                            backgroundColor: Colors.white,
                            radius: SizeConfig.safeBlockVertical * 8.2,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //displays User's name
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 7.5,
                    child: Center(
                      child: TextDefault(
                        text: UserData.name,
                        sizeMultiplier: 4.3,
                        color: Colors.black,
                        align: TextAlign.center,
                        height: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 4,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 3, 0,
                          SizeConfig.safeBlockHorizontal * 3, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextDefault(
                          text: "Personal Information",
                          color: Colors.black54,
                          sizeMultiplier: 2.8,
                          bold: FontWeight.w500,
                          align: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 3, 0,
                        SizeConfig.safeBlockHorizontal * 3, 0),
                    child: SizedBox(
                      height: SizeConfig.safeBlockVertical * 49,

                      //sets up scrollable container that displays User info
                      child: Scrollbar(
                        controller: scrollController,
                        isAlwaysShown: true,

                        //builds a listTile for each Map in accountInfo(each Map is one piece of data)
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          controller: scrollController,
                          itemCount: accountInfo.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              //from: "https://stackoverflow.com/questions/55265313/how-to-remove-space-at-top-and-bottom-listtile-flutter" to remove spaces
                              visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                              //displays type of data and value of data by accessing map inside accountInfo list
                              title: TextDefault(
                                text: accountInfo[index]["title"],
                                sizeMultiplier: 2.2,
                                color: Colors.black,
                                bold: FontWeight.bold,
                              ),
                              subtitle: TextDefault(
                                text: accountInfo[index]["subtitle"],
                                sizeMultiplier: 2.1,
                                color: Colors.blue[400]!,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  //fills in the rest of the available space
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //button to refresh page --> updates user info
                        IconButton(
                          onPressed: (){setState(() {});},
                          icon: Icon(Icons.refresh),
                          iconSize: SizeConfig.safeBlockVertical * 3.6,),
                        PopupMenuButton(
                          icon: Icon(Icons.settings),
                          iconSize: SizeConfig.safeBlockVertical * 3.6,

                          //List of buttons inside popUpMenu
                          itemBuilder: (context) => [

                            //User requests to change their email --> opens dialogBox for new value
                            PopupMenuItem(
                              child: TextDefault(
                                text: "Change Email Address",
                                sizeMultiplier: 2,
                                color: Colors.black,
                              ),
                              onTap: () {
                                //delays action to avoid reoccurring glitch where action doesn't execute
                                Future.delayed(const Duration(seconds: 0), () {
                                  showDialogBox(
                                      "Please enter your new email and current password",
                                      authService.changeEmail,
                                      true);
                                });
                              },
                            ),

                            //allows admin user to add a new user to the database
                            PopupMenuItem(
                                child: TextDefault(
                                  text: "Add New User",
                                  sizeMultiplier: 2,
                                  color: Colors.black,
                                ),
                              onTap: () {
                                Future.delayed( const Duration(seconds: 0), () {
                                  CustomDialogBox().addUserDialogBox("Enter user information here", context);
                                });
                              },
                            ),

                            //signs user out
                            PopupMenuItem(
                              child: TextDefault(
                                text: "Sign Out",
                                sizeMultiplier: 2,
                                color: Colors.black,
                              ),
                              onTap: () async {
                                //if this page is on a stack --> pops it so state can return to signIn page
                                if (canPop) {
                                  Navigator.of(context).pop();
                                }
                                await authService.signOut();
                              },
                            ),

                            //user requests to delete account --> shows dialogBox for confirmation
                            PopupMenuItem(
                              child: TextDefault(
                                text: "Delete Account",
                                sizeMultiplier: 2,
                                color: Colors.black,
                              ),
                              onTap: () {
                                Future.delayed( const Duration(seconds: 0), () {
                                  showDialogBox(
                                      "Please enter your password to delete your account",
                                      authService.deleteAccount,
                                      false);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//CustomClipPath code referenced from: "https://www.developerlibs.com/2019/08/flutter-draw-custom-shaps-clip-path.html"
class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    final path = Path();

    path.lineTo(0, h - 100);
    path.quadraticBezierTo(w / 2, h, w, h - 100);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

