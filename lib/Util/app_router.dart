
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Presentaion/Auth Screen/auth_screen.dart';
import '../Presentaion/Bottom Nav Screen/bottom_nav_screen.dart';
import '../Presentaion/Splash Screen/splash_screen.dart';
import 'constants.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      double getWidth = MediaQuery.of(context).size.width;
      final mobileScale =
      MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.2);
      final tabScale = MediaQuery.of(context).textScaleFactor.clamp(1.4, 1.6);
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor:
            getWidth > mobileMaxWidth ? tabScale : mobileScale),
        child: Builder(
          builder: (BuildContext context) {
            // return SizedBox();
            switch (settings.name) {
              case '/':
                return const SplashScreen();
              case '/auth':
                return const AuthScreen();
              case '/bottom_nav':
                return BottomNavScreen();
              default:
                return const Scaffold(
                  body: Center(
                    child: Text(
                      'Check Named Route',
                      style: TextStyle(fontSize: 30, color: Colors.black),
                    ),
                  ),
                );
            }
          },
        ),
      );
    });
  }
}
