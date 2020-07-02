import 'package:flutter/material.dart';
import 'signup.dart';
import 'greywhitegradient.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GreyWhiteGradient(),
        Transform.translate(
            offset: Offset(5, 40),
            child: Transform.scale(
                scale: 1.4,
                child: IconButton(
                    icon: Icon(Icons.keyboard_return),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Color.fromARGB(175, 210, 210, 210)))),
        Transform.translate(
          offset: Offset(0, -50),
          child: Container(
            child: Column(children: [
              Transform.translate(
                  offset: Offset(0, 70),
                  child: Transform.scale(
                      scale: 0.25,
                      child: Image.asset('assets/images/pindur2.png'))),
              Text('Welcome to Pindur.',
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 125, 125, 125))),
              SizedBox(height: 10),
              Text('Please follow these House Rules.',
                  style: TextStyle(
                      letterSpacing: 1,
                      color: Color.fromARGB(255, 125, 125, 125))),
              SizedBox(height: 50),
              Transform.translate(
                  offset: Offset(-140, 0),
                  child: Icon(Icons.check,
                      color: Theme.of(context).hintColor, size: 30)),
              Transform.translate(
                  offset: Offset(-55, -25),
                  child: Text('Be yourself.',
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 125, 125, 125)))),
              Transform.translate(
                  offset: Offset(-20, -15),
                  child: Text(
                      'Make sure your photos, age, and bio are\ntrue to who you are.',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 125, 125, 125)))),
              SizedBox(height: 10),
              Transform.translate(
                  offset: Offset(-140, 0),
                  child: Icon(Icons.check,
                      color: Theme.of(context).hintColor, size: 30)),
              Transform.translate(
                  offset: Offset(-65, -25),
                  child: Text('Stay safe.',
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 125, 125, 125)))),
              Transform.translate(
                  offset: Offset(-28, -15),
                  child: Text(
                      'Don\'t be to quick to give out personal\ninformation.',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 125, 125, 125)))),
              Transform.translate(
                  offset: Offset(-25, -33),
                  child: Text('Date Safely',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).hintColor,
                          decoration: TextDecoration.underline))),
              Transform.translate(
                  offset: Offset(-140, 0),
                  child: Icon(Icons.check,
                      color: Theme.of(context).hintColor, size: 30)),
              Transform.translate(
                  offset: Offset(-57, -25),
                  child: Text('Play it cool.',
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 125, 125, 125)))),
              Transform.translate(
                  offset: Offset(-25, -15),
                  child: Text(
                      'Respect others and treat them as you\nwould like to be treated.',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 125, 125, 125)))),
              SizedBox(height: 10),
              Transform.translate(
                  offset: Offset(-140, 0),
                  child: Icon(Icons.check,
                      color: Theme.of(context).hintColor, size: 30)),
              Transform.translate(
                  offset: Offset(-52, -25),
                  child: Text('Be proactive.',
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 125, 125, 125)))),
              Transform.translate(
                  offset: Offset(-56, -15),
                  child: Text('Always report bad behavior.',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 125, 125, 125)))),
              SizedBox(height: 55),
              Container(
                  width: 300,
                  height: 45,
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Text('I AGREE',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return SignUp();
                        }));
                      },
                      color: Theme.of(context).textSelectionColor)),
            ]),
          ),
        ),
      ]),
    );
  }
}