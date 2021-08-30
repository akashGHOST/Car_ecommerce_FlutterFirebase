import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_car/authenticationScreen.dart';

import 'homeScreen.dart';
import 'dart:io' show Platform;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  startTimer(){
    Timer(Duration(seconds: 3), ()  {
       if ( FirebaseAuth.instance.currentUser != null ) {
        Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      }
      else {
        Route newRoute = MaterialPageRoute(builder: (context) => AuthenticationScreen());
        Navigator.pushReplacement(context, newRoute);
      }
    });
  }

  @override
  void initState(){
    super.initState();
    startTimer();
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors:[Colors.blueAccent, Colors.redAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('images/logo.png'),
              ),
              SizedBox(height: 20.0),
              Text(
                'GHOST',
                style: TextStyle(
                  fontSize: Platform.isAndroid || Platform.isIOS ? 20.0 : 60.0,
                  color: Colors.white,
                  fontFamily: 'Lobster'
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
