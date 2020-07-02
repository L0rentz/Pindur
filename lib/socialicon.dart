import 'package:flutter/material.dart';

class SocialIcon extends StatelessWidget {
  final String iconname;
  SocialIcon({this.iconname});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(iconname),
      width: 40,
      height: 40,
    );
  }
}