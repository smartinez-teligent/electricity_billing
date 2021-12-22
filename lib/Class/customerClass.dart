import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'apiTokenClass.dart';

Future<dynamic> getCustomer(String customerid) async {
  await dotenv.load();
  var tk = await token();
  final response = await http.get(
    Uri.parse(
        '${dotenv.get("HOST").toString()}/customer/${customerid.toString()}'),
    headers: <String, String>{'Authorization': 'Bearer ${tk.toString()}'},
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)[0]['meterids']
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "");
  } else {
    print('Bearer ${tk.toString()}');
    throw Exception('Error.');
  }
}

Future<dynamic> updateCustomer(String user, String customerid, String meterids,
    String customertoken) async {
  await dotenv.load();
  var tk = await token();
  print(tk);
  final response = await http.post(
    Uri.parse('${dotenv.get("HOST").toString()}/customer'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tk.toString()}'
    },
    body: jsonEncode(<String, String>{
      "user": user,
      "customerid": customerid,
      "meterids": meterids,
      "customertoken": customertoken
    }),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    print('Bearer ${tk.toString()}');
    throw Exception('Error.');
  }
}

Future<dynamic> getCustomerBills(String customerid) async {
  await dotenv.load();
  var tk = await token();
  final response = await http.get(
    Uri.parse(
        '${dotenv.get("HOST").toString()}/customer/bills/${customerid.toString()}'),
    headers: <String, String>{'Authorization': 'Bearer ${tk.toString()}'},
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print('Bearer ${tk.toString()}');
    throw Exception('Error.');
  }
}

Future<dynamic> payBills(String billingID, String amount, String OTP) async {
  await dotenv.load();
  var tk = await token();
  print(tk);
  final response = await http.post(
    Uri.parse(
        '${dotenv.get("HOST").toString()}/payments?telegramID=930113219&OTP=${OTP.toString()}'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tk.toString()}'
    },
    body: jsonEncode(<String, String>{
      "billingid": billingID,
      "paymentmethod": "CASH",
      "amount": amount
    }),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    print(response.statusCode);
    print('Bearer ${tk.toString()}');
    throw Exception('Error.');
  }
}

Future<dynamic> requestOTP() async {
  await dotenv.load();
  var tk = await token();
  print(tk);
  final response = await http.get(
      Uri.parse('${dotenv.get("HOST").toString()}/getOTP?telegramID=930113219'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${tk.toString()}'
      });
  if (response.statusCode == 200) {
    return response.body;
  } else {
    print(response.statusCode);
    print('Bearer ${tk.toString()}');
    throw Exception('Error.');
  }
}
