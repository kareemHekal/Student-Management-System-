import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../colors_app.dart';
import '../firebase/firebase_functions.dart';
import '../models/Studentmodel.dart';
import '../pages/EditStudent.dart';

class Smallstydentcard extends StatelessWidget {
  final Studentmodel studentModel;
  final String? grade;
  const Smallstydentcard({required this.studentModel, required this.grade,super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                    primary: Colors.red, // Primary color for the dialog
                  ),
                ),
                child: AlertDialog(
                  backgroundColor: Colors.red[100], // Light red background
                  title: Text(
                    "Delete Student",
                    style: TextStyle(
                      color: Colors.red[900], // Darker red for title
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    "Are you sure you want to delete this student?",
                    style: TextStyle(
                        color:
                        Colors.red[800]), // Slightly darker red for content
                  ),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red[900], // Dark red for text
                      ),
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red[
                        700], // Darker red background for delete button
                      ),
                      child: Text("Delete"),
                      onPressed: () {
                        FirebaseFunctions.deleteStudentFromHisCollection(
                            studentModel.grade??"", studentModel.id);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EditStudentScreen(
              student: studentModel,
              grade: grade,
            );
          }));
        },
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: app_colors.white,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    QrImageView(
                      data: studentModel.id ?? 'default_id',
                      version: QrVersions.auto,
                      size: 210.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildInfoRow(context, studentModel.name ?? 'N/A'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(context,  String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: app_colors.green.withOpacity(0.5),
              // Highlight (mark) color when selecting text
              cursorColor: app_colors.green, // Cursor color
            ),
          ),
          child: SelectableText(
            value,
            style: const TextStyle(
              color: app_colors.black,
              fontSize: 25,
            ),
          ),
        ),
      ],
    );
  }
}
