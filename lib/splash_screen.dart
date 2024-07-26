import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:online_job_portal/helpers/api_helper.dart';
//screens
import 'employeer/em_home.dart';
import 'jobseeker/js_home.dart';
import 'auth/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Image(image: AssetImage('assets/images/img_2.png')),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    checkIfAuthenticated();
    super.initState();
  }

  void checkIfAuthenticated() async {
    Navigator.of(context).popUntil((route) => route.isFirst);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('user_id') != null && prefs.getString('type') != null) {
      if (prefs.getString('type') == "jobseeker") {
        _jsAccountVerification(context);
      } else if (prefs.getString('type') == "employeer") {
        _emAccountVerification(context); 
      } else {
        // Force logout
        prefs.clear();
        // Redirect to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } else {
      // Redirect to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future<void> _jsAccountVerification(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getInt('user_id');

    // Skip verification check and navigate directly to jobseeker home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => JHomeScreen()),
    );
  }

  Future<void> _emAccountVerification(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getInt('user_id');

    // Skip verification check and navigate directly to employer home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EHomeScreen()),
    );
  }
}