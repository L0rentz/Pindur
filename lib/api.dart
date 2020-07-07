import 'package:http/http.dart' as http;
import 'dart:convert';

Future loginUser(String email, String password) async {
  String url = 'http://192.168.31.37/pindur/login.php';
  try {
    final response = await http.post(
      url,
      headers: {"Accept": "Application/json"},
      body: {'email': email, 'password': password},
    );
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  } catch (e) {
    return (null);
  }
}

Future createUser(String email, String password, String firstname,
    String birthdate, String gender) async {
  String url = 'http://192.168.31.37/pindur/createuser.php';
  try {
    final response = await http.post(
      url,
      headers: {"Accept": "Application/json"},
      body: {
        'firstname': firstname,
        'gender': gender,
        'birthdate': birthdate,
        'email': email,
        'password': password
      },
    );
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  } catch (e) {}
}

Future uploadImage(
    String fileName, String base64Image, String id, String email) async {
  String url = 'http://192.168.31.37/pindur/uploadimage.php';
  String field = 'photo$id';
  try {
    final response = await http.post(
      url,
      headers: {"Accept": "Application/json"},
      body: {
        'email': email,
        'field': field,
        'image': base64Image,
        'name': fileName,
      },
    );
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  } catch (e) {
    return (null);
  }
}

Future deleteImage(String id, String email) async {
  String url = 'http://192.168.31.37/pindur/deleteimage.php';
  try {
    final response = await http.post(
      url,
      headers: {"Accept": "Application/json"},
      body: {
        'id': id,
        'email': email,
      },
    );
    return response;
  } catch (e) {
    return (null);
  }
}

Future editProfile(String email, String about, String job, String company,
    String school, String city, String gender, int showage) async {
  String url = 'http://192.168.31.37/pindur/editprofile.php';
  try {
    final response = await http.post(
      url,
      headers: {"Accept": "Application/json"},
      body: {
        'email': email,
        'about': about,
        'job': job,
        'company': company,
        'school': school,
        'city': city,
        'gender': gender,
        'showage': showage.toString()
      },
    );
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  } catch (e) {
    return null;
  }
}
