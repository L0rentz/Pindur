import 'main.dart';
import 'package:flutter/material.dart';
import 'textformfield.dart';
import 'package:intl/intl.dart';
import 'api.dart';
import 'blurrydialog.dart';
import 'greywhitegradient.dart';

class SignUp extends StatefulWidget {
  final firstnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatController = TextEditingController();
  final birthdateController = TextEditingController();
  final f1 = DateFormat('MMM dd, yyyy');
  final f2 = DateFormat('y-MM-dd');
  final f5 = DateFormat('y');
  final f4 = DateFormat('MM');
  final f6 = DateFormat('dd');
  final _formKey = GlobalKey<FormState>();

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final homepage = LoginPageState();
  DateTime selectedDate = DateTime.now();
  bool checkboxvalue = false;
  Color dropdowncolor = Color.fromARGB(255, 150, 150, 150);
  String dropdownvalue = '---------------';
  bool agreed = false;
  String errormsg = '';
  bool picked = false;
  bool _showPassword = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        flexibleSpace: Transform.translate(
          offset: Offset(0.0, 680.0),
          child: Transform.scale(
            scale: 0.6,
            child: Image.asset('assets/images/pindur.png'),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Transform.scale(
                scale: 1.3,
                child: Container(child: Icon(Icons.keyboard_return)))),
        backgroundColor: Colors.white,
        title: Text('Sign up',
            style: TextStyle(color: Colors.black, fontSize: 22)),
        centerTitle: true,
      ),
      body: Stack(children: [
        GreyWhiteGradient(),
        Opacity(
          opacity: 0.2,
          child: Image.asset('assets/images/greenwave.png',
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.12),
        ),
        Center(
            heightFactor: 16,
            child: Text(
              errormsg,
              style: TextStyle(color: Color.fromARGB(255, 220, 0, 0)),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.60,
          padding: EdgeInsets.fromLTRB(50.0, 150.0, 40.0, 0),
          child: Scrollbar(
            child: Form(
              key: widget._formKey,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0),
                      child: MyTextFormField(
                          showpassword: false,
                          hintname: 'First name',
                          controller: widget.firstnameController,
                          errormsg: 'First name required')),
                  SizedBox(height: 20.0),
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(240, 0, 0, 0),
                        child: IconButton(
                            onPressed: () {},
                            color: Color.fromARGB(255, 140, 140, 140),
                            icon: Icon(Icons.date_range)),
                      ),
                      InkWell(
                        onTap: () async {
                          selectedDate = await selectDate(context);
                          setState(() {
                            picked = true;
                            widget.birthdateController.text =
                                widget.f1.format(selectedDate).toString();
                          });
                        },
                        child: IgnorePointer(
                          child: Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: MyTextFormField(
                                showpassword: false,
                                hintname: 'Birth date',
                                controller: widget.birthdateController,
                                errormsg: 'Birth date required',
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  genreSelector(),
                  SizedBox(height: 10.0),
                  Container(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0),
                      child: MyTextFormField(
                        showpassword: false,
                        hintname: 'Email',
                        controller: widget.emailController,
                        errormsg: 'Email required',
                      )),
                  SizedBox(height: 20.0),
                  Container(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0),
                      child: Stack(children: [
                        MyTextFormField(
                          showpassword: !_showPassword,
                          hintname: 'Password',
                          controller: widget.passwordController,
                          errormsg: 'Password required',
                        ),
                        Transform.translate(
                          offset: Offset(
                              MediaQuery.of(context).size.width * 0.62, 0.0),
                          child: IconButton(
                            onPressed: () {
                              setState(() => _showPassword = !_showPassword);
                            },
                            icon: Icon(Icons.remove_red_eye),
                            color: homepage.getColor(_showPassword),
                          ),
                        ),
                      ])),
                  SizedBox(height: 20.0),
                  Container(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0),
                      child: MyTextFormField(
                          showpassword: !_showPassword,
                          controller: widget.repeatController,
                          hintname: 'Repeat password',
                          errormsg: 'Password required')),
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Text('Agree to '),
                      Text('Terms & Conditions',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).hintColor)),
                      SizedBox(width: 60.0),
                      Checkbox(
                          value: checkboxvalue,
                          onChanged: (bool value) {
                            setState(() {
                              checkboxvalue = value;
                            });
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 50.0),
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.1, 515, 0, 0),
              child: FlatButton(
                onPressed: () async {
                  setState(() {
                    dropdowncolor = Color.fromARGB(255, 150, 150, 150);
                    errormsg = '';
                  });
                  agreed = checkboxreturn();
                  bool validemail = RegExp(
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                      .hasMatch(widget.emailController.text);
                  var age = 0;
                  var monthoffset = 0;
                  var dayoffset = 0;
                  if (picked == true) {
                    age =
                        int.parse(widget.f5.format(DateTime.now()).toString()) -
                            int.parse(widget.f5.format(selectedDate));
                    monthoffset =
                        int.parse(widget.f4.format(DateTime.now()).toString()) -
                            int.parse(widget.f4.format(selectedDate));
                    dayoffset = int.parse(widget.f6.format(selectedDate)) -
                        int.parse(widget.f6.format(DateTime.now()).toString());
                  }
                  if ((monthoffset < 0) || (monthoffset == 0 && dayoffset > 0))
                    age--;
                  print(age);
                  if (widget._formKey.currentState.validate() &&
                      (widget.repeatController.text ==
                          widget.passwordController.text) &&
                      widget.passwordController.text.length > 5 &&
                      validemail == true &&
                      agreed == false &&
                      dropdownvalue != '---------------' &&
                      age >= 18) {
                    showBlurryDialog(context);
                  } else if (widget.repeatController.text !=
                      widget.passwordController.text) {
                    setState(() {
                      errormsg = 'Passwords don\'t match';
                    });
                  } else if (widget.passwordController.text.length < 6) {
                    setState(() {
                      errormsg =
                          'The password must contain at least 6 characters';
                    });
                  } else if (validemail == false) {
                    setState(() {
                      errormsg = 'Invalid email';
                    });
                  } else if (dropdownvalue == '---------------') {
                    setState(() {
                      dropdowncolor = Color.fromARGB(255, 175, 0, 0);
                      errormsg = 'Please fill the dropdown menu';
                    });
                  } else if (age < 18) {
                    setState(() {
                      errormsg = 'You must be over the age of 18';
                    });
                  }
                },
                color: Theme.of(context).textSelectionColor,
                child: Text('Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16.0)),
              ),
            ),
            if (agreed == true)
              Container(
                  margin: EdgeInsets.fromLTRB(40, 10, 0, 0),
                  child: Text('Please agree to the Terms & Conditions',
                      style: TextStyle(color: Color.fromARGB(255, 175, 0, 0)))),
          ],
        ),
      ]),
    );
  }

  Widget genreSelector() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: DropdownButton(
          underline:
              Container(color: Color.fromARGB(255, 125, 125, 125), height: 1),
          value: dropdownvalue,
          icon: Transform.translate(
              offset: Offset(85, 0),
              child: Icon(Icons.arrow_drop_down, color: dropdowncolor)),
          items: <String>[
            '---------------',
            'Woman',
            'Man',
            'Agender',
            'Androgyne',
            'Androgynous',
            'Bigender',
            'Female to Male',
            'Male to Female',
            'Gender Fluid',
            'Gender Nonconforming',
            'Gender Questioning',
            'Gender Variant',
            'Nonbinary',
            'Neutrois',
            'Pangender',
            'Transgender',
            'Transfeminine',
            'Other'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String newValue) {
            setState(() {
              dropdownvalue = newValue;
            });
          }),
    );
  }

  Future<DateTime> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2021));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    return (selectedDate);
  }

  @override
  void dispose() {
    widget.emailController.dispose();
    widget.passwordController.dispose();
    widget.firstnameController.dispose();
    widget.repeatController.dispose();
    widget.birthdateController.dispose();
    super.dispose();
  }

  bool checkboxreturn() {
    if (checkboxvalue == false) {
      setState(() {
        agreed = true;
      });
    } else {
      setState(() {
        agreed = false;
      });
    }
    return agreed;
  }

  showBlurryDialog(BuildContext context) {
    var email = widget.emailController.text;
    var password = widget.passwordController.text;
    var firstname = widget.firstnameController.text;
    var birthdate = widget.f2.format(selectedDate).toString();
    var gender = dropdownvalue;
    var rsp;
    VoidCallback continueCallBack = () async => {
          rsp = await createUser(email, password, firstname, birthdate, gender),
          if (rsp != null && rsp.containsKey('status'))
            {
              if (rsp['status'] == 1)
                {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (r) => false,
                      arguments: rsp['user_arr']),
                }
              else if (rsp['status'] == 3 ||
                  rsp['status'] == 2 ||
                  rsp['status'] == 0)
                {
                  setState(() {
                    errormsg = rsp['status_text'];
                  }),
                  Navigator.of(context).pop(),
                },
            }
          else
            {
              Navigator.of(context).pop(),
              setState(() {
                BlurryError alert = BlurryError('Error',
                    'There was an error creating your profile.\nPlease try again.');
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    });
              }),
            },
        };

    BlurryDialog alert = BlurryDialog("Confirmation",
        "Confirm your inscription with these information?", continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
