import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'apiTokenClass.dart';

Future<dynamic> getAllCustomer() async {
  await dotenv.load();
  var tk = await token();
  final response = await http.get(
    Uri.parse('${dotenv.get("HOST").toString()}/customer'),
    headers: <String, String>{'Authorization': 'Bearer ${tk.toString()}'},
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print('Bearer ${tk.toString()}');
    throw Exception('Error.');
  }
}

Future<dynamic> updateCustomerBill(
    String id, String reading, String dueDate) async {
  await dotenv.load();
  var tk = await token();
  print(tk);
  final response = await http.put(
    Uri.parse('${dotenv.get("HOST").toString()}/bills/${id.toString()}'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tk.toString()}'
    },
    body: jsonEncode(<String, String>{"reading": reading, "duedate": dueDate}),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print(response.statusCode);
    print('Bearer ${tk.toString()}');
    throw Exception('Error.');
  }
}
