import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<dynamic> notification(String deviceToken) async {
  await dotenv.load();
  final response =
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization":
                'key=AAAAaG2H_5E:APA91bG9beIGpybCbeyLMbOrUD35iwmIEIxHMlcYt0QvE4pJSBhJ-8kEL0BbWy5y1WAq8cSFdyHaD46kfeLU4N6DbRU983HpAYavmzF35ve-HzlXscmb42V_RJmvj3J-Wyfj4jgl0psz'
          },
          body: jsonEncode(<String, dynamic>{
            "to": deviceToken,
            "collapse_key": "New Message",
            "priority": "high",
            "notification": {
              "title": "Bills Payment",
              "body": "Your bills is now updated."
            }
          }));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Error.');
  }
}
