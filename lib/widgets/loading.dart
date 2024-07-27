import 'package:flutter/material.dart';

class LoadingLayout extends StatelessWidget {
  const LoadingLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: const CircularProgressIndicator(),),
    );
  }
}