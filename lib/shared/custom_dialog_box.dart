import 'package:flutter/material.dart';
import 'package:sklps_app/services/access_data.dart';
import 'package:sklps_app/shared/size_config.dart';
import 'package:sklps_app/shared/text_filed_validation.dart';
import '../services/error_handling.dart';
import 'constants.dart';
//access to different types of dialog boxes
class CustomDialogBox {
  AccessData accessData = AccessData();

  //access to methods to return error strings
  ErrorHandling errorHandle = ErrorHandling();

  Future<void> showCustomDialogBox(String text, BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
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
              text: "Alert!",
              sizeMultiplier: 3,
              color: Colors.black,
              bold: FontWeight.bold,
            ),
            content: TextDefault(
              text: text,
              color: Colors.black,
              sizeMultiplier: 2.5,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: TextDefault(
                  text: "OK",
                  color: Colors.blue,
                  sizeMultiplier: 2,
                ),
              ),
            ],
          );
        });
  }

  Future<void> addUserDialogBox(String text, BuildContext context) {
    //contains info of new user
    String userName = "";
    String userEmail = "";

    //error text
    String error = "";

    //TextFormField validation for email and name
    final TextFieldValidation _validator = TextFieldValidation();
    final _globalKey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          //stateful builder allows us to update UI of dialogBox
          return SingleChildScrollView(
            child: StatefulBuilder(builder: (newContext, newSetState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: const BorderSide(color: Colors.black, width: 2),
                ),
                insetPadding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 3, SizeConfig.screenHeight/4, SizeConfig.safeBlockHorizontal * 3, 0),
                title: TextDefault(
                  text: "Alert!",
                  sizeMultiplier: 3,
                  color: Colors.black,
                  bold: FontWeight.bold,
                ),
                content: SizedBox(
                  height: SizeConfig.safeBlockVertical * 30,
                  width: SizeConfig.safeBlockHorizontal * 98,
                  child: Form(
                    key: _globalKey,
                    child: Column(
                      children: [
                        TextDefault(
                          text: text,
                          color: Colors.black,
                          sizeMultiplier: 2.5,
                        ),
                        //Name input field
                        TextFormField(
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 2.5),
                          decoration: InputDecoration(
                            hintText: "Name",
                            errorStyle: TextStyle(
                                fontSize: SizeConfig.safeBlockVertical * 1.5),
                            helperText: "",
                            helperStyle: TextStyle(
                                fontSize: SizeConfig.safeBlockVertical * 1.5),
                          ),
                          maxLines: 1,
                          //ensures proper name validation --> else updates errorText under field
                          validator: (value) {
                            return _validator.validateName(value);
                          },
                          //on change updates userName with value in textFormField
                          onChanged: (value) {
                            userName = value.trim();
                          },
                        ),
                        TextFormField(
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
                          //ensures proper email validation --> else updates errorText under field
                          validator: (value) {
                            return _validator.validateEmail(value?.trim());
                          },
                          //on change updates userEmail with value in textFormField
                          onChanged: (value) {
                            userEmail = value.trim();
                          },
                        ),
                        TextDefault(
                            text: error,
                            sizeMultiplier: 2,
                            color: Colors.red[800]!),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      //if validation fails --> reset error text on click(errorText from validation different from error)
                      if (!_globalKey.currentState!.validate()) {
                        newSetState(() {
                          error = "";
                        });
                        return;
                      }
                      //else if validation goes through --> add document to firestore database
                      //if error --> update error text accordingly
                      try {
                        await accessData.addDocument(userName, userEmail);
                        Navigator.of(context).pop();
                      } catch (e) {
                        newSetState(() {
                          if (e.toString() == "Exception: email-in-use") {
                            error = "Email is already in use";
                          } else {
                            error = "Error #1017. Please try again later";
                          }
                        });
                      }
                    },
                    child: TextDefault(
                      text: "Add User",
                      color: Colors.blue,
                      sizeMultiplier: 2.5,
                    ),
                  ),
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
                ],
              );
            }),
          );
        });
  }
}
