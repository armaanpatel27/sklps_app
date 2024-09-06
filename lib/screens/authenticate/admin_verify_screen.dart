import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sklps_app/screens/home/admin/admin_home_wrapper.dart';
import 'package:sklps_app/screens/home/normal/home_wrapper.dart';
import 'package:sklps_app/services/auth.dart';
import 'package:sklps_app/services/verify_user.dart';
import 'package:sklps_app/screens/error_screen.dart';
import '../../shared/constants.dart';

//if true --> returns adminHomeWrapper
//if false --> returns homeWrapper
class AdminVerifyScreen extends StatefulWidget {
  const AdminVerifyScreen({Key? key}) : super(key: key);

  @override
  State<AdminVerifyScreen> createState() => _AdminVerifyScreenState();
}

class _AdminVerifyScreenState extends State<AdminVerifyScreen> {
  //returns true if user is admin
  //returns false if user is not admin
  Future<bool?> verifyAdmin() {
    return VerifyUser().isAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationBackground,
      child: FutureBuilder(
        future: verifyAdmin(),
        builder: (context, snapshot) {
          //if data is completely loaded
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return ErrorScreen(errorCode: "Error 1009");
            } else if (snapshot.hasData) {
              final data = snapshot.data;
              if (data == true) {
                //if isAdmin returns true --> admin home screen
                return AdminHomeWrapper();
              } else {
                //otherwise --> home wrapper
                return HomeWrapper();
              }
            } else {
              //if there is another error
              return ErrorScreen(errorCode: "Error 1010");
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            //if still loading data
            return LoadingWheel();
          } else {
            //unknown error
            return ErrorScreen(errorCode: "Error 1011");
          }
        },
      ),
    );
  }
}
