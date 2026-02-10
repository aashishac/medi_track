import 'package:flutter/material.dart';

class SendNotificationPage extends StatelessWidget {
  const SendNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Send Notification')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 15),
            TextField(
              controller: bodyCtrl,
              decoration: const InputDecoration(labelText: 'Message'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                /// call cloud function here
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
