import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Loading1 extends StatelessWidget {
  const Loading1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: SpinKitFadingCircle(
        color: Theme.of(context).textSelectionColor,
        size: 50.0,
      )),
    );
  }
}
