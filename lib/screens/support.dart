import "package:flutter/material.dart";
import 'package:sklps_app/services/auth.dart';
import 'package:sklps_app/shared/constants.dart';
import 'package:sklps_app/shared/custom_dialog_box.dart';

import '../shared/size_config.dart';

class Support extends StatefulWidget {
  //whether to display dialogbox
  final bool dialogBox;

  //whether to display signout button or close(Navigator.pop)
  final bool signOutButton;

  //stores dialogBox content
  final String? dialogText;

  const Support(
      {Key? key,
      required this.dialogBox,
      this.dialogText,
      required this.signOutButton})
      : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  CustomDialogBox dialogBox = CustomDialogBox();

  //Once page loads --> call dialog box if needed
  @override
  void initState() {
    super.initState();
    if (widget.dialogBox) {
      //after frame is called: executed function(prevents error)
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        //call customDialogBox
        await dialogBox.showCustomDialogBox(widget.dialogText!, context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();
    return Material(
      child: Container(
        color: Colors.blue,
        child: SafeArea(
          bottom: false,
          child: Container(
            color: Colors.white,
            height: SizeConfig.safeBlockVertical * 100,
            width: SizeConfig.safeBlockHorizontal * 100,
            child: Column(
              children: [
                //Title of page
                Container(
                  decoration:const BoxDecoration(
                    border: Border(
                      bottom: const BorderSide(width: 1.0, color: Colors.black),
                    ),
                    color: Colors.blue,
                  ),
                  height: SizeConfig. safeBlockVertical * 8,
                  width: SizeConfig.safeBlockHorizontal * 100,
                  child: Center(
                    child: TextDefault(
                      text: "Support",
                      sizeMultiplier: 6,
                      color: Colors.white,
                      bold: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: SizeConfig. safeBlockVertical * 6,
                    width: SizeConfig.safeBlockHorizontal * 94,
                    color: Colors.white,
                    child: TextDefault(
                      text: "Contact",
                      color: Colors.black,
                      sizeMultiplier: 4.5,
                      bold: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 3, 0, SizeConfig.safeBlockHorizontal * 3, 0),
                  child: Container(
                    height: SizeConfig. safeBlockVertical * 40,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    color: Colors.white,
                    child: TextDefault(
                      text: "Contact 1: Armaan Patel "
                          "\n                  Email: armaan0427@gmail.com"
                          "\n                  Phone Number: 630-600-1955"
                          "\n\nContact 2: Chetan Patel "
                          "\n                   Email: chetan814@gmail.com "
                          "\n                   Phone Number: 847-800-6543",
                      color: Colors.black87,
                      sizeMultiplier: 2.5,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1.0,
                  color: Colors.black,
                ),
                Center(
                  child: Container(
                    height: SizeConfig. safeBlockVertical * 6,
                    width: SizeConfig.safeBlockHorizontal * 94,
                    color: Colors.white,
                    child: TextDefault(
                      text: "Privacy",
                      color: Colors.black,
                      sizeMultiplier: 4.5,
                      bold: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 3, 0, SizeConfig.safeBlockHorizontal * 3, 0),
                  child: Container(
                    height: SizeConfig. safeBlockVertical * 25,
                    width: SizeConfig.safeBlockHorizontal * 100,
                    color: Colors.white,
                    child: TextDefault(
                      text: "Your privacy is of the utmost importance. "
                          "To protect your information, only registered members of the samaj"
                          " are granted access into the app. Your data can’t be seen by anyone but"
                          " members of the samaj.",
                      color: Colors.black87,
                      sizeMultiplier: 2.5,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1.0,
                  color: Colors.black,
                ),
                //if signOut is true --> show signOut button for auth
                //else --> show close button for Navigator.pop
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: widget.signOutButton
                          ? ElevatedButton(
                              child: TextDefault(
                                text: "Sign Out",
                                color: Colors.white,
                                sizeMultiplier: 2.5,
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                fixedSize: Size(SizeConfig.safeBlockHorizontal * 30,
                                    SizeConfig.safeBlockVertical * 6),
                              ),
                              onPressed: () async {
                                await _auth.signOut();
                              },
                            )
                          : ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: TextDefault(
                                text: "Close",
                                color: Colors.white,
                                sizeMultiplier: 2.5,
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                fixedSize: Size(SizeConfig.safeBlockHorizontal * 30,
                                    SizeConfig.safeBlockVertical * 6),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
