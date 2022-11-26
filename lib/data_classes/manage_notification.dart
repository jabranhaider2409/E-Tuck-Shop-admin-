import 'package:http/http.dart' as http;
import 'dart:convert';

class Notifications {
  static Future<void> sendPushMessage(
      {String? title, String? body, String? thisDeviceToken}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA0DBBnvM:APA91bFko6vDd-ZqgcntwnSD_b304K9fpGlCSqv9CtnsS-bLIPeL06eivCobNJBtiDqTciz2yCwPeLlcfUFHkBsp1FQrLZQ_ZCnnornRtrCDtTq1qmZ9nJJEbM1pyAzwIPe20NC3qNXK',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": "$thisDeviceToken",
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }
}
