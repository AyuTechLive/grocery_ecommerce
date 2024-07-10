import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:hakeekat_farmer_version/Auth/login.dart';
import 'package:hakeekat_farmer_version/Home/Homepage.dart';
import 'package:hakeekat_farmer_version/Home/MainPage.dart';

class SplashServices {
  void isLogin(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    // Check for an internet connection before proceeding

    if (user != null) {
      Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        ),
      );
    } else {
      Timer(
        const Duration(seconds: 4),
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ),
      );
    }
  }
}
