// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sklps_app/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sklps_app/services/wrapper.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //sets orientation of app to portrait mode
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        //manages auth data around application
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),

      ],
      //unfocus keyboard when tap anywhere else
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: MaterialApp(


          //On initialization, app directly navigates to Wrapper which shows different screen
          //based on whether user is authenticated
          home: Wrapper(),
          debugShowCheckedModeBanner: false,

        ),
      ),
    );
  }
}
