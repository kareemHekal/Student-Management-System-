import 'package:flutter/material.dart';
import '../firebase/firebase_functions.dart';

class StartNewMonthDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Start a New Month',
        style: TextStyle(color: Colors.green[900],fontSize: 20),
      ),
      content: Text(
        'Are you sure you want to reset the attendance for all students?',
        style: TextStyle(color: Colors.green[800],fontSize: 12),
      ),
      actions: [
        TextButton(
          child: Text('Cancel', style: TextStyle(color: Colors.green[400])),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text(
            'Confirm',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            Navigator.pop(context);
            await FirebaseFunctions.resetAttendanceForAllStudents();
          },
        ),
      ],
      backgroundColor: Colors.green[50],
    );
  }
}
