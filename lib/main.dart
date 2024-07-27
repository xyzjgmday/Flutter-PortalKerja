import 'package:online_job_portal/state_util.dart';
import 'package:online_job_portal/core.dart';
import 'package:flutter/material.dart';
//screens
import 'splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
navigatorKey: Get.navigatorKey,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        primaryColor: const Color(0xff002651),
        hintColor: const Color(0xffff304f),
      ),
      home: const SplashScreen(),
    );
  }
}
