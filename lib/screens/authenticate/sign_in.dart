// ignore_for_file: prefer_const_constructors
//purpose: sign In page UI
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sklps_app/screens/authenticate/register.dart';
import 'package:sklps_app/screens/authenticate/reset_password.dart';
import 'package:sklps_app/screens/support.dart';
import 'package:sklps_app/services/auth.dart';
import 'package:sklps_app/shared/constants.dart';
import 'package:sklps_app/shared/size_config.dart';
import 'package:sklps_app/shared/text_filed_validation.dart';

import '../../services/error_handling.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //helps control flow between SignIn and Register page
  void changeShowSignIn() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  //keeps track of whether show SignIn or Register page
  bool showSignIn = true;

  //stores user entered info from textFormField or error messages
  String _email = "";
  String _password = "";
  String _error = "";

  //controls state of textFormFields and their validation
  final TextFieldValidation _validate = TextFieldValidation();
  final _globalKey = GlobalKey<FormState>();

  //access to methods to return error strings
  ErrorHandling errorHandle = ErrorHandling();

  //whether show or hide password
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //on change of var --> go to Register page
    if (!showSignIn) {
      return Register();
    }
    final authService = Provider.of<AuthService>(context);

    return Material(
      child: SafeArea(
        bottom: false,
        //Padding wraps around entire screen
        child: Container(
          height: SizeConfig.safeBlockVertical * 100,
          width: SizeConfig.safeBlockHorizontal * 100,
          decoration: boxDecorationBackground,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                SizeConfig.safeBlockHorizontal * 5,
                SizeConfig.safeBlockVertical * 2,
                SizeConfig.safeBlockHorizontal * 5,
                SizeConfig.safeBlockVertical * 2),
            //Form connects all TextFormFields
            child: Form(
              key: _globalKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 35,
                      child: Image.asset(
                        'assets/images/sklps_logo.png',
                        width: SizeConfig.safeBlockVertical * 35,
                        height: SizeConfig.safeBlockVertical * 35,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 5,
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 9.5,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical * 2.5),
                        decoration: InputDecoration(
                          hintText: "Email",
                          //for text below TextFormField
                          errorStyle: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 2),
                          helperText: "",
                          helperStyle: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 2),
                          prefixIcon: SizedBox(
                            height: SizeConfig.safeBlockVertical * 2.5,
                            width: SizeConfig.safeBlockVertical * 2.5,
                            child: Icon(
                              Icons.email,
                            ),
                          ),
                        ),
                        maxLines: 1,
                        validator: (value) {
                          //checks if user entered email is valid
                          return _validate.validateEmail(value?.trim());
                        },
                        onChanged: (value) {
                          //everytime user changes TextFormField --> value of email is updated
                          setState(() => _email = value.trim().toLowerCase());
                        },
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 9.5,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical * 2.5),
                        decoration: InputDecoration(
                            hintText: "Password",
                            errorStyle: TextStyle(
                                fontSize: SizeConfig.safeBlockVertical * 2),
                            helperText: "",
                            helperStyle: TextStyle(
                                fontSize: SizeConfig.safeBlockVertical * 2),
                            prefixIcon: SizedBox(
                              height: SizeConfig.safeBlockVertical * 2.5,
                              width: SizeConfig.safeBlockVertical * 2.5,
                              child: Icon(
                                Icons.lock,
                              ),
                            ),
                            //IconButton determines whether password is hidden or not
                            suffixIcon: IconButton(
                              //changes eye icon based on whether password is hidden or not
                              icon: Icon(_obscurePassword
                                  ? Icons.remove_red_eye
                                  : Icons.remove_red_eye_outlined,
                              size: SizeConfig.safeBlockVertical * 2.5,),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            )),
                        obscureText: _obscurePassword,
                        maxLines: 1,
                        validator: (value) {
                          //checks whether user entered password is valid
                          return _validate.validatePassword(value?.trim());
                        },
                        onChanged: (value) {
                          //everytime TextFormField is changed --> update the value of password
                          setState(() => _password = value.trim());
                        },
                      ),
                    ),

                    //Text displays error message based on results of auth.signIn
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 2,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          _error,
                          style: TextStyle(
                            color: Colors.red[800],
                            fontSize: SizeConfig.safeBlockVertical * 1.7,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 3,
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 6,
                      child: ElevatedButton(
                        child: TextDefault(
                          color: Colors.white,
                          sizeMultiplier: 2.5,
                          text: "Sign In",
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[1000],
                          shadowColor: Colors.black12,
                          fixedSize: Size(SizeConfig.safeBlockHorizontal * 30,
                              SizeConfig.safeBlockVertical * 6),
                          textStyle: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical * 2.5,
                          ),
                        ),
                        onPressed: () async {
                          //if validate is not true --> reset error because shows errorText under TextFormField
                          if (!_globalKey.currentState!.validate()) {
                            //referenced https://codewithandrea.com/articles/flutter-text-field-form-validation/ for textformfieldvalidation
                            setState(() {
                              _error = "";
                            });
                            return;
                          }
                          //if validate is true --> sign in method
                          try {
                            await authService.signInWithEmailAndPassword(
                                _email, _password);
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              //sets error to error string returned by error handler
                              _error = errorHandle.errorHandling(e.code);
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 6,
                      width: SizeConfig.safeBlockHorizontal * 100,
                      child: TextButton(
                        child: TextDefault(
                          text: "Forgot Password?",
                          sizeMultiplier: 2,
                          color: Colors.blue[700]!,
                          bold: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        onPressed: () {
                          //reveals pop up to forget password screen
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ResetPasswordScreen()));
                        },
                        style: TextButton.styleFrom(
                          fixedSize: Size(SizeConfig.safeBlockHorizontal * 30,
                              SizeConfig.safeBlockVertical * 6),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 6,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextDefault(
                              text: "Don't have an account?",
                              color: Colors.black,
                              sizeMultiplier: 2,
                            ),
                            //Navigates to register Page on click by resetting state
                            TextButton(
                              child: TextDefault(
                                text: "Register",
                                color: Colors.black,
                                sizeMultiplier: 2,
                                bold: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              style: TextButton.styleFrom(
                                fixedSize: Size(SizeConfig.safeBlockHorizontal * 20,
                                    SizeConfig.safeBlockVertical * 6),
                                textStyle: TextStyle(
                                  fontSize: SizeConfig.safeBlockVertical * 2.5,
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                              onPressed: () {
                                changeShowSignIn();
                              },
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 5,
                      width: SizeConfig.safeBlockHorizontal * 100,
                    ),
                    //Positioning for support page button
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 8,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          child: Icon(
                            FontAwesomeIcons.circleQuestion,
                            size: SizeConfig.safeBlockVertical * 4,
                          ),
                          backgroundColor: Colors.blue[1000],
                          onPressed: () {
                            //calls Support Page pop out
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Support(
                                      dialogBox: false,
                                      signOutButton: false,
                                    )));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),//
          ),
        ),
      ),
    );
  }
}
