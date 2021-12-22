import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'apiTokenClass.dart';

Future<dynamic> loginAuth(String email, String password) async {
  await dotenv.load();
  var tk = await token();
  print(tk);
  final response = await http.post(
    Uri.parse('${dotenv.get("HOST").toString()}/auth'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tk.toString()}'
    },
    body: jsonEncode(<String, String>{"email": email, "password": password}),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return null;
  }
}
