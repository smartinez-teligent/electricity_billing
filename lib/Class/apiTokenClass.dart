import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<dynamic> token() async {
  // return "";
  await dotenv.load();
  Map<String, dynamic> jsonMap = {
    'grant_type': "client_credentials",
    'client_id': "SJ2Q_3d1cD5FfTiZXOnLgLZiLKIa",
    "client_secret": "PeOVRwfxuNBYZ98fshu6tMqqlAoa"
  };
  final response =
      await http.post(Uri.parse('${dotenv.get("HOSTTOKEN").toString()}'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: jsonMap);

  if (response.statusCode == 200) {
    var tk = jsonDecode(response.body);
    return tk['access_token'];
  } else {
    throw Exception('Error.');
  }
}
