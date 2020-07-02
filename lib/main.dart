import 'package:pindur/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'textformfield.dart';
import 'api.dart';
import 'homepage.dart';
import 'greywhitegradient.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
      },
      title: 'Pindur',
      theme: ThemeData(
        colorScheme: ColorScheme(
          primaryVariant: Color.fromARGB(150, 40, 175, 40),
          onError: Colors.red,
          secondary: Color.fromARGB(150, 40, 175, 40),
          primary: Color.fromARGB(150, 40, 175, 40),
          onSurface: Colors.black,
          onSecondary: Color.fromARGB(150, 40, 175, 40),
          brightness: Brightness.light,
          background: Colors.white,
          surface: Colors.black,
          onPrimary: Colors.white,
          secondaryVariant: Colors.black,
          onBackground: Colors.black,
          error: Colors.red,
        ),
        hintColor: Color.fromARGB(255, 40, 175, 40),
        cursorColor: Colors.black,
        textSelectionColor: Color.fromARGB(150, 40, 175, 40),
        textSelectionHandleColor: Color.fromARGB(255, 40, 175, 40),
        accentColor: Color.fromARGB(255, 40, 40, 40),
        primaryColorDark: Colors.grey,
        primaryColor: Color.fromARGB(255, 40, 40, 40),
        splashColor: Colors.grey,
        cardColor: Color.fromARGB(150, 40, 175, 40),
        highlightColor: Colors.grey,
        backgroundColor: Color.fromARGB(150, 40, 175, 40),
        secondaryHeaderColor: Colors.grey,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(title: 'Pindur'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({this.title});
  final String title;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String firstname;
  String message = '';
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        GreyWhiteGradient(),
        Transform.scale(
          scale: 0.5,
          child: Image.asset(
            'assets/images/pindur.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.55,
          ),
        ),
        Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 400, 0, 0),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Form(
              key: _formKey,
              child: Column(children: [
                MyTextFormField(
                  controller: emailController,
                  errormsg: 'Email required',
                  hintname: 'Email',
                  showpassword: false,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                ),
                Stack(
                  children: [
                    MyTextFormField(
                      controller: passwordController,
                      errormsg: 'Password required',
                      hintname: 'Password',
                      showpassword: !_showPassword,
                    ),
                    Transform.translate(
                      offset:
                          Offset(MediaQuery.of(context).size.width * 0.68, 0.0),
                      child: IconButton(
                        onPressed: () {
                          setState(() => _showPassword = !_showPassword);
                        },
                        icon: Icon(Icons.remove_red_eye),
                        color: getColor(_showPassword),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  FlatButton(
                    onPressed: () async {
                      setState(() {
                        message = message = '';
                      });
                      if (_formKey.currentState.validate()) {
                        var email = emailController.text;
                        var password = passwordController.text;
                        var rsp = await loginUser(email, password);
                        if (rsp.containsKey('status')) {
                          if (rsp['status'] == 1) {
                            Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false, arguments: rsp['user_arr']);
                          } else {
                            setState(() {
                              message = rsp['status_text'];
                            });
                          }
                        }
                      }
                    },
                    color: Theme.of(context).textSelectionColor,
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.33),
                  FlatButton(
                    child: Column(
                      children: [
                        Text(
                          'New user?',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Welcome();
                      }));
                    },
                  ),
                ]),
              ]),
            ),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.40,
          top: 552,
          child: Text(
            message,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ]),
    );
  }

  Color getColor(bool _showPassword) {
    if (_showPassword == true)
      return Color.fromARGB(255, 0, 0, 0);
    else
      return Color.fromARGB(255, 150, 150, 150);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}