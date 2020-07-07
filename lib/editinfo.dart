import 'package:pindur/api.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'gallery.dart';
import 'api.dart';
import 'loading.dart';
import 'blurrydialog.dart';

class EditInfo extends StatefulWidget {
  final Map argUser;
  final aboutController = TextEditingController();
  final jobController = TextEditingController();
  final companyController = TextEditingController();
  final cityController = TextEditingController();
  final schoolController = TextEditingController();
  final instagramController = TextEditingController();
  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 0);
  final _formKey = GlobalKey<FormState>();
  EditInfo({this.argUser});
  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  Map user;
  bool loading = false;
  String dropdownvalue;
  bool isSwitched = false;
  int showage;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        user = widget.argUser;
        dropdownvalue = user['gender'];
        if (user['showage'] == '1') {
          isSwitched = true;
          showage = 1;
        }
        else {
          isSwitched = false;
          showage = 0;
        }
        widget.aboutController.text = user['about'];
        widget.jobController.text = user['job'];
        widget.companyController.text = user['company'];
        widget.schoolController.text = user['school'];
        widget.cityController.text = user['city'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await saveEdit();
        return false;
      },
      child: loading
          ? Loading1()
          : Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    highlightColor: Colors.white,
                    splashColor: Colors.white,
                    onPressed: () async {
                      await saveEdit();
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
              body: Form(
                key: widget._formKey,
                child: ListView(
                  controller: widget.scrollController,
                  physics: BouncingScrollPhysics(),
                  children: [
                    GridView.count(
                        childAspectRatio: 0.67,
                        primary: false,
                        shrinkWrap: true,
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
                    SizedBox(height: 10),
                    Column(children: [
                      addMedia(),
                      SizedBox(height: 20),
                      checkUserNull(),
                      SizedBox(height: 10),
                      editFormField('Add Job Title', widget.jobController,
                          'Job Title', null, 1, 255, ''),
                      SizedBox(height: 20),
                      editFormField('Add Company', widget.companyController,
                          'Company', null, 1, 255, ''),
                      SizedBox(height: 20),
                      editFormField('Add School', widget.schoolController,
                          'School', null, 1, 255, ''),
                      SizedBox(height: 20),
                      editFormField('Add City', widget.cityController,
                          'Livin In', null, 1, 255, ''),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('I\'m a',
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: 16))),
                      ),
                      SizedBox(height: 5),
                      genreField(),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Transform.translate(
                              offset: Offset(10, 0),
                              child: Text('Control Your Profile',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          SizedBox(height: 5),
                          Stack(children: [
                            TextField(
                                decoration: InputDecoration(
                                    hintText: 'Don\'t Show My Age',
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 150, 190, 150)),
                                    filled: true,
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none)),
                            Transform.translate(
                              offset: Offset(MediaQuery.of(context).size.width * 0.83, 0),
                               child: Switch(
                                value: isSwitched,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched = value;
                                    if (isSwitched == true)
                                      showage = 1;
                                    else
                                      showage = 0;
                                  });
                                },
                                activeTrackColor: Color.fromARGB(255, 120, 200, 120),
                                activeColor: Theme.of(context).hintColor,
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ]),
                  ],
                ),
              ),
            ),
    );
  }

  Widget checkUserNull() {
    if (user != null)
      return (editFormField('About You', widget.aboutController,
          'About ${user['firstname']}', 2, null, 500, null));
    else
      return (editFormField(
          'About You', widget.aboutController, '', 2, null, 500, null));
  }

  Widget genreField() {
    return Container(
      color: Color.fromARGB(255, 245, 245, 245),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(10, 0, 50, 5),
      child: DropdownButton(
          underline:
              Container(color: Color.fromARGB(255, 125, 125, 125), height: 1),
          value: dropdownvalue,
          icon: Transform.translate(
              offset: Offset(MediaQuery.of(context).size.width * 0.45, 0),
              child: Transform.scale(
                scale: 1.3,
                child: Icon(Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 150, 150, 150)),
              )),
          items: <String>[
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

  Widget editFormField(String hintText, final controller, String titleText,
      int minLines, int maxLines, int maxLength, String counterText) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(10, 0),
            child: Text(titleText,
                textAlign: TextAlign.end, style: TextStyle(fontSize: 16)),
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            minLines: minLines,
            decoration: InputDecoration(
                hintText: hintText,
                counterText: counterText,
                hintStyle: TextStyle(color: Color.fromARGB(255, 190, 190, 190)),
                filled: true,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none)),
      ],
    );
  }

  Widget addMedia() {
    if (user != null && user['photo9'] == null) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 50,
        child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
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
            child: Text('Add Media',
                style: TextStyle(color: Colors.white, fontSize: 15)),
            color: Theme.of(context).textSelectionColor),
      );
    } else
      return (Container(width: 0, height: 0));
  }

  Future saveEdit() async {
    setState(() => loading = true);
    var rsp = await editProfile(
        user['email'],
        widget.aboutController.text,
        widget.jobController.text,
        widget.companyController.text,
        widget.schoolController.text,
        widget.cityController.text,
        dropdownvalue, showage);
    if (rsp != null && rsp.containsKey('status')) {
      if (rsp['status'] == 1) {
        setState(() {
          user = rsp['user_arr'];
          Navigator.pop(context, user);
        });
      }
    } else {
      setState(() {
        user['about'] = widget.aboutController.text;
        user['job'] = widget.jobController.text;
        user['company'] = widget.companyController.text;
        user['school'] = widget.schoolController.text;
        user['city'] = widget.cityController.text;
        BlurryError alert = BlurryError('Error',
            'There was an error updating your profile.\nPlease try again.');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
        loading = false;
      });
    }
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
              var rsp = await deleteImage(id, user['email']);
              if (rsp != null) {
                setState(() {
                  user['photo$id'] = null;
                  fillEmptyImageSlot(id);
                });
              } else {
                setState(() {
                  BlurryError alert = BlurryError('Error',
                      'There was an error deleting your picture.\nPlease try again.');
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      });
                });
              }
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

  @override
  void dispose() {
    widget.aboutController.dispose();
    widget.cityController.dispose();
    widget.companyController.dispose();
    widget.schoolController.dispose();
    widget.scrollController.dispose();
    widget.jobController.dispose();
    super.dispose();
  }
}
