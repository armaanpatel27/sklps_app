// ignore_for_file: prefer_const_constructors
//purpose: checks authentication state and switches between sign in page or home page at any moment
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sklps_app/screens/authenticate/register.dart';
import 'package:sklps_app/models/User.dart';
import 'package:sklps_app/screens/authenticate/sign_in.dart';
import 'package:sklps_app/screens/home/normal/home_wrapper.dart';
import 'package:sklps_app/screens/authenticate/verify_screen.dart';
import 'package:sklps_app/services/auth.dart';
import 'package:sklps_app/shared/constants.dart';
import 'package:sklps_app/screens/error_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //provides access authentication state of application
    final authService = Provider.of<AuthService>(context);

    //StreamBuilder returns anytime there is a change in state of authentication
    return StreamBuilder<User?>(
        //detects change in user from Firebase Authentication
        stream: authService.user,
        builder: (_, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;

            //if user doesn't exist --> not authenticated --> SignIn screen
            //if user exists --> authenticated --> check if email is verified
            return user == null ? SignIn() : VerifyScreen();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWheel();
          } else {
            return ErrorScreen(
                errorCode:
                    "OOPS! Looks like something went wrong. Check your internet "
                    "connection and try again. Error #1000");
          }
        });
  }
}
