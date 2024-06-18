import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PushNotificationPage extends StatefulWidget {
  @override
  _PushNotificationPageState createState() => _PushNotificationPageState();
}

class _PushNotificationPageState extends State<PushNotificationPage> {
  final TextEditingController _messageController = TextEditingController();

  Future<void> sendPushNotification(String message) async {
    final String appId = '3425c9d3-0625-4951-b9bb-619ec9dfb6a7';
    final String apiKey = 'ZGY4YmZjOGUtZmM3Zi00Njg3LWFiYWUtNzA1MzAzNjQ1OWMw';

    final Map<String, dynamic> data = {
      'app_id': appId,
      'included_segments': ['Active Users'],
      'contents': {'en': message},
      'headings': {'en': 'Push Notification'},
    };

    final Uri uri = Uri.parse('https://onesignal.com/api/v1/notifications');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Basic $apiKey'
    };

    try {
      final response =
          await http.post(uri, headers: headers, body: json.encode(data));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Push Notification Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Enter message',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final String message = _messageController.text;
                sendPushNotification(message);
              },
              child: Text('Send Push Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
