import 'package:flutter/material.dart';

class GreyWhiteGradient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.45,
              1.0,
            ],
            colors: [
              Colors.white,
              Colors.grey,
            ]),
      ),
    );
  }
}