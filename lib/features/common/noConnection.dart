import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'No Internet Connection',
          style: TextStyle(fontSize: 24, color: Colors.red),
        ),
      ),
    );
  }
}
