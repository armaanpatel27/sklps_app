//purpose: verify email UI and contols reset email process in backend
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sklps_app/screens/authenticate/verify_screen.dart';
import 'package:sklps_app/shared/constants.dart';
import 'package:sklps_app/shared/custom_dialog_box.dart';
import 'package:sklps_app/screens/error_screen.dart';
import 'package:sklps_app/shared/size_config.dart';
import '../../services/auth.dart';

class SendEmail extends StatefulWidget {
  //controls flow of app --> if true then Navigator.pop or else screen sticks after logging in
  final bool isNavigator;

  const SendEmail({Key? key, required this.isNavigator}) : super(key: key);

  @override
  State<SendEmail> createState() => _SendEmailState();
}

//email verification guided by https://www.youtube.com/watch?v=rTr8BUlUftg
class _SendEmailState extends State<SendEmail> {
  final _auth = AuthService();

  //keeps track of email verification through FirebaseAuth
  bool _isEmailVerified = false;
  bool _canResendEmail = false;
  Timer? timer;
  Timer? timer2;
  CustomDialogBox dialog = CustomDialogBox();

  @override
  //checks whether this page is necessary by updating var on initialization
  // to check if email is verified
  //if not verified --> send email to user
  //creates timer to check if user is verified every 5 seconds
  void initState() {
    //accesses emailVerification status from FirebaseAuth
    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    //can only send email link once every minute


    if (!_isEmailVerified) {
      sendEmail();

      //every 5 seconds --> check if emailVerification status has been updated
      timer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => checkIfVerified(),
      );

    }
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  //responsible for sending User email link and controlling when email link can be sent
  Future? sendEmail() async {
    try {
      //avoids having multiple timer conflicts
      timer2?.cancel();

      final user = FirebaseAuth.instance.currentUser!;
      //sends link to user
      await user.sendEmailVerification();
      //mounted checks if state object is in the tree --> avoid "setState after dispose" error
      if (this.mounted) {
        setState(() {
          _canResendEmail = false;
        });

        //every minute --> allow user to resend email
        timer2 = Timer.periodic(Duration(seconds: 60), (timer) {setState(() {
          _canResendEmail = true;
        });});
      }
    } catch (e) {
      print(e.toString());
      return ErrorScreen(errorCode: "#1004");
    }
  }

//updates variable if email has been verified(being called every 5 seconds)
  Future? checkIfVerified() async {
    //reloads state of user in FirebaseAuth
    await FirebaseAuth.instance.currentUser!.reload();
    if (this.mounted) {
      setState(() {
        _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //if email is verified --> go back to VerifyScreen
    if (_isEmailVerified == true) {
      //when switching to new screen --> cancel timers --> avoids memory leaks
      timer?.cancel();
      timer2?.cancel();
      return VerifyScreen();
    } else {
      return Material(
        child: SafeArea(
          bottom: false,
            child: Container(
              height: SizeConfig.safeBlockVertical * 100,
              width: SizeConfig.safeBlockHorizontal * 100,
              decoration: boxDecorationBackground,
              child: Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        SizeConfig.safeBlockHorizontal * 5,
                        SizeConfig.safeBlockVertical * 2,
                        SizeConfig.safeBlockHorizontal * 5,
                        SizeConfig.safeBlockVertical * 2),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          //Title
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 6,
                            child: TextDefault(
                              text: "Verify your email",
                              sizeMultiplier: 4.8,
                              color: Colors.black,
                              bold: FontWeight.bold,
                            ),
                          ),
                          Container(
                            height: SizeConfig.safeBlockVertical * 5,
                          ),
                          //Subtitle
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 7,
                            child: TextDefault(
                              text:
                                  "Just follow the instructions in the email we sent you",
                              sizeMultiplier: 2.2,
                              color: Colors.grey[600]!,
                              align: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: SizeConfig.safeBlockVertical * 17,
                          ),
                          //Email Icon in middle
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 25,
                            child: Icon(
                              Icons.email_outlined,
                              size: SizeConfig.safeBlockVertical * 25,
                              color: Colors.blue[500],
                            ),
                          ),
                          Container(
                            height: SizeConfig.safeBlockVertical * 17,
                          ),
                          //Resend email button
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 6,
                            child: ElevatedButton(
                              child: TextDefault(
                                text: "Didn't recieve an email? Click here!",
                                color: Colors.white,
                                sizeMultiplier: 2.5,
                              ),
                              onPressed: () {
                                if (_canResendEmail) {
                                  sendEmail();
                                  dialog.showCustomDialogBox(
                                      "Email sent successfully", context);
                                } else {
                                  dialog.showCustomDialogBox(
                                      "Email has already been sent. Please wait about a minute before trying again.",
                                      context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue[500],
                                fixedSize: Size(SizeConfig.safeBlockHorizontal * 100,
                                    SizeConfig.safeBlockVertical * 6),
                              ),
                              autofocus: true,
                            ),
                          ),
                          Container(
                            height: SizeConfig.safeBlockVertical * 3,
                          ),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 6,
                            child: TextButton(
                              child: TextDefault(
                                text: "Sign Out",
                                sizeMultiplier: 2.5,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                bold: FontWeight.bold,
                              ),
                              onPressed: () async {
                                //when switching to new screen --> cancel timers --> avoids memory leaks
                                timer?.cancel();
                                timer2?.cancel();
                                //if Navigator --> pop
                                //otherwise --> signOut
                                if (widget.isNavigator) {
                                  Navigator.of(context).pop();
                                }
                                await _auth.signOut();
                              },
                              autofocus: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
        ),
      );
    }
  }
}
