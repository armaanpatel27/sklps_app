import 'package:flutter/material.dart';
import 'package:sklps_app/screens/authenticate/sign_in.dart';
import 'package:sklps_app/services/wrapper.dart';
import 'package:sklps_app/screens/error_screen.dart';

import '../models/User.dart';
import 'constants.dart';
class FutureBuilderClass extends StatefulWidget {
  Future theFunction;
   FutureBuilderClass({Key? key, required this.theFunction}) : super(key: key);

  @override
  State<FutureBuilderClass> createState() => _FutureBuilderClassState();
}

class _FutureBuilderClassState extends State<FutureBuilderClass> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.theFunction,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if (snapshot.hasError) {
            return ErrorScreen(errorCode: "Error 3301");
          } else if (snapshot.hasData) { //snapshot always created
            final data = snapshot.data;
            if(data == User()){
              return Wrapper();
            }else{
              SignIn();
            }
          } else { //if there is another error
            return ErrorScreen(errorCode: "Error 3301");
          }
        }else if (snapshot.connectionState == ConnectionState.waiting){
          return LoadingWheel();
        }else{
          return ErrorScreen(errorCode: "Error 3301");
        }
        return ErrorScreen(errorCode: "another error");
      }
    );
  }
}
