import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'gallery.dart';
import 'editinfo.dart';

class HomePage extends StatefulWidget {
  final f2 = DateFormat('y');
  final f1 = DateFormat('MM');
  final f3 = DateFormat('dd');
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map result;
  Color profilcolor = Color.fromARGB(150, 40, 175, 40);
  Map user;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        user = ModalRoute.of(context).settings.arguments as Map;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var age = 0;
    var monthoffset = 0;
    var dayoffset = 0;
    if (user != null) {
      age = int.parse(widget.f2.format(DateTime.now()).toString()) -
          int.parse(user['birthdate'].substring(0, 4));
      monthoffset = int.parse(widget.f1.format(DateTime.now()).toString()) -
          int.parse(user['birthdate'].substring(5, 7));
      dayoffset = int.parse(user['birthdate'].substring(8, 10)) -
          int.parse(widget.f3.format(DateTime.now()).toString());
    }
    if (monthoffset <= 0 && dayoffset < 0) age--;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Transform.translate(
            offset: Offset(120, 38),
            child: Transform.scale(
                scale: 1.3,
                child: IconButton(
                    icon: Icon(Icons.exit_to_app),
                    color: Colors.grey,
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (r) => false);
                    }))),
        elevation: 1.0,
        title: Row(
          children: [
            SizedBox(width: 30),
            Transform.scale(
                scale: 1.3,
                child: IconButton(
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    icon: Icon(Icons.person_pin),
                    onPressed: () {
                      setState(() {
                        profilcolor = Theme.of(context).textSelectionColor;
                      });
                    },
                    color: profilcolor)),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(children: [
        Column(
          children: [
            Center(
                heightFactor: 1.1,
                child: Transform.scale(
                    scale: 0.5,
                    child: CircleAvatar(
                      radius: 120,
                      backgroundImage: avatarImage(user),
                      child: avatarText(user),
                    ))),
            Transform.translate(
                offset: Offset(0, -60),
                child: Center(child: nameAge(age, user))),
            Transform.translate(
              offset: Offset(-125, -20),
              child: Column(
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: RawMaterialButton(
                      onPressed: () {},
                      fillColor: Color.fromARGB(255, 242, 242, 242),
                      elevation: 2.0,
                      child: Icon(Icons.settings,
                          size: 20, color: Color.fromARGB(255, 200, 200, 200)),
                      shape: CircleBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('SETTINGS',
                      style:
                          TextStyle(color: Color.fromARGB(255, 180, 180, 180))),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(125, -90),
              child: Column(
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: RawMaterialButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditInfo(argUser: user),
                            )).then((result) {
                          if (result != null) {
                            setState(() {
                              user = result;
                            });
                          }
                        });
                      },
                      fillColor: Color.fromARGB(255, 242, 242, 242),
                      elevation: 2.0,
                      child: Icon(Icons.edit,
                          size: 20, color: Color.fromARGB(255, 200, 200, 200)),
                      shape: CircleBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('EDIT INFOS',
                      style:
                          TextStyle(color: Color.fromARGB(255, 180, 180, 180))),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(0, -155),
              child: Column(
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: RawMaterialButton(
                      onPressed: () async {
                        if (user != null && user['photo9'] == null) {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Gallery(user: user),
                              )).then((result) {
                            if (result != null) {
                              setState(() {
                                user = result;
                              });
                            }
                          });
                        } else {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditInfo(argUser: user),
                              )).then((result) {
                            if (result != null) {
                              setState(() {
                                user = result;
                              });
                            }
                          });
                        }
                      },
                      fillColor: Theme.of(context).textSelectionColor,
                      elevation: 2.0,
                      child: Icon(Icons.photo_camera,
                          size: 20, color: Colors.white),
                      shape: CircleBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('ADD MEDIA',
                      style:
                          TextStyle(color: Color.fromARGB(255, 180, 180, 180))),
                  Transform.translate(
                      offset: Offset(20, -42),
                      child: Transform.scale(
                          scale: 0.8,
                          child: Container(
                              child: Transform.scale(
                                  scale: 0.9,
                                  child: Icon(Icons.add,
                                      color: Theme.of(context).hintColor)),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 5,
                                      blurRadius: 10,
                                      color: Color.fromARGB(125, 100, 100, 100),
                                    )
                                  ],
                                  shape: BoxShape.circle,
                                  color: Colors.white)))),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget nameAge(var age, Map user) {
    if (user != null) {
      return Text(
        '${user['firstname']}, ${age.toString()}',
        style: TextStyle(fontSize: 22),
      );
    } else
      return Text('');
  }

  ImageProvider avatarImage(Map user) {
    if (user != null && user['photo1'] != null) {
      String photo = user['photo1'];
      String address = 'http://192.168.31.37/pindur/$photo';
      return NetworkImage(address);
    } else
      return null;
  }

  Widget avatarText(Map user) {
    if (user != null && user['photo1'] == null)
      return Text('You', style: TextStyle(fontSize: 40));
    else
      return Container(width: 0, height: 0);
  }
}
