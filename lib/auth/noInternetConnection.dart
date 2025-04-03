import 'package:flutter/material.dart';
import '../colors_app.dart';

class NoConnectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_colors.orange, // Use your orange color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.signal_wifi_off, size: 80, color: app_colors.green), // Use your green color
            SizedBox(height: 20),
            Text(
              'You must have an internet connection first.',
              style: TextStyle(fontSize: 24, color: app_colors.green), // Use your green color
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
