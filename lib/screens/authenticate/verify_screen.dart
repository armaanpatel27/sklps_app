//purpose: checks if user email is verified(if it is --> check if admin; otherwise sendEmail screen)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sklps_app/screens/authenticate/admin_verify_screen.dart';
import 'package:sklps_app/screens/authenticate/send_Email.dart';
import 'package:sklps_app/screens/support.dart';
import 'package:sklps_app/services/access_data.dart';
import 'package:sklps_app/services/verify_user.dart';
import 'package:sklps_app/shared/constants.dart';
import 'package:sklps_app/screens/error_screen.dart';
import '../../models/User.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  VerifyUser verifyUser = VerifyUser();
  final _firebaseAuth = FirebaseAuth.instance;

  //function that checks if email is inside Samaj database
  //returns true if successful
  //otherwise returns false
  Future<bool?> verify() {
    return VerifyUser().verifyEmail(_firebaseAuth.currentUser!.email!);
  }

  //function that sets fields inside UserData
  //returns true if successful
  //otherwise returns false
  Future<bool> setUid() async {
    return VerifyUser().setUid();
  }

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //if email is verified --> update UserData and accountExists --> check if user is admin
    if (_auth.currentUser!.emailVerified) {
      return Container(
        decoration: boxDecorationBackground,

        //FutureBuilder handles data from a future function
        //futureBuilder guide from https://www.geeksforgeeks.org/flutter-futurebuilder-widget/
        child: FutureBuilder(
          //if setUID works --> admin verify screen to check if admin
          future: setUid(),
          builder: (context, snapshot) {
            //data is completely loaded
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ErrorScreen(errorCode: "Error 1006");
              } else if (snapshot.hasData) {
                //snapshot always created, if true then UID works and checks Admin, otherwise error
                final data = snapshot.data;
                //if setUID is successful
                if (data == true) {
                  //flag that the account has been created
                  try {
                    AccessData().updateField("membersPublic",
                        UserData.membersPublicId, "accountExists", true);
                    //go to AdminVerifyScreen
                    return AdminVerifyScreen();
                  } catch(e) {
                    return ErrorScreen(errorCode: "Error 1014");
                  }

                  //if setUID is unsuccessful
                } else {
                  return ErrorScreen(errorCode: "Error 1005");
                }
              } else {
                //if there is another error
                return ErrorScreen(errorCode: "Error 1007");
              }
              //if data is still loading
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingWheel();
            } else {
              return ErrorScreen(errorCode: "Error 1008");
            }
          },
        ),
      );

      //user is not verified yet --> check if user email is in database
      //if user email is in database --> sendEmail --> verifies user --> returns to this page
      //otherwise --> Support Page
    } else {
      return Container(
        decoration: boxDecorationBackground,
        child: FutureBuilder(
          future: verify(),
          builder: (context, snapshot) {
            //data is completely loaded
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ErrorScreen(errorCode: "Error 1001");
              } //snapshot always created, if returns a doc and true then send email page otherwise support page
              else if (snapshot.hasData) {
                final data = snapshot.data;
                //true if user email is in database --> send email
                if (data == true) {
                  return SendEmail(
                    isNavigator: false,
                  );
                  //don't allow access into application
                } else {
                  return const Support(
                    dialogBox: true,
                    dialogText:
                        "Sorry, it looks like your information is not in the Samaj database."
                        "For more assistance please see the page down below.",
                    signOutButton: true,
                  );
                }
              } else {
                //if there is another error
                return ErrorScreen(errorCode: "Error 1002");
              }
            } //if data is still loading return loading screen
            else if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingWheel();
            } else {
              //unknown error
              return ErrorScreen(errorCode: "Error 1003");
            }
          },
        ),
      );
    }
  }
}
