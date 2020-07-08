import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'editinfo.dart';

class UserCard extends StatefulWidget {
  final Map user;
  final f2 = DateFormat('y');
  final f1 = DateFormat('MM');
  final f3 = DateFormat('dd');

  UserCard({this.user});
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  Map user;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        user = widget.user;
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
    if ((monthoffset < 0) || (monthoffset == 0 && dayoffset > 0)) age--;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, user);
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(0, 0),
          child: Container(),
        ),
        body: Stack(children: [
          ListView(children: [
            Transform.translate(
              offset: Offset(0, -20),
              child: Column(children: [
                Stack(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 6.67 / 10,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        enlargeCenterPage: false,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: displayImages(),
                    ),
                    Transform.translate(
                      offset: Offset(MediaQuery.of(context).size.width * 0.78,
                          MediaQuery.of(context).size.height * 0.65),
                      child: Transform.scale(
                        scale: 1.5,
                        child: RawMaterialButton(
                          onPressed: () {
                            Navigator.pop(context, user);
                          },
                          fillColor: Color.fromARGB(255, 90, 175, 90),
                          elevation: 2.0,
                          child: Icon(Icons.arrow_downward,
                              size: 20, color: Colors.white),
                          shape: CircleBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Transform.translate(offset: Offset(15, 0), child: nameAge(age)),
                showJobCompany(),
                showInfos('school', Icons.school),
                showInfos('city', Icons.home),
                showInfos('gender', Icons.person),
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: showAbout()),
                Container(height: 150),
              ]),
            ),
          ]),
          Transform.translate(
            offset: Offset(MediaQuery.of(context).size.width * 0.78,
                MediaQuery.of(context).size.height * 0.87),
            child: Transform.scale(
              scale: 1.5,
              child: RawMaterialButton(
                onPressed: () async {
                  await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditInfo(argUser: user)))
                      .then((result) {
                    if (result != null) {
                      setState(() {
                        user = result;
                      });
                    }
                  });
                },
                fillColor: Color.fromARGB(255, 90, 175, 90),
                elevation: 2.0,
                child: Icon(Icons.edit, size: 20, color: Colors.white),
                shape: CircleBorder(),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget showAbout() {
    if (user == null) return Container(width: 0, height: 0);
    if (user['about'] != null) {
      return Column(
        children: [
          SizedBox(height: 15),
          Divider(),
          Transform.translate(
            offset: Offset(0, 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${user['about']}',
                  style: TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 140, 140, 140),
                      fontWeight: FontWeight.w300)),
            ),
          ),
        ],
      );
    } else
      return Container(width: 0, height: 0);
  }

  Widget showJobCompanySelector() {
    if (user['company'] != null && user['job'] != null) {
      return Text('${user['job']} at ${user['company']}',
          style: TextStyle(
              fontSize: 17,
              color: Color.fromARGB(255, 140, 140, 140),
              fontWeight: FontWeight.w300));
    } else if (user['company'] == null && user['job'] != null) {
      return Text('${user['job']}',
          style: TextStyle(
              fontSize: 17,
              color: Color.fromARGB(255, 140, 140, 140),
              fontWeight: FontWeight.w300));
    } else {
      return Text('${user['company']}',
          style: TextStyle(
              fontSize: 17,
              color: Color.fromARGB(255, 140, 140, 140),
              fontWeight: FontWeight.w300));
    }
  }

  Widget showInfos(String field, IconData icon) {
    if (user == null) return Container(width: 0, height: 0);
    if (user[field] != null) {
      return Transform.translate(
        offset: Offset(12, 5),
        child: Row(children: [
          Transform.scale(
              scale: 0.8,
              child: Icon(icon, color: Color.fromARGB(175, 140, 140, 140))),
          SizedBox(width: 5),
          Text('${user[field]}',
              style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 140, 140, 140),
                  fontWeight: FontWeight.w300)),
        ]),
      );
    } else
      return Container(width: 0, height: 0);
  }

  Widget showJobCompany() {
    if (user == null) return Container(width: 0, height: 0);
    if (user['company'] != null || user['job'] != null) {
      return Transform.translate(
        offset: Offset(12, 5),
        child: Row(children: [
          Transform.scale(
              scale: 0.8,
              child:
                  Icon(Icons.work, color: Color.fromARGB(150, 150, 150, 150))),
          SizedBox(width: 5),
          showJobCompanySelector(),
        ]),
      );
    } else
      return Container(width: 0, height: 0);
  }

  Widget showAge(var age) {
    if (user['showage'] == '0') {
      return Text(
        ', ${age.toString()}',
        style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 80, 80, 80)),
      );
    } else
      return Container(width: 0, height: 0);
  }

  Widget nameAge(var age) {
    if (user != null) {
      return Row(children: [
        Text(
          '${user['firstname']}',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 80, 80, 80)),
        ),
        showAge(age),
      ]);
    } else
      return Text('');
  }

  List<Widget> displayImages() {
    List<Widget> userphotos = List<Widget>();
    String photo;
    String address;
    int i = 1;
    if (user != null) for (; user['photo$i'] != null && i < 10; i++) {}
    for (int list = 1; list < i; list++) {
      photo = user['photo$list'];
      address = 'http://192.168.31.37/pindur/$photo';
      userphotos
          .add(FittedBox(child: Image.network(address), fit: BoxFit.fill));
    }
    return userphotos;
  }
}
