import 'package:flutter/material.dart';

class DeleteOutcomeBillDialog extends StatelessWidget {
  final String title;
  final String content;
  final Future<void> Function() onConfirm;

  const DeleteOutcomeBillDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      backgroundColor: Colors.blue[50], // Light blue background for contrast
      title: Text(
        title,
        style: TextStyle(
          color: Colors.blue[900], // Darker blue for the title
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            content,
            style: TextStyle(
              color: Colors.blue[700], // Slightly darker blue for content
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue[900],
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[600], // White text on blue button
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 5, // Subtle shadow for depth
          ),
          child: Text("Sure!"),
          onPressed: () async {
            await onConfirm();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
