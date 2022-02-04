import 'package:data_transfer/main.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(

      splash: 'logo.png',
      duration: 2000,
      backgroundColor: Colors.amber,
      splashTransition: SplashTransition.rotationTransition,
      nextScreen: const MyHomePage(title: 'Title bea',),

    );
  }
}
