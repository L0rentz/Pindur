import 'package:http/http.dart' as http;
import 'dart:convert';

Future loginUser(String email, String password) async {
  String url = 'http://192.168.31.37/pindur/login.php';
  final response = await http.post(
    url,
    headers: {"Accept": "Application/json"},
    body: {'email': email, 'password': password},
  );
  var convertedDatatoJson = jsonDecode(response.body);
  return convertedDatatoJson;
}

Future createUser(String email, String password, String firstname,
    String birthdate, String gender) async {
  String url = 'http://192.168.31.37/pindur/createuser.php';
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
}

Future uploadImage(String fileName, String base64Image, String id, String email) async {
  String url = 'http://192.168.31.37/pindur/uploadimage.php';
  String field = 'photo$id';
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
}

Future deleteImage(String id, String email) async {
  String url = 'http://192.168.31.37/pindur/deleteimage.php';
  final response = await http.post(
    url,
    headers: {"Accept": "Application/json"},
    body: {
      'id': id,
      'email': email,
    },
  );
  return response;
}