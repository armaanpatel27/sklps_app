import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../shared/constants.dart';
import '../shared/size_config.dart';
class ErrorScreen extends StatefulWidget {
  String errorCode;
  ErrorScreen({Key? key, required this.errorCode}) : super(key: key);

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();
    return Material(
      child: SafeArea(
        bottom: false,
        child: Container(
          height: SizeConfig.safeBlockVertical * 100,
          width: SizeConfig.safeBlockHorizontal * 100,
          decoration: boxDecorationBackground,
          //Padding wraps around entire page
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                SizeConfig.safeBlockHorizontal * 2,
                SizeConfig.safeBlockVertical * 2,
                SizeConfig.safeBlockHorizontal * 2,
                SizeConfig.safeBlockVertical * 2),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 6,
                    //Displays type of error
                    child: TextDefault(
                      text: widget.errorCode,
                      sizeMultiplier: 4.8,
                      color: Colors.black,
                      bold: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 5,
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 8,
                    child: TextDefault(
                      text:
                      "Please try again later or ask for assistance",
                      sizeMultiplier: 2.5,
                      color: Colors.grey[600]!,
                      align: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 10,
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 40,
                    child: Icon(
                      Icons.error_outline,
                      size: SizeConfig.safeBlockVertical * 40,
                      color: Colors.blue[500],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 10,
                  ),
                  SizedBox(
                    //Sign Out button
                    height: SizeConfig.safeBlockVertical * 6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue[500],
                          fixedSize: Size(SizeConfig.safeBlockHorizontal * 50,
                              SizeConfig.safeBlockVertical * 6)),
                      child: TextDefault(
                        text: "Sign Out",
                        color: Colors.black,
                        sizeMultiplier: 2.5,
                        decoration: TextDecoration.underline,
                        bold: FontWeight.bold,
                      ),
                      onPressed: () async {
                        await _auth.signOut();
                      },
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
