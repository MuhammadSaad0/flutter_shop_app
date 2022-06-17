import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  @override
  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return CircularProgressIndicator();
    },
  );
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: spinkit,
      ),
    );
  }
}
