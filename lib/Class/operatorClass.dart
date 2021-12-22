import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'apiTokenClass.dart';

Future<dynamic> oprt(String userID, String customerID, String meterID,
    String consumption) async {
  await dotenv.load();
  var tk = await token();
  print(meterID);
  final response = await http.post(
    Uri.parse('${dotenv.get("HOST").toString()}/bills'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tk.toString()}'
    },
    body: jsonEncode(<String, String>{
      "userid": userID,
      "customerid": customerID,
      "meterid": meterID,
      "reading": consumption
    }),
  );
  print(jsonDecode(response.body)['customertoken'].toString());
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['customertoken'].toString();
  } else {
    print('Bearer ${tk.toString()}');
    throw Exception('Error.');
  }
}
