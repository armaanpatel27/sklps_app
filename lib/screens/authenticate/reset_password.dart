//purpose: shows reset password UI and controls backend work + emails
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:sklps_app/services/error_handling.dart';
import 'package:sklps_app/shared/constants.dart';
import 'package:sklps_app/shared/custom_dialog_box.dart';
import 'package:sklps_app/shared/size_config.dart';
import 'package:sklps_app/shared/text_filed_validation.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  //stores user entered info and error message
  String _email = "";
  String _error = "";

  bool canSendResetLink = true;

  CustomDialogBox dialog = CustomDialogBox();
  ErrorHandling errorHandler = ErrorHandling();

  //method that controls sending reset password link to email user from FireBase Auth
  Future? sendLink() async {
    try {
      final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
      await _firebaseAuth.sendPasswordResetEmail(email: _email);
      //reveal popup to let user know that event was successful
      dialog.showCustomDialogBox("Link sent successfully", context);
      //prevent overflow of links
      setState(() {
        canSendResetLink = false;
      });
      //after 1 minute --> allowed to send link again
      await Future.delayed(Duration(seconds: 60));
      setState(() {
        canSendResetLink = true;
      });
    } on FirebaseAuthException catch (e) {
      print(e.code);
      setState(() {
        _error = errorHandler.errorHandling(e.code);
      });
    }
  }

  //controls TextFormField validation
  final TextFieldValidation _validate = TextFieldValidation();
  final _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                  SizeConfig.safeBlockHorizontal * 5,
                  SizeConfig.safeBlockVertical * 2,
                  SizeConfig.safeBlockHorizontal * 5,
                  SizeConfig.safeBlockVertical * 2),
              child: Form(
                key: _globalKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 6,
                        child: TextDefault(
                          text: "Reset Password",
                          sizeMultiplier: 4.8,
                          color: Colors.black,
                          bold: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 5,
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 7,
                        child: TextDefault(
                          text:
                              "Please enter your account email to receive the password email link",
                          sizeMultiplier: 2.2,
                          color: Colors.grey[600]!,
                          align: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 17,
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 20,
                        child: Icon(
                          Icons.lock,
                          size: SizeConfig.safeBlockVertical * 20,
                          color: Colors.blue[500],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 5,
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 9.5,
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.bottom,
                          style:
                              TextStyle(fontSize: SizeConfig.safeBlockVertical * 2.5),
                          decoration: InputDecoration(
                            hintText: "Email",
                            errorStyle: TextStyle(
                                fontSize: SizeConfig.safeBlockVertical * 2),
                            helperText: "",
                            helperStyle: TextStyle(
                                fontSize: SizeConfig.safeBlockVertical * 2),
                            prefixIcon: const Icon(
                              Icons.email,
                            ),
                          ),
                          maxLines: 1,
                          validator: (value) {
                            //ensures that email is valid
                            return _validate.validateEmail(value);
                          },
                          onChanged: (value) {
                            //everytime user changes value --> updates variable
                            setState(() => _email = value.trim().toLowerCase());
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 2,
                        child: Text(
                          _error,
                          style: TextStyle(
                            color: Colors.red[800],
                            fontSize: SizeConfig.safeBlockVertical * 2,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 4,
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 6,
                        child: ElevatedButton(
                          child: TextDefault(
                            color: Colors.white,
                            sizeMultiplier: 2.5,
                            text: "Send reset link",
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue[500],
                              fixedSize: Size(SizeConfig.safeBlockHorizontal * 100,
                                  SizeConfig.safeBlockVertical * 6)),
                          onPressed: () {
                            //resets error text on click
                            if (!_globalKey.currentState!.validate()) {
                              setState(() {
                                _error = "";
                              });
                              return;
                            }
                            if (canSendResetLink) {
                              sendLink();
                            } else {
                              dialog.showCustomDialogBox(
                                  "Link has already been sent. Try again in 1 minute.",
                                  context);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 4,
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 6,
                        child: TextButton(
                          child: TextDefault(
                            text: "Click here to go back",
                            color: Colors.black,
                            sizeMultiplier: 2.5,
                            decoration: TextDecoration.underline,
                            bold: FontWeight.bold,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
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
