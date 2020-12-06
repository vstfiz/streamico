import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamico/dashboard.dart';
import 'package:streamico/globals.dart' as globals;
import 'package:streamico/notifications.dart';
import 'package:streamico/responsiveui.dart';
import 'package:streamico/sign_up.dart';
import 'package:streamico/size_config.dart';
import 'package:streamico/welcome.dart';
import 'package:streamico/firebase_database.dart' as fdb;
import 'fire_auth.dart';
import 'login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Phoenix(child: MyApp()));
}

bool firstRun = true;
bool userValue;
User user;

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    globals.cont = context;
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            FirebaseAuth auth = FirebaseAuth.instance;
            return MaterialApp(
              title: 'Streamico',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: StreamBuilder(
                stream: auth.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    user = snapshot.data;
                    globals.user.email = user.email;
                    globals.user.dp = user.photoURL;
                    globals.user.uid = user.uid;
                    globals.user.name = user.displayName;
                  }
                  return SplashScreen();
                },
              ),
            );
          },
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    print(auth.currentUser.toString());
    getDarkMode();
    _handleCameraAndMic();
    getFirstRun();
    startTime();
  }

  getDarkMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    globals.darkModeOn = sharedPreferences.getBool("darkMode");
    if (globals.darkModeOn == null) {
      globals.darkModeOn = false;
    }
  }

  getFirstRun() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    firstRun = sharedPreferences.getBool("firstRun");
    if (firstRun == null) {
      firstRun = true;
    }
  }
  
   _handleCameraAndMic() async {
    await [Permission.camera,Permission.microphone].request();
  }

  startTime() async {
    return new Timer(new Duration(milliseconds: 3950), navigator);
  }

  navigator() {
    if (firstRun) {
      print("1");
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {

        return WelcomeScreen();
        print("1");
      }));
    }
    else {
      if (globals.user.email != null && globals.user.email != "") {
        print('2');
        fdb.FirebaseDB.getUserDetails(globals.user.uid, context,globals.user.email);
        print(globals.user.email);

      }
      else {
        print('3');
        print('asfsedf'+globals.user.email+"\t\t\t\t\t"+globals.user.uid);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SignUp();
        }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.darkModeOn ? Colors.black : Colors.white,
      body: ResponsiveWidget(
        portraitLayout: globals.darkModeOn
            ? portraitStackDark(context)
            : portraitStackLight(context),
        webLayout: globals.darkModeOn
            ? WebStackDark(context)
            : WebStackLight(context),
      ),
    );
  }

  Widget portraitStackLight(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 250,
            width: 180,
            child: Image.asset('assets/v1.png'),
          ),
        ),
        Positioned(
          top: 630,
          left: 45,
          child: SizedBox(
            width: 340.0,
            child: TyperAnimatedTextKit(
                speed: new Duration(milliseconds: 350),
                text: [
                  "Streamico",
                ],
                textStyle: TextStyle(
                    fontSize: 40.0,
                    fontFamily: "Aquire",
                    color: Colors.black,
                    letterSpacing: 10
                ),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional
                    .topStart // or Alignment.topLeft
            ),
          ),
        ),
      ],
    );
  }

  Widget portraitStackDark(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 250,
            width: 180,
            child: Image.asset('assets/v2.png'),
          ),
        ),
        Positioned(
          top: 630,
          left: 45,
          child: SizedBox(
            width: 340.0,
            child: TyperAnimatedTextKit(
                speed: new Duration(milliseconds: 350),
                text: [
                  "Streamico",
                ],
                textStyle: TextStyle(
                    fontSize: 40.0,
                    fontFamily: "Aquire",
                    color: Colors.white,
                    letterSpacing: 10
                ),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional
                    .topStart // or Alignment.topLeft
            ),
          ),
        ),
      ],
    );
  }

  Widget WebStackLight(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 50,
          left: 330,
          child: SizedBox(
            height: 180,
            width: 250,
            child: Image.asset('assets/v2.png'),
          ),
        ),
        Positioned(
          top: 300,
          left: 300,
          child: SizedBox(
            width: 340.0,
            child: TyperAnimatedTextKit(
                speed: new Duration(milliseconds: 350),
                text: [
                  "Varithms",
                ],
                textStyle: TextStyle(
                    fontSize: 60.0,
                    fontFamily: "Aquire",
                    color: Colors.white,
                    letterSpacing: 10
                ),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional
                    .topStart // or Alignment.topLeft
            ),
          ),
        ),
      ],
    );
  }

  Widget WebStackDark(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 50,
          left: 330,
          child: SizedBox(
            height: 180,
            width: 250,
            child: Image.asset('assets/v2.png'),
          ),
        ),
        Positioned(
          top: 300,
          left: 300,
          child: SizedBox(
            width: 340.0,
            child: TyperAnimatedTextKit(
                speed: new Duration(milliseconds: 350),
                text: [
                  "Varithms",
                ],
                textStyle: TextStyle(
                    fontSize: 60.0,
                    fontFamily: "Aquire",
                    color: Colors.white,
                    letterSpacing: 10
                ),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional
                    .topStart // or Alignment.topLeft
            ),
          ),
        ),
      ],
    );
  }
}
