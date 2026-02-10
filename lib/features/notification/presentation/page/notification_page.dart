import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/features/notification/presentation/page/detail_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await setupFirebaseMessaging();
    });
  }

  Future<void> setupFirebaseMessaging() async {
    final messaging = FirebaseMessaging.instance;

    // 1. request permission
    await messaging.requestPermission();

    // 2. terminated state: user clicks notification while app was closed
    RemoteMessage? initialMessage = await messaging.getInitialMessage();

    if (initialMessage != null) {
      // navigate to certain screen or detail screen
      _handleNavigation(initialMessage);
    }

    // 3. background state: app is open and notification arrives
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNavigation(message);
    });

    // 4. foreground state:
    FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification?.title;
      final description = message.notification?.body;

      if (title != null && description != null) {
        _showForegroundDialog(title, description);
      }
    });
  }

  void _showForegroundDialog(String title, String body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),

          TextButton(
            onPressed: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailPage(title: title, description: body),
                ),
              );
            },
            child: Text('View'),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(RemoteMessage message) {
    final title = message.notification?.title;
    final description = message.notification?.body;

    final data = message.data;

    log('Data from firebase console message: $data');
    if (title != null && description != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DetailPage(title: title, description: description),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Notification page")));
  }
}
