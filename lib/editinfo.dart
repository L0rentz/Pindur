import 'package:pindur/api.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'gallery.dart';

class EditInfo extends StatefulWidget {
  final Map argUser;
  EditInfo({this.argUser});
  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  Map user;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        user = widget.argUser;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            highlightColor: Colors.white,
            splashColor: Colors.white,
            onPressed: () {
              Navigator.pop(context, user);
            },
            icon: Transform.scale(
                scale: 1.1,
                child: Container(
                    child: Icon(Icons.keyboard_return,
                        color: Theme.of(context).textSelectionColor)))),
        elevation: 1.0,
        backgroundColor: Colors.white,
        title: Text('Edit Profile',
            style: TextStyle(color: Color.fromARGB(255, 75, 75, 75))),
      ),
      body: Stack(children: [
        GridView.count(
            childAspectRatio: 0.67,
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            crossAxisCount: 3,
            children: <Widget>[
              gridContainer('1'),
              gridContainer('2'),
              gridContainer('3'),
              gridContainer('4'),
              gridContainer('5'),
              gridContainer('6'),
              gridContainer('7'),
              gridContainer('8'),
              gridContainer('9'),
            ]),
        Transform.translate(
            offset: Offset(20, 558),
            child: Container(
              width: 355,
              height: 48,
              child: addMedia(),
            )),
      ]),
    );
  }

  Widget addMedia() {
    if (user != null && user['photo9'] == null) {
      return FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          onPressed: () async {
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
          },
          child: Text('Add Media', style: TextStyle(color: Colors.white)),
          color: Theme.of(context).textSelectionColor);
    } else
      return (Container(width: 0, height: 0));
  }

  String imageAddress(String id) {
    if (user != null && user['photo$id'] != null) {
      String photo = user['photo$id'];
      String address = 'http://192.168.31.37/pindur/$photo';
      return address;
    } else
      return 'assets/images/bg.jpg';
  }

  Widget gridContainer(String id) {
    String image = imageAddress(id);
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(10),
      dashPattern: [8, 5],
      strokeWidth: 3,
      color: Color.fromARGB(255, 225, 225, 225),
      child: Stack(children: [
        GestureDetector(
          onTap: () async {
            if (image == 'assets/images/bg.jpg') {
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
              await deleteImage(id, user['email']);
              setState(() {
                user['photo$id'] = null;
                fillEmptyImageSlot(id);
              });
            }
          },
          child: Container(
              child: Transform.translate(
                  offset: Offset(0, 1),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: returnImage(image))),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 240, 240),
                  borderRadius: BorderRadius.all(Radius.circular(8)))),
        ),
        addDeleteIcon(image, id),
      ]),
    );
  }

  Widget addDeleteIcon(String address, String id) {
    if (address == 'assets/images/bg.jpg')
      return Transform.translate(
          offset: Offset(86, 139),
          child: Transform.scale(
            scale: 1.1,
            child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      )
                    ],
                    shape: BoxShape.circle,
                    color: Theme.of(context).textSelectionColor),
                child: Transform.scale(
                    scale: 0.8, child: Icon(Icons.add, color: Colors.white))),
          ));
    else
      return Transform.translate(
          offset: Offset(86, 139),
          child: Transform.scale(
            scale: 1.1,
            child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ], shape: BoxShape.circle, color: Colors.white),
                child: Transform.scale(
                    scale: 0.8,
                    child: Transform.rotate(
                        angle: 0.8,
                        child: Icon(Icons.add,
                            color: Theme.of(context).textSelectionColor)))),
          ));
  }

  void fillEmptyImageSlot(String id) {
    int index = 9;
    while (user['photo$index'] == null && index > 0) index--;
    if (id != index.toString()) {
      int i = 1;
      while (i != index && i < 10) {
        if (user['photo$i'] == null) {
          int next = i + 1;
          user['photo$i'] = user['photo$next'];
          user['photo$next'] = null;
        }
        i++;
      }
    }
  }

  Widget returnImage(String address) {
    if (address == 'assets/images/bg.jpg')
      return Image.asset(address);
    else
      return Image.network(address);
  }
}
