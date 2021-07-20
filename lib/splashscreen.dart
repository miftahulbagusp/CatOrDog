import 'package:cat_dog_classifier/home.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplash extends StatefulWidget {
  const MySplash({Key? key}) : super(key: key);

  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: Home(),
      title: Text('Cat and Dog Classifier', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Color(0x00FFF))),
      image: Image.asset("assets/cat_dog_icon.png"),
      backgroundColor: Color(0xff222f3e),
      photoSize: 60,
      loaderColor: Color(0xffc8d6e5),
    );
  }
}
