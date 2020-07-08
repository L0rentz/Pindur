import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:convert';
import 'api.dart';
import 'blurrydialog.dart';
import 'loading.dart';

class Gallery extends StatefulWidget {
  final user;
  Gallery({this.user});
  @override
  GalleryState createState() => GalleryState();
}

class GalleryState extends State<Gallery> {
  bool cropped = false;
  String base64Image;
  File _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  bool loading = false;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: null,
        maxHeight: null,
        imageQuality: 100,
      );
      setState(() {
        cropped = false;
        _imageFile = File(pickedFile.path);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Image.file(_imageFile);
    } else if (_pickImageError != null) {
      return Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.image) {
        setState(() {
          _imageFile = File(response.file.path);
        });
      }
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading1()
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context, widget.user);
                  },
                  icon: Transform.scale(
                      scale: 1.1,
                      child: Container(
                          child: Icon(Icons.keyboard_return,
                              color: Theme.of(context).textSelectionColor)))),
              elevation: 1.0,
              backgroundColor: Colors.white,
              title: Text('Gallery',
                  style: TextStyle(color: Color.fromARGB(255, 75, 75, 75))),
              flexibleSpace: validateImage(),
            ),
            body: Center(
                child: defaultTargetPlatform == TargetPlatform.android
                    ? FutureBuilder<void>(
                        future: retrieveLostData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return const Text(
                                'You have not yet picked an image.',
                                textAlign: TextAlign.center,
                              );
                            case ConnectionState.done:
                              return _previewImage();
                            default:
                              if (snapshot.hasError) {
                                return Text(
                                  'You have not yet picked an image.',
                                  textAlign: TextAlign.center,
                                );
                              } else {
                                return const Text(
                                  'You have not yet picked an image.',
                                  textAlign: TextAlign.center,
                                );
                              }
                          }
                        },
                      )
                    : _previewImage()),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (_imageFile != null && cropped == false)
                  FloatingActionButton(
                    backgroundColor: Theme.of(context).textSelectionColor,
                    onPressed: () {
                      _cropImage();
                    },
                    heroTag: 'image2',
                    tooltip: 'Crop a photo',
                    child: const Icon(Icons.crop, color: Colors.white),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FloatingActionButton(
                    backgroundColor: Color.fromARGB(255, 175, 175, 175),
                    onPressed: () {
                      _onImageButtonPressed(ImageSource.gallery,
                          context: context);
                    },
                    heroTag: 'image0',
                    tooltip: 'Pick Image from gallery',
                    child: const Icon(Icons.photo_library, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FloatingActionButton(
                    backgroundColor: Color.fromARGB(255, 175, 175, 175),
                    onPressed: () {
                      _onImageButtonPressed(ImageSource.camera,
                          context: context);
                    },
                    heroTag: 'image1',
                    tooltip: 'Take a Photo',
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        compressQuality: 100,
        aspectRatio: CropAspectRatio(ratioX: 6.68, ratioY: 10),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.white,
            backgroundColor: Colors.white,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      setState(() {
        _imageFile = croppedFile;
        cropped = true;
      });
    }
  }

  String countPhotoId(final user) {
    var i = 1;
    for (; i < 10; i++) {
      if (i == 9) break;
      String id = i.toString();
      if (user['photo$id'] == null) break;
    }
    String nb = i.toString();
    return (nb);
  }

  Widget validateImage() {
    if (cropped == true) {
      return (Transform.translate(
        offset: Offset(160, 38),
        child: IconButton(
            highlightColor: Colors.white,
            splashColor: Colors.white,
            onPressed: () async {
              loading = true;
              base64Image = base64.encode(_imageFile.readAsBytesSync());
              var newuser = await uploadImage(_imageFile.path.split('/').last,
                  base64Image, countPhotoId(widget.user), widget.user['email']);
              if (newuser == null) {
                loading = false;
                setState(() {
                  BlurryError alert = BlurryError('Error',
                      'There was an error uploading your picture.\nPlease try again.');
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                });
              } else {
                Navigator.pop(context, newuser['user_arr']);
              }
            },
            icon: Transform.scale(
                scale: 1.5,
                child: Container(
                    child: Icon(Icons.check,
                        color: Theme.of(context).textSelectionColor)))),
      ));
    } else
      return Container(width: 0, height: 0);
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}
